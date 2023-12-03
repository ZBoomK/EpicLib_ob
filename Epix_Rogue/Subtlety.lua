local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (797 - (588 + 208))) or ((5287 - 3325) >= (4307 - (884 + 916)))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((159 + 115) == (4235 - (232 + 421)))) then
			v6 = v0[v4];
			if (not v6 or ((3807 - (1569 + 320)) == (264 + 811))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	local v27 = v10.Commons.Everyone.num;
	local v28 = v10.Commons.Everyone.bool;
	local v29 = pairs;
	local v30 = table.insert;
	local v31 = math.min;
	local v32 = math.max;
	local v33 = math.abs;
	local v34 = false;
	local v35 = false;
	local v36 = false;
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
	local function v83()
		v37 = EpicSettings.Settings['UseRacials'];
		v51 = EpicSettings.Settings['UseTrinkets'];
		v38 = EpicSettings.Settings['UseHealingPotion'];
		v39 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v40 = EpicSettings.Settings['HealingPotionHP'] or (605 - (316 + 289));
		v41 = EpicSettings.Settings['UseHealthstone'];
		v42 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v43 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
		v44 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (1453 - (666 + 787));
		v45 = EpicSettings.Settings['InterruptThreshold'] or (425 - (360 + 65));
		v47 = EpicSettings.Settings['PoisonRefresh'];
		v48 = EpicSettings.Settings['PoisonRefreshCombat'];
		v49 = EpicSettings.Settings['RangedMultiDoT'];
		v50 = EpicSettings.Settings['UsePriorityRotation'];
		v56 = EpicSettings.Settings['STMfDAsDPSCD'];
		v57 = EpicSettings.Settings['KidneyShotInterrupt'];
		v58 = EpicSettings.Settings['RacialsGCD'];
		v59 = EpicSettings.Settings['RacialsOffGCD'];
		v60 = EpicSettings.Settings['VanishOffGCD'];
		v61 = EpicSettings.Settings['ShadowDanceOffGCD'];
		v62 = EpicSettings.Settings['ThistleTeaOffGCD'];
		v63 = EpicSettings.Settings['ColdBloodOffGCD'];
		v64 = EpicSettings.Settings['MarkedforDeathOffGCD'];
		v65 = EpicSettings.Settings['CrimsonVialHP'];
		v66 = EpicSettings.Settings['FeintHP'];
		v67 = EpicSettings.Settings['StealthOOC'];
		v68 = EpicSettings.Settings['CrimsonVialGCD'];
		v69 = EpicSettings.Settings['FeintGCD'];
		v70 = EpicSettings.Settings['KickOffGCD'];
		v71 = EpicSettings.Settings['StealthOffGCD'];
		v72 = EpicSettings.Settings['EviscerateDMGOffset'] or true;
		v73 = EpicSettings.Settings['ShDEcoCharge'];
		v74 = EpicSettings.Settings['BurnShadowDance'];
		v75 = EpicSettings.Settings['PotionTypeSelectedSubtlety'];
		v76 = EpicSettings.Settings['ShurikenTornadoGCD'];
		v77 = EpicSettings.Settings['SymbolsofDeathOffGCD'];
		v78 = EpicSettings.Settings['ShadowBladesOffGCD'];
		v79 = EpicSettings.Settings['VanishStealthMacro'];
		v80 = EpicSettings.Settings['ShadowmeldStealthMacro'];
		v81 = EpicSettings.Settings['ShadowDanceStealthMacro'];
	end
	local v84 = v10.Commons.Everyone;
	local v85 = v10.Commons.Rogue;
	local v86 = v17.Rogue.Subtlety;
	local v87 = v19.Rogue.Subtlety;
	local v88 = v25.Rogue.Subtlety;
	local v89 = {};
	local v90, v91, v92, v93;
	local v94, v95, v96, v97, v98;
	local v99;
	local v100, v101, v102;
	local v103, v104;
	local v105, v106, v107, v108;
	local v109;
	v86.Eviscerate:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v105 * (0.176 + 0) * (255.21 - (79 + 175)) * ((v86.Nightstalker:IsAvailable() and v13:StealthUp(true, false) and (1.08 - 0)) or (1 + 0)) * ((v86.DeeperStratagem:IsAvailable() and (2.05 - 1)) or (1 - 0)) * ((v86.DarkShadow:IsAvailable() and v13:BuffUp(v86.ShadowDanceBuff) and (900.3 - (503 + 396))) or (182 - (92 + 89))) * ((v13:BuffUp(v86.SymbolsofDeath) and (1.1 - 0)) or (1 + 0)) * ((v13:BuffUp(v86.FinalityEviscerateBuff) and (1.3 + 0)) or (3 - 2)) * (1 + 0 + (v13:MasteryPct() / (228 - 128))) * (1 + 0 + (v13:VersatilityDmgPct() / (48 + 52))) * ((v14:DebuffUp(v86.FindWeaknessDebuff) and (2.5 - 1)) or (1 + 0));
	end);
	v86.Rupture:RegisterPMultiplier(function()
		return (v13:BuffUp(v86.FinalityRuptureBuff) and (1.3 - 0)) or (1245 - (485 + 759));
	end);
	local function v110(v165)
		if (((916 - 520) <= (4993 - (442 + 747))) and not v102) then
			v102 = v165;
		end
	end
	local function v111()
		if (((v74 == "On Bosses not in Dungeons") and v13:IsInDungeonArea()) or ((5304 - (832 + 303)) == (3133 - (88 + 858)))) then
			return false;
		elseif (((429 + 977) == (1164 + 242)) and (v74 ~= "Always") and not v14:IsInBossList()) then
			return false;
		else
			return true;
		end
	end
	local function v112()
		local v166 = 0 + 0;
		while true do
			if (((2320 - (766 + 23)) < (21084 - 16813)) and (v166 == (0 - 0))) then
				if (((1673 - 1038) == (2155 - 1520)) and (v96 < (1075 - (1036 + 37)))) then
					return false;
				elseif (((2392 + 981) <= (6924 - 3368)) and (v50 == "Always")) then
					return true;
				elseif (((v50 == "On Bosses") and v14:IsInBossList()) or ((2589 + 702) < (4760 - (641 + 839)))) then
					return true;
				elseif (((5299 - (910 + 3)) >= (2225 - 1352)) and (v50 == "Auto")) then
					if (((2605 - (1466 + 218)) <= (507 + 595)) and (v13:InstanceDifficulty() == (1164 - (556 + 592))) and (v14:NPCID() == (49416 + 89551))) then
						return true;
					elseif (((5514 - (329 + 479)) >= (1817 - (174 + 680))) and ((v14:NPCID() == (573734 - 406765)) or (v14:NPCID() == (346086 - 179115)) or (v14:NPCID() == (119212 + 47758)))) then
						return true;
					elseif ((v14:NPCID() == (184202 - (396 + 343))) or (v14:NPCID() == (16251 + 167420)) or ((2437 - (29 + 1448)) <= (2265 - (135 + 1254)))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v113(v167, v168, v169, v170, v171)
		local v172 = 0 - 0;
		local v173;
		local v174;
		local v175;
		while true do
			if ((v172 == (4 - 3)) or ((1377 + 689) == (2459 - (389 + 1138)))) then
				for v217, v218 in v29(v170) do
					if (((5399 - (102 + 472)) < (4571 + 272)) and (v218:GUID() ~= v175) and v84.UnitIsCycleValid(v218, v174, -v218:DebuffRemains(v167)) and v168(v218)) then
						v173, v174 = v218, v218:TimeToDie();
					end
				end
				if ((v173 and v14 and v14:Exists() and (v173:GUID() == v14:GUID())) or ((2150 + 1727) >= (4231 + 306))) then
					if (v26(v167) or ((5860 - (320 + 1225)) < (3072 - 1346))) then
						return "dot spell target";
					end
				elseif ((v173 and v16 and v16:Exists() and (v173:GUID() == v16:GUID())) or ((2252 + 1427) < (2089 - (157 + 1307)))) then
					if (v26(v171) or ((6484 - (821 + 1038)) < (1576 - 944))) then
						return "dot spell mouseover";
					end
				end
				break;
			end
			if ((v172 == (0 + 0)) or ((146 - 63) > (663 + 1117))) then
				v173, v174 = nil, v169;
				v175 = v14:GUID();
				v172 = 2 - 1;
			end
		end
	end
	local function v114()
		return (1051 - (834 + 192)) + (v27(v86.Vigor:IsAvailable()) * (2 + 18)) + (v27(v86.MasterofShadows:IsAvailable()) * (6 + 14)) + (v27(v86.ShadowFocus:IsAvailable()) * (1 + 24)) + (v27(v86.Alacrity:IsAvailable()) * (30 - 10)) + (v27(v96 >= (308 - (300 + 4))) * (7 + 18));
	end
	local function v115()
		return v86.ShadowDance:ChargesFractional() >= ((0.75 - 0) + v21(v86.ShadowDanceTalent:IsAvailable()));
	end
	local function v116()
		if (((908 - (112 + 250)) <= (430 + 647)) and (v96 == ((9 - 5) - v27(v86.SealFate:IsAvailable())))) then
			return true;
		elseif ((v96 > ((3 + 1) - ((2 + 0) * v21(v86.ShurikenTornado:IsAvailable())))) or (v109 and (v96 >= (3 + 1))) or ((494 + 502) > (3196 + 1105))) then
			return v107 <= (1415 - (1001 + 413));
		else
			return v106 <= (2 - 1);
		end
	end
	local function v117()
		return v13:BuffUp(v86.SliceandDice) or (v96 >= v85.CPMaxSpend());
	end
	local function v118(v176)
		return (v13:BuffUp(v86.ThistleTea) and (v96 == (883 - (244 + 638)))) or (v176 and ((v96 == (694 - (627 + 66))) or (v14:DebuffUp(v86.Rupture) and (v96 >= (5 - 3)))));
	end
	local function v119()
		return (not v13:BuffUp(v86.Premeditation) and (v96 == (603 - (512 + 90)))) or not v86.TheRotten:IsAvailable() or (v96 > (1907 - (1665 + 241)));
	end
	local function v120()
		return v13:BuffDown(v86.PremeditationBuff) or (v96 > (718 - (373 + 344))) or ((v106 <= (1 + 1)) and v13:BuffUp(v86.TheRottenBuff) and not v13:HasTier(8 + 22, 5 - 3));
	end
	local function v121(v177, v178)
		return v177 and ((v13:BuffStack(v86.DanseMacabreBuff) >= (4 - 1)) or not v86.DanseMacabre:IsAvailable()) and (not v178 or (v96 ~= (1101 - (35 + 1064))));
	end
	local function v122(v179)
		return v13:BuffUp(v86.ShadowDanceBuff) and (v179:TimeSinceLastCast() < v86.ShadowDance:TimeSinceLastCast());
	end
	local function v123(v180, v181)
		local v182 = 0 + 0;
		local v183;
		local v184;
		local v185;
		local v186;
		local v187;
		local v188;
		while true do
			if (((8707 - 4637) > (3 + 684)) and (v182 == (1240 - (298 + 938)))) then
				if ((not v188 and v86.Rupture:IsCastable()) or ((1915 - (233 + 1026)) >= (4996 - (636 + 1030)))) then
					local v226 = 0 + 0;
					while true do
						if ((v226 == (0 + 0)) or ((741 + 1751) <= (23 + 312))) then
							if (((4543 - (55 + 166)) >= (497 + 2065)) and not v180 and v35 and not v109 and (v96 >= (1 + 1))) then
								local v241 = 0 - 0;
								local v242;
								while true do
									if (((298 - (36 + 261)) == v241) or ((6360 - 2723) >= (5138 - (34 + 1334)))) then
										v99 = v113(v86.Rupture, v242, (1 + 1) * v186, v97, v88.RuptureMouseover);
										if (v99 or ((1849 + 530) > (5861 - (1035 + 248)))) then
											return v99;
										end
										break;
									end
									if ((v241 == (21 - (20 + 1))) or ((252 + 231) > (1062 - (134 + 185)))) then
										v242 = nil;
										function v242(v246)
											return v84.CanDoTUnit(v246, v104) and v246:DebuffRefreshable(v86.Rupture, v103);
										end
										v241 = 1134 - (549 + 584);
									end
								end
							end
							if (((3139 - (314 + 371)) > (1984 - 1406)) and v92 and (v14:DebuffRemains(v86.Rupture) < (v86.SymbolsofDeath:CooldownRemains() + (978 - (478 + 490)))) and (v106 > (0 + 0)) and (v86.SymbolsofDeath:CooldownRemains() <= (1177 - (786 + 386))) and v85.CanDoTUnit(v14, v104) and v14:FilteredTimeToDie(">", (16 - 11) + v86.SymbolsofDeath:CooldownRemains(), -v14:DebuffRemains(v86.Rupture))) then
								if (((2309 - (1055 + 324)) < (5798 - (1093 + 247))) and v180) then
									return v86.Rupture;
								elseif (((589 + 73) <= (103 + 869)) and v86.Rupture:IsReady() and v10.Cast(v86.Rupture)) then
									return "Cast Rupture 2";
								end
							end
							break;
						end
					end
				end
				if (((17349 - 12979) == (14830 - 10460)) and v86.BlackPowder:IsCastable() and ((not v109 and (v96 >= (8 - 5))) or ((v96 == (4 - 2)) and v183 and v86.DanseMacabre:IsAvailable() and not v122(v86.BlackPowder)))) then
					if (v180 or ((1694 + 3068) <= (3316 - 2455))) then
						return v86.BlackPowder;
					elseif ((v86.BlackPowder:IsReady() and v26(v86.BlackPowder)) or ((4866 - 3454) == (3216 + 1048))) then
						return "Cast Black Powder";
					end
				end
				if ((v86.Eviscerate:IsCastable() and v92 and (v106 > (2 - 1))) or ((3856 - (364 + 324)) < (5901 - 3748))) then
					if (v180 or ((11940 - 6964) < (442 + 890))) then
						return v86.Eviscerate;
					elseif (((19364 - 14736) == (7411 - 2783)) and v86.Eviscerate:IsReady() and v26(v86.Eviscerate)) then
						return "Cast Eviscerate";
					end
				end
				v182 = 15 - 10;
			end
			if ((v182 == (1271 - (1249 + 19))) or ((49 + 5) == (1537 - 1142))) then
				if (((1168 - (686 + 400)) == (65 + 17)) and not v188 and v86.Rupture:IsCastable() and (v106 > (229 - (73 + 156)))) then
					if (((v96 == (1 + 0)) and v13:BuffUp(v86.FinalityRuptureBuff) and (v86.DarkBrew:IsAvailable() or v86.DanseMacabre:IsAvailable()) and (v86.ShadowDance:CooldownRemains() < (823 - (721 + 90))) and (v86.ShadowDance:ChargesFractional() <= (1 + 0))) or ((1886 - 1305) < (752 - (224 + 246)))) then
						if (v180 or ((7466 - 2857) < (4593 - 2098))) then
							return v86.Rupture;
						elseif (((209 + 943) == (28 + 1124)) and v86.Rupture:IsReady() and v10.Cast(v86.Rupture)) then
							return "Cast Rupture (Finality)";
						end
					end
				end
				if (((1393 + 503) <= (6802 - 3380)) and v86.ColdBlood:IsReady() and v121(v183, v187) and v86.SecretTechnique:IsReady()) then
					local v227 = 0 - 0;
					while true do
						if ((v227 == (513 - (203 + 310))) or ((2983 - (1238 + 755)) > (114 + 1506))) then
							if (v180 or ((2411 - (709 + 825)) > (8651 - 3956))) then
								return v88.SecretTechnique;
							end
							if (((3919 - 1228) >= (2715 - (196 + 668))) and v26(v88.SecretTechnique)) then
								return "Cast Cold Blood";
							end
							break;
						end
					end
				end
				if ((v86.SecretTechnique:IsReady() and v121(v183, v187) and (not v86.ColdBlood:IsAvailable() or v86.ColdBlood:IsReady() or v13:BuffUp(v86.ColdBlood) or (v86.ColdBlood:CooldownRemains() > (v184 - (7 - 5))))) or ((6183 - 3198) >= (5689 - (171 + 662)))) then
					local v228 = 93 - (4 + 89);
					while true do
						if (((14986 - 10710) >= (436 + 759)) and ((0 - 0) == v228)) then
							if (((1268 + 1964) <= (6176 - (35 + 1451))) and v180) then
								return v88.SecretTechnique;
							end
							if (v26(v88.SecretTechnique) or ((2349 - (28 + 1425)) >= (5139 - (941 + 1052)))) then
								return "Cast Secret Technique";
							end
							break;
						end
					end
				end
				v182 = 4 + 0;
			end
			if (((4575 - (822 + 692)) >= (4222 - 1264)) and (v182 == (0 + 0))) then
				v183 = v13:BuffUp(v86.ShadowDanceBuff);
				v184 = v13:BuffRemains(v86.ShadowDanceBuff);
				v185 = v13:BuffRemains(v86.SymbolsofDeath);
				v182 = 298 - (45 + 252);
			end
			if (((3154 + 33) >= (222 + 422)) and ((12 - 7) == v182)) then
				return false;
			end
			if (((1077 - (114 + 319)) <= (1010 - 306)) and (v182 == (2 - 0))) then
				if (((611 + 347) > (1410 - 463)) and v86.SliceandDice:IsCastable() and v10.FilteredFightRemains(v95, ">", v13:BuffRemains(v86.SliceandDice))) then
					if (((9411 - 4919) >= (4617 - (556 + 1407))) and v86.Premeditation:IsAvailable() and (v96 < (1211 - (741 + 465)))) then
						if (((3907 - (170 + 295)) >= (792 + 711)) and (v86.ShadowDance:ChargesFractional() < (1.75 + 0)) and (v13:BuffRemains(v86.SliceandDice) < v86.SymbolsofDeath:CooldownRemains()) and (v86.ShadowDance:Charges() >= (2 - 1)) and ((v185 - v184) < (1.2 + 0))) then
							if (v180 or ((2033 + 1137) <= (830 + 634))) then
								return v86.SliceandDice;
							elseif ((v86.SliceandDice:IsReady() and v10.Cast(v86.SliceandDice)) or ((6027 - (957 + 273)) == (1174 + 3214))) then
								return "Cast Slice and Dice (Premed)";
							end
						end
					elseif (((221 + 330) <= (2594 - 1913)) and (v96 < (15 - 9)) and not v183 and (v13:BuffRemains(v86.SliceandDice) < ((2 - 1) + (v186 * (4.8 - 3))))) then
						if (((5057 - (389 + 1391)) > (256 + 151)) and v180) then
							return v86.SliceandDice;
						elseif (((489 + 4206) >= (3221 - 1806)) and v86.SliceandDice:IsReady() and v10.Cast(v86.SliceandDice)) then
							return "Cast Slice and Dice";
						end
					end
				end
				v188 = v118(v183);
				if (((not v188 or v109) and v86.Rupture:IsCastable() and v14:DebuffRefreshable(v86.Rupture, v103) and (v106 > (951 - (783 + 168)))) or ((10779 - 7567) <= (929 + 15))) then
					if ((v92 and (v14:FilteredTimeToDie(">", 317 - (309 + 2), -v14:DebuffRemains(v86.Rupture)) or v14:TimeToDieIsNotValid()) and v85.CanDoTUnit(v14, v104) and v14:DebuffRefreshable(v86.Rupture, v103)) or ((9507 - 6411) <= (3010 - (1090 + 122)))) then
						if (((1147 + 2390) == (11878 - 8341)) and v180) then
							return v86.Rupture;
						elseif (((2626 + 1211) >= (2688 - (628 + 490))) and v86.Rupture:IsReady() and v10.Cast(v86.Rupture)) then
							return "Cast Rupture 1";
						end
					end
				end
				v182 = 1 + 2;
			end
			if ((v182 == (2 - 1)) or ((13481 - 10531) == (4586 - (431 + 343)))) then
				v186 = v106;
				v187 = v13:BuffUp(v86.PremeditationBuff) or (v181 and v86.Premeditation:IsAvailable());
				if (((9538 - 4815) >= (6705 - 4387)) and v181 and (v181:ID() == v86.ShadowDance:ID())) then
					v183 = true;
					v184 = 7 + 1 + v86.ImprovedShadowDance:TalentRank();
					if (v86.TheFirstDance:IsAvailable() or ((260 + 1767) > (4547 - (556 + 1139)))) then
						v186 = v31(v13:ComboPointsMax(), v106 + (19 - (6 + 9)));
					end
					if (v13:HasTier(6 + 24, 2 + 0) or ((1305 - (28 + 141)) > (1673 + 2644))) then
						v185 = v32(v185, 7 - 1);
					end
				end
				v182 = 2 + 0;
			end
		end
	end
	local function v124(v189, v190)
		local v191 = 1317 - (486 + 831);
		local v192;
		local v193;
		local v194;
		local v195;
		local v196;
		local v197;
		local v198;
		local v199;
		local v200;
		local v201;
		local v202;
		local v203;
		while true do
			if (((12355 - 7607) == (16715 - 11967)) and (v191 == (1 + 2))) then
				v201 = v85.EffectiveComboPoints(v195);
				v202 = v86.Shadowstrike:IsCastable() or v199 or v200 or v192 or v13:BuffUp(v86.SepsisBuff);
				if (((11812 - 8076) <= (6003 - (668 + 595))) and (v199 or v200)) then
					v202 = v202 and v14:IsInRange(23 + 2);
				else
					v202 = v202 and v92;
				end
				v191 = 1 + 3;
			end
			if ((v191 == (10 - 6)) or ((3680 - (23 + 267)) <= (5004 - (1129 + 815)))) then
				if ((v202 and (v199 or v200) and ((v96 < (391 - (371 + 16))) or v109)) or ((2749 - (1326 + 424)) > (5099 - 2406))) then
					if (((1691 - 1228) < (719 - (88 + 30))) and v189) then
						return v86.Shadowstrike;
					end
				end
				v203 = (v13:BuffStack(v86.DanseMacabreBuff) < (776 - (720 + 51))) and ((v196 == (4 - 2)) or (v196 == (1779 - (421 + 1355)))) and (v197 or (v201 < (10 - 3))) and ((v96 <= (4 + 4)) or v86.LingeringShadow:IsAvailable());
				if ((v203 and v198 and v14:DebuffDown(v86.FindWeaknessDebuff) and v86.ImprovedShurikenStorm:IsAvailable()) or (v86.DanseMacabre:IsAvailable() and (v195 <= (1084 - (286 + 797))) and (v96 == (7 - 5)) and not v122(v86.ShurikenStorm)) or ((3615 - 1432) < (1126 - (397 + 42)))) then
					if (((1421 + 3128) == (5349 - (24 + 776))) and v189) then
						return v86.ShurikenStorm;
					end
				end
				v191 = 7 - 2;
			end
			if (((5457 - (222 + 563)) == (10293 - 5621)) and (v191 == (4 + 1))) then
				if ((v86.Gloomblade:IsCastable() and ((v203 and (not v122(v86.Gloomblade) or (v96 ~= (192 - (23 + 167))))) or ((v195 <= (1800 - (690 + 1108))) and v194 and (v96 <= (2 + 1))))) or ((3026 + 642) < (1243 - (40 + 808)))) then
					if (v189 or ((686 + 3480) == (1739 - 1284))) then
						if (v190 or ((4253 + 196) == (1409 + 1254))) then
							return v86.Gloomblade;
						else
							return {v86.Gloomblade,v86.Stealth};
						end
					end
				end
				if ((v86.Backstab:IsCastable() and v203 and v86.DanseMacabre:IsAvailable() and not v122(v86.Backstab) and (v13:BuffStack(v86.DanseMacabreBuff) <= (2 + 0)) and (v96 <= (5 - 3))) or ((6394 - 2117) < (6816 - 3827))) then
					if (v189 or ((2596 - (1165 + 561)) >= (124 + 4025))) then
						if (((6850 - 4638) < (1215 + 1968)) and v190) then
							return v86.Backstab;
						else
							return {v86.Backstab,v86.Stealth};
						end
					end
				end
				if (((9588 - 4942) > (3318 - (89 + 237))) and (v201 >= v85.CPMaxSpend())) then
					return v123(v189, v190);
				end
				v191 = 19 - 13;
			end
			if (((3018 - 1584) < (3987 - (581 + 300))) and (v191 == (1222 - (855 + 365)))) then
				v199 = v13:BuffUp(v85.StealthSpell()) or (v190 and (v190:ID() == v85.StealthSpell():ID()));
				v200 = v13:BuffUp(v85.VanishBuffSpell()) or (v190 and (v190:ID() == v86.Vanish:ID()));
				if (((1866 - 1080) < (988 + 2035)) and v190 and (v190:ID() == v86.ShadowDance:ID())) then
					local v229 = 1235 - (1030 + 205);
					while true do
						if ((v229 == (1 + 0)) or ((2272 + 170) < (360 - (156 + 130)))) then
							if (((10304 - 5769) == (7643 - 3108)) and v86.TheRotten:IsAvailable() and v13:HasTier(61 - 31, 1 + 1)) then
								v194 = true;
							end
							if (v86.TheFirstDance:IsAvailable() or ((1755 + 1254) <= (2174 - (10 + 59)))) then
								local v243 = 0 + 0;
								while true do
									if (((9012 - 7182) < (4832 - (671 + 492))) and (v243 == (0 + 0))) then
										v195 = v31(v13:ComboPointsMax(), v106 + (1219 - (369 + 846)));
										v196 = v13:ComboPointsMax() - v195;
										break;
									end
								end
							end
							break;
						end
						if ((v229 == (0 + 0)) or ((1221 + 209) >= (5557 - (1036 + 909)))) then
							v192 = true;
							v193 = 7 + 1 + v86.ImprovedShadowDance:TalentRank();
							v229 = 1 - 0;
						end
					end
				end
				v191 = 206 - (11 + 192);
			end
			if (((1356 + 1327) >= (2635 - (135 + 40))) and (v191 == (16 - 9))) then
				if (((v13:BuffStack(v86.PerforatedVeinsBuff) >= (4 + 1)) and (v96 < (6 - 3))) or ((2703 - 899) >= (3451 - (50 + 126)))) then
					if (v86.Gloomblade:IsCastable() or ((3945 - 2528) > (804 + 2825))) then
						if (((6208 - (1233 + 180)) > (1371 - (522 + 447))) and v189) then
							if (((6234 - (107 + 1314)) > (1655 + 1910)) and v190) then
								return v86.Gloomblade;
							else
								return {v86.Gloomblade,v86.PerforatedVeins};
							end
						end
					elseif (((7768 - 3856) == (15478 - 11566)) and v86.Backstab:IsCastable()) then
						if (((4731 - (716 + 1194)) <= (83 + 4741)) and v189) then
							if (((187 + 1551) <= (2698 - (74 + 429))) and v190) then
								return v86.Backstab;
							else
								return {v86.Backstab,v86.PerforatedVeins};
							end
						end
					end
				end
				if (((93 - 52) <= (2136 + 882)) and v202 and not v13:StealthUp(true, false) and not v190 and v13:BuffUp(v86.SepsisBuff) and (v96 < (12 - 8))) then
					if (((5303 - 3158) <= (4537 - (279 + 154))) and v189) then
						return v86.Shadowstrike;
					end
				end
				if (((3467 - (454 + 324)) < (3812 + 1033)) and v35 and v86.ShurikenStorm:IsCastable() and (v96 >= ((20 - (12 + 5)) + v21(v194))) and (not v197 or ((v96 >= (4 + 3)) and not v109))) then
					if (v189 or ((5916 - 3594) > (969 + 1653))) then
						return v86.ShurikenStorm;
					end
				end
				v191 = 1101 - (277 + 816);
			end
			if ((v191 == (25 - 19)) or ((5717 - (1058 + 125)) == (391 + 1691))) then
				if ((v13:BuffUp(v86.ShurikenTornado) and (v196 <= (977 - (815 + 160)))) or ((6740 - 5169) > (4431 - 2564))) then
					return v123(v189, v190);
				end
				if (((v96 >= ((1 + 3) - v21(v86.SealFate:IsAvailable()))) and (v201 >= (11 - 7))) or ((4552 - (41 + 1857)) >= (4889 - (1222 + 671)))) then
					return v123(v189, v190);
				end
				if (((10281 - 6303) > (3024 - 920)) and (v196 <= ((1183 - (229 + 953)) + v27(v86.SealFate:IsAvailable() or v86.DeeperStratagem:IsAvailable() or v86.SecretStratagem:IsAvailable())))) then
					return v123(v189, v190);
				end
				v191 = 1781 - (1111 + 663);
			end
			if (((4574 - (874 + 705)) > (216 + 1325)) and (v191 == (0 + 0))) then
				v192 = v13:BuffUp(v86.ShadowDanceBuff);
				v193 = v13:BuffRemains(v86.ShadowDanceBuff);
				v194 = v13:BuffUp(v86.TheRottenBuff);
				v191 = 1 - 0;
			end
			if (((92 + 3157) > (1632 - (642 + 37))) and (v191 == (2 + 6))) then
				if ((v202 and ((v14:DebuffRemains(v86.FindWeaknessDebuff) < (1 + 0)) or ((v86.SymbolsofDeath:CooldownRemains() < (44 - 26)) and (v14:DebuffRemains(v86.FindWeaknessDebuff) < v86.SymbolsofDeath:CooldownRemains())))) or ((3727 - (233 + 221)) > (10574 - 6001))) then
					if (v189 or ((2774 + 377) < (2825 - (718 + 823)))) then
						return v86.Shadowstrike;
					end
				end
				if (v202 or ((1165 + 685) == (2334 - (266 + 539)))) then
					if (((2324 - 1503) < (3348 - (636 + 589))) and v189) then
						return v86.Shadowstrike;
					end
				end
				return false;
			end
			if (((2140 - 1238) < (4795 - 2470)) and (v191 == (1 + 0))) then
				v195, v196 = v106, v107;
				v197 = v13:BuffUp(v86.PremeditationBuff) or (v190 and v86.Premeditation:IsAvailable());
				v198 = v13:BuffUp(v86.SilentStormBuff) or (v190 and v86.SilentStorm:IsAvailable());
				v191 = 1 + 1;
			end
		end
	end
	local function v125(v204, v205)
		local v206 = v124(true, v204);
		if (((1873 - (657 + 358)) <= (7842 - 4880)) and not v205) then
			v205 = 2 - 1;
		end
		if ((v13:Power() < v205) or ((5133 - (1151 + 36)) < (1244 + 44))) then
			return "Pooling";
		end
		if (((v204:ID() == v86.Vanish:ID()) and (not v79 or not v206)) or ((853 + 2389) == (1693 - 1126))) then
			local v215 = 1832 - (1552 + 280);
			while true do
				if ((v215 == (834 - (64 + 770))) or ((576 + 271) >= (2867 - 1604))) then
					if (v10.Cast(v86.Vanish, true) or ((401 + 1852) == (3094 - (157 + 1086)))) then
						return "Cast Vanish";
					end
					return false;
				end
			end
		elseif (((v204:ID() == v86.Shadowmeld:ID()) and (not v80 or not v206)) or ((4176 - 2089) > (10388 - 8016))) then
			local v219 = 0 - 0;
			while true do
				if ((v219 == (0 - 0)) or ((5264 - (599 + 220)) < (8261 - 4112))) then
					if (v10.Cast(v86.Shadowmeld, true) or ((3749 - (1813 + 118)) == (63 + 22))) then
						return "Cast Shadowmeld";
					end
					return false;
				end
			end
		elseif (((1847 - (841 + 376)) < (2980 - 853)) and (v204:ID() == v86.ShadowDance:ID()) and (not v81 or not v206) and v36) then
			local v232 = 0 + 0;
			while true do
				if ((v232 == (0 - 0)) or ((2797 - (464 + 395)) == (6451 - 3937))) then
					if (((2044 + 2211) >= (892 - (467 + 370))) and v10.Cast(v88.ShadowDance, true)) then
						return "Cast Shadow Dance";
					end
					return false;
				end
			end
		end
		local v207 = {v204,v206};
		if (((10280 - 7281) > (181 + 975)) and (v207[2 - 1] == v86.ShadowDance) and v36) then
			v99 = v10.Cast(v88.ShadowDance, true);
			if (((2870 - (150 + 370)) > (2437 - (74 + 1208))) and v99) then
				return "|";
			end
		elseif (((9909 - 5880) <= (23015 - 18162)) and (v207[1 + 0] == v86.Vanish)) then
			local v220 = 390 - (14 + 376);
			while true do
				if (((0 - 0) == v220) or ((334 + 182) > (3017 + 417))) then
					v99 = v10.Cast(v86.Vanish);
					if (((3859 + 187) >= (8887 - 5854)) and v99) then
						return "| ";
					end
					break;
				end
			end
		end
		return false;
	end
	local function v126()
		v99 = v84.HandleTopTrinket(v89, v36, 31 + 9, nil);
		if (v99 or ((2797 - (23 + 55)) <= (3428 - 1981))) then
			return v99;
		end
		v99 = v84.HandleBottomTrinket(v89, v36, 27 + 13, nil);
		if (v99 or ((3713 + 421) < (6087 - 2161))) then
			return v99;
		end
	end
	local function v127()
		local v208 = 0 + 0;
		local v209;
		while true do
			if ((v208 == (904 - (652 + 249))) or ((438 - 274) >= (4653 - (708 + 1160)))) then
				if (v92 or ((1425 - 900) == (3844 - 1735))) then
					local v230 = 27 - (10 + 17);
					while true do
						if (((8 + 25) == (1765 - (1400 + 332))) and (v230 == (0 - 0))) then
							if (((4962 - (242 + 1666)) <= (1719 + 2296)) and v36 and v86.Sepsis:IsReady() and v209 and (v107 >= (1 + 0)) and not v14:FilteredTimeToDie("<", 14 + 2)) then
								if (((2811 - (850 + 90)) < (5922 - 2540)) and v10.Cast(v86.Sepsis)) then
									return "Cast Sepsis";
								end
							end
							if (((2683 - (360 + 1030)) <= (1917 + 249)) and v86.SymbolsofDeath:IsCastable()) then
								if (((((v13:BuffRemains(v86.SymbolsofDeath) <= (7 - 4)) and not v86.ShadowDance:CooldownUp()) or not v13:HasTier(41 - 11, 1663 - (909 + 752))) and v119() and v209 and ((not v86.Flagellation:IsAvailable() and ((v106 <= (1224 - (109 + 1114))) or not v86.TheRotten:IsAvailable())) or (v86.Flagellation:CooldownRemains() > (18 - 8)) or (v86.Flagellation:CooldownUp() and (v106 >= (2 + 3))))) or ((2821 - (6 + 236)) < (78 + 45))) then
									if (v26(v86.SymbolsofDeath) or ((681 + 165) >= (5584 - 3216))) then
										return "Cast Symbols of Death";
									end
								end
							end
							break;
						end
					end
				end
				if (v86.MarkedforDeath:IsCastable() or ((7007 - 2995) <= (4491 - (1076 + 57)))) then
					if (((246 + 1248) <= (3694 - (579 + 110))) and v14:FilteredTimeToDie("<", v107)) then
						if (v10.Cast(v86.MarkedforDeath, v64) or ((246 + 2865) == (1887 + 247))) then
							return "Cast Marked for Death";
						end
					end
					if (((1250 + 1105) == (2762 - (174 + 233))) and not v13:StealthUp(true, true) and (v107 >= v85.CPMaxSpend())) then
						if (not v56 or ((1642 - 1054) <= (757 - 325))) then
							v10.CastSuggested(v86.MarkedforDeath);
						elseif (((2134 + 2663) >= (5069 - (663 + 511))) and v36) then
							if (((3192 + 385) == (777 + 2800)) and v10.Cast(v86.MarkedforDeath, v64)) then
								return "Cast Marked for Death";
							end
						end
					end
				end
				v208 = 12 - 8;
			end
			if (((2298 + 1496) > (8694 - 5001)) and (v208 == (2 - 1))) then
				if ((v86.Vanish:IsCastable() and (v106 <= (1 + 1)) and (v13:BuffStack(v86.DanseMacabreBuff) > (5 - 2)) and ((v86.SecretTechnique:CooldownRemains() >= (22 + 8)) or not v86.SecretTechnique:IsAvailable())) or ((117 + 1158) == (4822 - (478 + 244)))) then
					v99 = v125(v86.Vanish);
					if (v99 or ((2108 - (440 + 77)) >= (1628 + 1952))) then
						return "Vanish Macro (DM) " .. v99;
					end
				end
				if (((3597 - 2614) <= (3364 - (655 + 901))) and v86.ColdBlood:IsReady() and not v86.SecretTechnique:IsAvailable() and (v106 >= (1 + 4))) then
					if (v10.Cast(v86.ColdBlood, true) or ((1646 + 504) <= (809 + 388))) then
						return "Cast Cold Blood";
					end
				end
				v208 = 7 - 5;
			end
			if (((5214 - (695 + 750)) >= (4005 - 2832)) and (v208 == (0 - 0))) then
				if (((5972 - 4487) == (1836 - (285 + 66))) and v13:BuffUp(v86.ShurikenTornado)) then
					if ((v86.SymbolsofDeath:IsCastable() and v86.ShadowDance:IsCastable() and not v13:BuffUp(v86.SymbolsofDeath) and not v13:BuffUp(v86.ShadowDanceBuff)) or ((7727 - 4412) <= (4092 - (682 + 628)))) then
						if (v10.Cast(v86.SymbolsofDeath, true) or ((142 + 734) >= (3263 - (176 + 123)))) then
							return "Dance + Symbols (during Tornado)";
						end
					end
				end
				v209 = v117();
				v208 = 1 + 0;
			end
			if (((2 + 0) == v208) or ((2501 - (239 + 30)) > (679 + 1818))) then
				if (v92 or ((2029 + 81) <= (587 - 255))) then
					if (((11499 - 7813) > (3487 - (306 + 9))) and v36 and v86.Flagellation:IsReady() and v209 and not v13:StealthUp(false, false) and (v106 >= (17 - 12)) and v14:FilteredTimeToDie(">", 2 + 8)) then
						if (v10.Cast(v86.Flagellation, nil) or ((2746 + 1728) < (395 + 425))) then
							return "Cast Flagellation";
						end
					end
				end
				if (((12236 - 7957) >= (4257 - (1140 + 235))) and v86.ShurikenTornado:IsCastable() and (v96 <= (1 + 0)) and v209 and v86.SymbolsofDeath:CooldownUp() and (v86.ShadowDance:Charges() >= (1 + 0)) and (not v86.Flagellation:IsAvailable() or v13:BuffUp(v86.Flagellation) or (v96 >= (2 + 3))) and (v106 <= (54 - (33 + 19))) and not v13:BuffUp(v86.PremeditationBuff)) then
					if ((v13:Energy() >= (22 + 38)) or ((6081 - 4052) >= (1552 + 1969))) then
						if (v10.Cast(v86.ShurikenTornado) or ((3994 - 1957) >= (4353 + 289))) then
							return "Cast Shuriken Tornado";
						end
					elseif (((2409 - (586 + 103)) < (406 + 4052)) and not v86.ShadowFocus:IsAvailable()) then
						local v240 = 0 - 0;
						while true do
							if ((v240 == (1488 - (1309 + 179))) or ((786 - 350) > (1315 + 1706))) then
								if (((1914 - 1201) <= (640 + 207)) and v10.CastPooling(v86.ShurikenTornado)) then
									return "Pool for Shuriken Tornado";
								end
								if (((4575 - 2421) <= (8032 - 4001)) and (v13:Energy() >= (669 - (295 + 314)))) then
									return "1";
								end
								break;
							end
						end
					end
				end
				v208 = 6 - 3;
			end
			if (((6577 - (1300 + 662)) == (14491 - 9876)) and (v208 == (1759 - (1178 + 577)))) then
				if (v36 or ((1969 + 1821) == (1478 - 978))) then
					local v231 = 1405 - (851 + 554);
					while true do
						if (((79 + 10) < (612 - 391)) and (v231 == (1 - 0))) then
							if (((2356 - (115 + 187)) >= (1089 + 332)) and v86.ShurikenTornado:IsReady()) then
								if (((656 + 36) < (12050 - 8992)) and v117 and v13:BuffUp(v86.SymbolsofDeath) and (v106 <= (1163 - (160 + 1001))) and (not v13:BuffUp(v86.PremeditationBuff) or (v96 > (4 + 0)))) then
									if (v10.Cast(v86.ShurikenTornado) or ((2246 + 1008) == (3388 - 1733))) then
										return "Cast Shuriken Tornado (SoD)";
									end
								end
								if ((not v86.Flagellation:IsAvailable() and (v96 >= (361 - (237 + 121))) and (v86.ShadowDance:Charges() >= (898 - (525 + 372))) and not v13:StealthUp(true, true)) or ((2456 - 1160) == (16132 - 11222))) then
									if (((3510 - (96 + 46)) == (4145 - (643 + 134))) and v10.Cast(v86.ShurikenTornado)) then
										return "Cast Shuriken Tornado (Dance)";
									end
								end
							end
							if (((955 + 1688) < (9147 - 5332)) and v86.ShadowDance:IsCastable() and v111() and not v13:BuffUp(v86.ShadowDanceBuff) and v10.BossFilteredFightRemains("<=", 29 - 21) and v36) then
								v99 = v125(v86.ShadowDance);
								if (((1835 + 78) > (967 - 474)) and v99) then
									return "Shadow Dance Macro (Low TTD) " .. v99;
								end
							end
							v231 = 3 - 1;
						end
						if (((5474 - (316 + 403)) > (2279 + 1149)) and (v231 == (5 - 3))) then
							if (((500 + 881) <= (5965 - 3596)) and v36 and v86.ThistleTea:IsReady()) then
								if ((((v86.SymbolsofDeath:CooldownRemains() >= (3 + 0)) or v13:BuffUp(v86.SymbolsofDeath)) and not v13:BuffUp(v86.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (33 + 67)) and ((v13:ComboPointsDeficit() >= (6 - 4)) or (v96 >= (14 - 11)))) or ((v86.ThistleTea:ChargesFractional() >= (3.75 - 1)) and v13:BuffUp(v86.ShadowDanceBuff)))) or ((v13:BuffRemains(v86.ShadowDanceBuff) >= (1 + 3)) and not v13:BuffUp(v86.ThistleTea) and (v96 >= (5 - 2))) or (not v13:BuffUp(v86.ThistleTea) and v10.BossFilteredFightRemains("<=", (1 + 5) * v86.ThistleTea:Charges())) or ((14248 - 9405) == (4101 - (12 + 5)))) then
									if (((18134 - 13465) > (773 - 410)) and v26(v86.ThistleTea, nil, nil, true)) then
										return "Thistle Tea";
									end
								end
							end
							if (v13:BuffUp(v86.SymbolsofDeath) or ((3989 - 2112) >= (7781 - 4643))) then
								local v244 = 0 + 0;
								while true do
									if (((6715 - (1656 + 317)) >= (3232 + 394)) and (v244 == (0 + 0))) then
										if (v86.BloodFury:IsCastable() or ((12071 - 7531) == (4508 - 3592))) then
											if (v10.Cast(v86.BloodFury, v59) or ((1510 - (5 + 349)) > (20638 - 16293))) then
												return "Cast Blood Fury";
											end
										end
										if (((3508 - (266 + 1005)) < (2800 + 1449)) and v86.Berserking:IsCastable()) then
											if (v10.Cast(v86.Berserking, v59) or ((9154 - 6471) < (29 - 6))) then
												return "Cast Berserking";
											end
										end
										v244 = 1697 - (561 + 1135);
									end
									if (((908 - 211) <= (2715 - 1889)) and (v244 == (1067 - (507 + 559)))) then
										if (((2772 - 1667) <= (3636 - 2460)) and v86.Fireblood:IsCastable()) then
											if (((3767 - (212 + 176)) <= (4717 - (250 + 655))) and v10.Cast(v86.Fireblood, v59)) then
												return "Cast Fireblood";
											end
										end
										if (v86.AncestralCall:IsCastable() or ((2148 - 1360) >= (2823 - 1207))) then
											if (((2900 - 1046) <= (5335 - (1869 + 87))) and v10.Cast(v86.AncestralCall, v59)) then
												return "Cast Ancestral Call";
											end
										end
										break;
									end
								end
							end
							v231 = 10 - 7;
						end
						if (((6450 - (484 + 1417)) == (9749 - 5200)) and (v231 == (4 - 1))) then
							if ((v51 and v36) or ((3795 - (48 + 725)) >= (4939 - 1915))) then
								v99 = v126();
								if (((12931 - 8111) > (1278 + 920)) and v99) then
									return v99;
								end
							end
							break;
						end
						if ((v231 == (0 - 0)) or ((297 + 764) >= (1426 + 3465))) then
							if (((2217 - (152 + 701)) <= (5784 - (430 + 881))) and v86.ShadowBlades:IsCastable() and (v13:BuffUp(v86.ShadowDanceBuff) or (v86.ShadowDance:CooldownRemains() < (4 + 6))) and ((v209 and (v107 >= (897 - (557 + 338))) and v14:FilteredTimeToDie(">=", 3 + 7) and (not v86.Sepsis:IsAvailable() or (v86.Sepsis:CooldownRemains() <= (22 - 14)) or v14:DebuffUp(v86.Sepsis))) or v10.BossFilteredFightRemains("<=", 70 - 50))) then
								if (v10.Cast(v86.ShadowBlades, true) or ((9551 - 5956) <= (6 - 3))) then
									return "Cast Shadow Blades";
								end
							end
							if ((v86.EchoingReprimand:IsReady() and v92 and (v107 >= (804 - (499 + 302))) and (v109 or (v96 <= (870 - (39 + 827))) or v86.ResoundingClarity:IsAvailable()) and (v13:BuffUp(v86.ShadowDanceBuff) or not v86.DanseMacabre:IsAvailable())) or ((12896 - 8224) == (8602 - 4750))) then
								if (((6191 - 4632) == (2392 - 833)) and v10.Cast(v86.EchoingReprimand, nil)) then
									return "Cast Echoing Reprimand";
								end
							end
							v231 = 1 + 0;
						end
					end
				end
				return false;
			end
		end
	end
	local function v128(v210)
		if ((v36 and (v86.ShadowDance:TimeSinceLastDisplay() > (0.3 - 0)) and (v86.Shadowmeld:TimeSinceLastDisplay() > (0.3 + 0)) and not v13:IsTanking(v14)) or ((2771 - 1019) <= (892 - (103 + 1)))) then
			if ((v86.Vanish:IsCastable() and (not v86.DanseMacabre:IsAvailable() or (v96 >= (557 - (475 + 79)))) and not v115() and (v107 > (2 - 1)) and ((v86.Flagellation:CooldownRemains() >= (192 - 132)) or not v86.Flagellation:IsAvailable() or v10.BossFilteredFightRemains("<=", (4 + 26) * v86.Vanish:Charges()))) or ((3439 + 468) == (1680 - (1395 + 108)))) then
				v99 = v125(v86.Vanish, v210);
				if (((10097 - 6627) > (1759 - (7 + 1197))) and v99) then
					return "Vanish Macro " .. v99;
				end
			end
		end
		if ((v92 and v36 and v86.ShadowDance:IsCastable() and (v86.ShadowDance:Charges() >= (1 + 0)) and (v86.Vanish:TimeSinceLastDisplay() > (0.3 + 0)) and (v86.Shadowmeld:TimeSinceLastDisplay() > (319.3 - (27 + 292))) and (v36 or (v86.ShadowDance:ChargesFractional() >= (v73 - ((not v86.ShadowDanceTalent:IsAvailable() and (0.75 - 0)) or (0 - 0)))))) or ((4076 - 3104) == (1271 - 626))) then
			if (((6059 - 2877) >= (2254 - (43 + 96))) and ((v116() and ((not v86.ShadowDanceTalent:IsAvailable() and (v13:BuffRemains(v86.SymbolsofDeath) >= ((8.2 - 6) - v21(v86.Flagellation:IsAvailable())))) or v115())) or (v86.ShadowDanceTalent:IsAvailable() and (v86.SecretTechnique:CooldownRemains() <= (19 - 10)) and ((v96 <= (3 + 0)) or v86.DanseMacabre:IsAvailable())) or (v13:BuffRemains(v86.FlagellationPersistBuff) >= (2 + 4)) or ((v96 >= (7 - 3)) and (v86.SymbolsofDeath:CooldownRemains() > (4 + 6)))) and v120()) then
				v99 = v125(v86.ShadowDance, v210);
				if (((7295 - 3402) < (1395 + 3034)) and v99) then
					return "ShadowDance Macro 1 " .. v99;
				end
			end
			if ((v111() and ((v116() and v10.BossFilteredFightRemains("<", v86.SymbolsofDeath:CooldownRemains())) or (not v86.ShadowDanceTalent:IsAvailable() and v14:DebuffUp(v86.Rupture) and (v96 <= (1 + 3)) and v120()))) or ((4618 - (1414 + 337)) < (3845 - (1642 + 298)))) then
				local v221 = 0 - 0;
				while true do
					if ((v221 == (0 - 0)) or ((5329 - 3533) >= (1334 + 2717))) then
						v99 = v125(v86.ShadowDance, v210);
						if (((1260 + 359) <= (4728 - (357 + 615))) and v99) then
							return "ShadowDance Macro 2 " .. v99;
						end
						break;
					end
				end
			end
		end
		return false;
	end
	local function v129(v211)
		local v212 = not v211 or (v13:EnergyPredicted() >= v211);
		if (((424 + 180) == (1481 - 877)) and v35 and v86.ShurikenStorm:IsCastable() and (v96 >= (2 + 0 + v21((v86.Gloomblade:IsAvailable() and (v13:BuffRemains(v86.LingeringShadowBuff) >= (12 - 6))) or v13:BuffUp(v86.PerforatedVeinsBuff))))) then
			if ((v212 and v10.Cast(v86.ShurikenStorm)) or ((3587 + 897) == (62 + 838))) then
				return "Cast Shuriken Storm";
			end
		end
		if (v92 or ((2803 + 1656) <= (2414 - (384 + 917)))) then
			local v216 = 697 - (128 + 569);
			while true do
				if (((5175 - (1407 + 136)) > (5285 - (687 + 1200))) and (v216 == (1710 - (556 + 1154)))) then
					if (((14360 - 10278) <= (5012 - (9 + 86))) and v86.EchoingReprimand:IsAvailable() and (v13:Energy() < (481 - (275 + 146))) and (((v106 == (1 + 1)) and v13:BuffUp(v86.EchoingReprimand3)) or ((v106 == (67 - (29 + 35))) and v13:BuffUp(v86.EchoingReprimand4)) or ((v106 == (17 - 13)) and v13:BuffUp(v86.EchoingReprimand5))) and ((v85.TimeToSht(8 - 5) < (0.5 - 0)) or (v85.TimeToSht(3 + 1) < (1013 - (53 + 959))) or (v85.TimeToSht(413 - (312 + 96)) < (1 - 0)))) then
						return "EL Generator Pooling";
					end
					if (((5117 - (147 + 138)) >= (2285 - (813 + 86))) and v86.Gloomblade:IsCastable()) then
						if (((124 + 13) == (253 - 116)) and v212 and v10.Cast(v86.Gloomblade)) then
							return "Cast Gloomblade";
						end
					elseif (v86.Backstab:IsCastable() or ((2062 - (18 + 474)) >= (1462 + 2870))) then
						if ((v212 and v10.Cast(v86.Backstab)) or ((13264 - 9200) <= (2905 - (860 + 226)))) then
							return "Cast Backstab";
						end
					end
					break;
				end
			end
		end
		return false;
	end
	local function v130()
		C_Timer.After(303.25 - (121 + 182), function()
			local v213 = 0 + 0;
			while true do
				if ((v213 == (1240 - (988 + 252))) or ((564 + 4422) < (494 + 1080))) then
					v83();
					v34 = EpicSettings.Toggles['ooc'];
					v35 = EpicSettings.Toggles['aoe'];
					v213 = 1971 - (49 + 1921);
				end
				if (((5316 - (223 + 667)) > (224 - (51 + 1))) and (v213 == (5 - 2))) then
					v91 = (v86.AcrobaticStrikes:IsAvailable() and (27 - 14)) or (1135 - (146 + 979));
					v92 = v14:IsInMeleeRange(v90);
					v93 = v14:IsInMeleeRange(v91);
					v213 = 2 + 2;
				end
				if (((1191 - (311 + 294)) > (1268 - 813)) and (v213 == (3 + 4))) then
					v104 = v86.Eviscerate:Damage() * v72;
					if (((2269 - (496 + 947)) == (2184 - (1233 + 125))) and v87.Healthstone:IsReady() and (v13:HealthPercentage() < v42) and not (v13:IsChanneling() or v13:IsCasting())) then
						if (v10.Cast(v88.Healthstone) or ((1631 + 2388) > (3985 + 456))) then
							return "Healthstone ";
						end
					end
					if (((384 + 1633) < (5906 - (963 + 682))) and v87.RefreshingHealingPotion:IsReady() and (v13:HealthPercentage() < v40) and not (v13:IsChanneling() or v13:IsCasting())) then
						if (((3936 + 780) > (1584 - (504 + 1000))) and v10.Cast(v88.RefreshingHealingPotion)) then
							return "RefreshingHealingPotion ";
						end
					end
					v213 = 6 + 2;
				end
				if ((v213 == (1 + 0)) or ((331 + 3176) == (4824 - 1552))) then
					v36 = EpicSettings.Toggles['cds'];
					ToggleMain = EpicSettings.Toggles['toggle'];
					v100 = nil;
					v213 = 2 + 0;
				end
				if ((v213 == (5 + 3)) or ((1058 - (156 + 26)) >= (1772 + 1303))) then
					v99 = v85.CrimsonVial();
					if (((6808 - 2456) > (2718 - (149 + 15))) and v99) then
						return v99;
					end
					if (not v13:AffectingCombat() or ((5366 - (890 + 70)) < (4160 - (39 + 78)))) then
						v99 = v85.Poisons();
						if (v99 or ((2371 - (14 + 468)) >= (7439 - 4056))) then
							return v99;
						end
						if (((5288 - 3396) <= (1411 + 1323)) and v84.TargetIsValid()) then
							if (((1155 + 768) < (472 + 1746)) and v15:Exists() and v86.TricksoftheTrade:IsReady()) then
								if (((982 + 1191) > (100 + 279)) and v26(v88.TricksoftheTradeFocus)) then
									return "precombat tricks_of_the_trade";
								end
							end
						end
					end
					v213 = 16 - 7;
				end
				if ((v213 == (4 + 0)) or ((9104 - 6513) == (87 + 3322))) then
					if (((4565 - (12 + 39)) > (3093 + 231)) and v35) then
						local v233 = 0 - 0;
						while true do
							if ((v233 == (0 - 0)) or ((62 + 146) >= (2542 + 2286))) then
								v94 = v13:GetEnemiesInRange(76 - 46);
								v95 = v13:GetEnemiesInMeleeRange(v91);
								v233 = 1 + 0;
							end
							if ((v233 == (4 - 3)) or ((3293 - (1596 + 114)) > (9312 - 5745))) then
								v96 = #v95;
								v97 = v13:GetEnemiesInMeleeRange(v90);
								break;
							end
						end
					else
						v94 = {};
						v95 = {};
						v96 = 714 - (164 + 549);
						v97 = {};
					end
					v106 = v13:ComboPoints();
					v105 = v85.EffectiveComboPoints(v106);
					v213 = 1443 - (1059 + 379);
				end
				if ((v213 == (2 - 0)) or ((681 + 632) == (134 + 660))) then
					v102 = nil;
					v101 = 392 - (145 + 247);
					v90 = (v86.AcrobaticStrikes:IsAvailable() and (7 + 1)) or (3 + 2);
					v213 = 8 - 5;
				end
				if (((609 + 2565) > (2500 + 402)) and ((13 - 4) == v213)) then
					if (((4840 - (254 + 466)) <= (4820 - (544 + 16))) and not v13:AffectingCombat() and not v13:IsMounted() and v84.TargetIsValid()) then
						local v234 = 0 - 0;
						while true do
							if (((628 - (294 + 334)) == v234) or ((1136 - (236 + 17)) > (2060 + 2718))) then
								v99 = v85.Stealth(v86.Stealth2, nil);
								if (v99 or ((2818 + 802) >= (18419 - 13528))) then
									return "Stealth (OOC): " .. v99;
								end
								break;
							end
						end
					end
					if (((20159 - 15901) > (483 + 454)) and not v13:IsChanneling() and ToggleMain) then
						local v235 = 0 + 0;
						while true do
							if ((v235 == (794 - (413 + 381))) or ((205 + 4664) < (1926 - 1020))) then
								if ((not v13:AffectingCombat() and v14:AffectingCombat() and (v86.Vanish:TimeSinceLastCast() > (2 - 1))) or ((3195 - (582 + 1388)) > (7203 - 2975))) then
									if (((2383 + 945) > (2602 - (326 + 38))) and v84.TargetIsValid() and (v14:IsSpellInRange(v86.Shadowstrike) or v92)) then
										if (((11356 - 7517) > (2005 - 600)) and v13:StealthUp(true, true)) then
											local v247 = 620 - (47 + 573);
											while true do
												if ((v247 == (0 + 0)) or ((5491 - 4198) <= (822 - 315))) then
													CastAbility = v124(true);
													if (CastAbility or ((4560 - (1269 + 395)) < (1297 - (76 + 416)))) then
														if (((2759 - (319 + 124)) == (5293 - 2977)) and (type(CastAbility) == "table") and (#CastAbility > (1008 - (564 + 443)))) then
															if (v10.Cast(unpack(CastAbility)) or ((7114 - 4544) == (1991 - (337 + 121)))) then
																return "Stealthed Macro Cast or Pool (OOC): ";
															end
														elseif (v10.Cast(CastAbility) or ((2586 - 1703) == (4863 - 3403))) then
															return "Stealthed Cast or Pool (OOC): ";
														end
													end
													break;
												end
											end
										elseif ((v106 >= (1916 - (1261 + 650))) or ((1955 + 2664) <= (1591 - 592))) then
											local v249 = 1817 - (772 + 1045);
											while true do
												if ((v249 == (0 + 0)) or ((3554 - (102 + 42)) > (5960 - (1524 + 320)))) then
													v99 = v123();
													if (v99 or ((2173 - (1049 + 221)) >= (3215 - (18 + 138)))) then
														return v99 .. " (OOC)";
													end
													break;
												end
											end
										end
									end
									return;
								end
								if ((v84.TargetIsValid() and (v34 or v13:AffectingCombat())) or ((9732 - 5756) < (3959 - (67 + 1035)))) then
									local v245 = 348 - (136 + 212);
									while true do
										if (((20949 - 16019) > (1849 + 458)) and (v245 == (3 + 0))) then
											if ((v13:EnergyPredicted() >= v108) or ((5650 - (240 + 1364)) < (2373 - (1050 + 32)))) then
												v99 = v128(v108);
												if (v99 or ((15142 - 10901) == (2097 + 1448))) then
													return "Stealth CDs: " .. v99;
												end
											end
											if ((v105 >= v85.CPMaxSpend()) or (v107 <= ((1056 - (331 + 724)) + v27(v13:BuffUp(v86.TheRottenBuff)))) or (v10.BossFilteredFightRemains("<", 1 + 1) and (v105 >= (647 - (269 + 375)))) or ((v96 >= ((729 - (267 + 458)) - v27(v86.SealFate:IsAvailable()))) and (v105 >= (2 + 2))) or ((7784 - 3736) > (5050 - (667 + 151)))) then
												local v248 = 1497 - (1410 + 87);
												while true do
													if ((v248 == (1897 - (1504 + 393))) or ((4730 - 2980) >= (9010 - 5537))) then
														v99 = v123();
														if (((3962 - (461 + 335)) == (405 + 2761)) and v99) then
															return "Finish: " .. v99;
														end
														break;
													end
												end
											else
												v99 = v128(v108);
												if (((3524 - (1730 + 31)) < (5391 - (728 + 939))) and v99) then
													return "Stealth CDs: " .. v99;
												end
												v99 = v129(v108);
												if (((201 - 144) <= (5522 - 2799)) and v99) then
													return "Build: " .. v99;
												end
											end
											break;
										end
										if ((v245 == (2 - 1)) or ((3138 - (138 + 930)) == (405 + 38))) then
											v99 = v127();
											if (v99 or ((2115 + 590) == (1194 + 199))) then
												return "CDs: " .. v99;
											end
											v245 = 8 - 6;
										end
										if (((1766 - (459 + 1307)) == v245) or ((6471 - (474 + 1396)) < (106 - 45))) then
											if ((v82 and v86.Shiv:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v84.UnitHasEnrageBuff(v14)) or ((1303 + 87) >= (16 + 4728))) then
												if (v26(v86.Shiv, not v92) or ((5737 - 3734) > (486 + 3348))) then
													return "dispel";
												end
											end
											if (((v10.CombatTime() < (33 - 23)) and (v10.CombatTime() > (0 - 0)) and v86.ShadowDance:CooldownUp() and (v86.Vanish:TimeSinceLastCast() > (602 - (562 + 29)))) or ((133 + 23) > (5332 - (374 + 1045)))) then
												if (((155 + 40) == (605 - 410)) and v13:StealthUp(true, true)) then
													if (((3743 - (448 + 190)) >= (580 + 1216)) and v10.Cast(v86.Shadowstrike)) then
														return "Opener SS";
													end
												end
												if (((1977 + 2402) >= (1389 + 742)) and v86.SymbolsofDeath:IsCastable() and v13:BuffDown(v86.SymbolsofDeath)) then
													if (((14779 - 10935) >= (6347 - 4304)) and v10.Cast(v86.SymbolsofDeath, true)) then
														return "Opener SymbolsofDeath";
													end
												end
												if ((v86.ShadowBlades:IsCastable() and v13:BuffDown(v86.ShadowBlades)) or ((4726 - (1307 + 187)) <= (10829 - 8098))) then
													if (((11484 - 6579) == (15039 - 10134)) and v10.Cast(v86.ShadowBlades, true)) then
														return "Opener ShadowBlades";
													end
												end
												if ((v86.ShurikenStorm:IsCastable() and (v96 >= (685 - (232 + 451)))) or ((3950 + 186) >= (3897 + 514))) then
													if (v10.Cast(v86.ShurikenStorm) or ((3522 - (510 + 54)) == (8093 - 4076))) then
														return "Opener Shuriken Tornado";
													end
												end
												if (((1264 - (13 + 23)) >= (1584 - 771)) and (v86.Gloomblade:TimeSinceLastCast() > (3 - 0)) and (v96 <= (1 - 0))) then
													if (v10.Cast(v86.Gloomblade) or ((4543 - (830 + 258)) > (14286 - 10236))) then
														return "Opener Gloomblade";
													end
												end
												if (((153 + 90) == (207 + 36)) and v14:DebuffDown(v86.Rupture) and (v96 <= (1442 - (860 + 581))) and (v106 > (0 - 0))) then
													if (v10.Cast(v86.Rupture) or ((216 + 55) > (1813 - (237 + 4)))) then
														return "Opener Rupture";
													end
												end
												if (((6436 - 3697) < (8330 - 5037)) and v86.ShadowDance:IsCastable() and v36 and v10.Cast(v88.ShadowDance, true)) then
													return "Opener ShadowDance";
												end
											end
											v245 = 1 - 0;
										end
										if (((2 + 0) == v245) or ((2265 + 1677) < (4281 - 3147))) then
											if ((v86.SliceandDice:IsCastable() and (v96 < v85.CPMaxSpend()) and v10.FilteredFightRemains(v95, ">", 3 + 3) and (v13:BuffRemains(v86.SliceandDice) < v13:GCD()) and (v106 >= (3 + 1))) or ((4119 - (85 + 1341)) == (8485 - 3512))) then
												if (((6060 - 3914) == (2518 - (45 + 327))) and v86.SliceandDice:IsReady()) then
													local v250 = 0 - 0;
													while true do
														if ((v250 == (502 - (444 + 58))) or ((976 + 1268) == (555 + 2669))) then
															if (v10.Cast(v86.SliceandDice) or ((2398 + 2506) <= (5552 - 3636))) then
																return "Cast Slice and Dice (Low Duration)";
															end
															if (((1822 - (64 + 1668)) <= (3038 - (1227 + 746))) and (v13:Power() < (61 - 41))) then
																return "Pooling";
															end
															break;
														end
													end
												end
											end
											if (((8911 - 4109) == (5296 - (415 + 79))) and v13:StealthUp(true, true)) then
												CastAbility = v124(true);
												if (CastAbility or ((59 + 2221) <= (1002 - (142 + 349)))) then
													if (((type(CastAbility) == "table") and (#CastAbility > (1 + 0))) or ((2303 - 627) <= (231 + 232))) then
														if (((2726 + 1143) == (10536 - 6667)) and v10.Cast(unpack(CastAbility))) then
															return "Stealthed Macro Cast or Pool (OOC): ";
														end
													elseif (((3022 - (1710 + 154)) <= (2931 - (200 + 118))) and v10.Cast(CastAbility)) then
														return "Stealthed Cast or Pool (OOC): ";
													end
												end
												return "Stealthed Pooling";
											end
											v245 = 2 + 1;
										end
									end
								end
								break;
							end
						end
					end
					break;
				end
				if ((v213 == (10 - 4)) or ((3505 - 1141) <= (1777 + 222))) then
					if (((v105 > v106) and (v107 > (2 + 0)) and v13:AffectingCombat()) or ((2642 + 2280) < (31 + 163))) then
						if (((v106 == (4 - 2)) and not v13:BuffUp(v86.EchoingReprimand3)) or ((v106 == (1253 - (363 + 887))) and not v13:BuffUp(v86.EchoingReprimand4)) or ((v106 == (6 - 2)) and not v13:BuffUp(v86.EchoingReprimand5)) or ((9952 - 7861) < (5 + 26))) then
							local v237 = 0 - 0;
							local v238;
							while true do
								if ((v237 == (0 + 0)) or ((4094 - (674 + 990)) >= (1397 + 3475))) then
									v238 = v85.TimeToSht(2 + 2);
									if ((v238 == (0 - 0)) or ((5825 - (507 + 548)) < (2572 - (289 + 548)))) then
										v238 = v85.TimeToSht(1823 - (821 + 997));
									end
									v237 = 256 - (195 + 60);
								end
								if ((v237 == (1 + 0)) or ((5940 - (251 + 1250)) <= (6884 - 4534))) then
									if ((v238 < (v32(v13:EnergyTimeToX(25 + 10), v13:GCDRemains()) + (1032.5 - (809 + 223)))) or ((6535 - 2056) < (13411 - 8945))) then
										v105 = v106;
									end
									break;
								end
							end
						end
					end
					if (((8421 - 5874) > (903 + 322)) and v13:BuffUp(v86.ShurikenTornado, nil, true) and (v106 < v85.CPMaxSpend())) then
						local v236 = v85.TimeToNextTornado();
						if (((2446 + 2225) > (3291 - (14 + 603))) and ((v236 <= v13:GCDRemains()) or (v33(v13:GCDRemains() - v236) < (129.25 - (118 + 11))))) then
							local v239 = v96 + v27(v13:BuffUp(v86.ShadowBlades));
							v106 = v31(v106 + v239, v85.CPMaxSpend());
							v107 = v32(v107 - v239, 0 + 0);
							if ((v105 < v85.CPMaxSpend()) or ((3079 + 617) < (9695 - 6368))) then
								v105 = v106;
							end
						end
					end
					v103 = ((953 - (551 + 398)) + (v105 * (3 + 1))) * (0.3 + 0);
					v213 = 6 + 1;
				end
				if ((v213 == (18 - 13)) or ((10465 - 5923) == (963 + 2007))) then
					v107 = v13:ComboPointsDeficit();
					v109 = v112();
					v108 = v13:EnergyMax() - v114();
					v213 = 23 - 17;
				end
			end
		end);
	end
	local function v131()
		v10.Print("Subtlety Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(73 + 188, v130, v131);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

