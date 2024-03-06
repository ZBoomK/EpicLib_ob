local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((3507 + 1332) <= (4994 - 1714))) then
			v6 = v0[v4];
			if (not v6 or ((2271 + 1403) <= (2629 - (89 + 578)))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1 - 0)) or ((2943 - (572 + 477)) < (190 + 1216))) then
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
	local v41 = false;
	local v42 = false;
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
	local v65 = {v35.Mirror:ID(),v35.WitherbarksBranch:ID(),v35.AshesoftheEmbersoul:ID()};
	local v66, v67, v68, v69;
	local v70, v71, v72, v73;
	local v74;
	local v75, v76, v77;
	local v78, v79;
	local v80, v81, v82, v83;
	local v84;
	v34.Eviscerate:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v80 * (0.176 - 0) * (1.21 + 0) * ((v34.Nightstalker:IsAvailable() and v13:StealthUp(true, false) and (843.08 - (497 + 345))) or (1 + 0)) * ((v34.DeeperStratagem:IsAvailable() and (1.05 + 0)) or (1334 - (605 + 728))) * ((v34.DarkShadow:IsAvailable() and v13:BuffUp(v34.ShadowDanceBuff) and (1.3 + 0)) or (1 - 0)) * ((v13:BuffUp(v34.SymbolsofDeath) and (1.1 + 0)) or (3 - 2)) * ((v13:BuffUp(v34.FinalityEviscerateBuff) and (1.3 + 0)) or (2 - 1)) * (1 + 0 + (v13:MasteryPct() / (589 - (457 + 32)))) * (1 + 0 + (v13:VersatilityDmgPct() / (1502 - (832 + 570)))) * ((v14:DebuffUp(v34.FindWeaknessDebuff) and (1.5 + 0)) or (1 + 0));
	end);
	local function v85(v116, v117)
		if (((5562 - 3990) >= (738 + 793)) and not v75) then
			local v184 = 796 - (588 + 208);
			while true do
				if ((v184 == (0 - 0)) or ((6487 - (884 + 916)) < (9508 - 4966))) then
					v75 = v116;
					v76 = v117 or (0 + 0);
					break;
				end
			end
		end
	end
	local function v86(v118)
		if (((3944 - (232 + 421)) > (3556 - (1569 + 320))) and not v77) then
			v77 = v118;
		end
	end
	local function v87()
		if (((v43 == "On Bosses not in Dungeons") and v13:IsInDungeonArea()) or ((215 + 658) == (387 + 1647))) then
			return false;
		elseif (((v43 ~= "Always") and not v14:IsInBossList()) or ((9489 - 6673) < (616 - (316 + 289)))) then
			return false;
		else
			return true;
		end
	end
	local function v88()
		local v119 = 0 - 0;
		while true do
			if (((171 + 3528) < (6159 - (666 + 787))) and (v119 == (425 - (360 + 65)))) then
				if (((2473 + 173) >= (1130 - (79 + 175))) and (v72 < (2 - 0))) then
					return false;
				elseif (((480 + 134) <= (9759 - 6575)) and (v44 == "Always")) then
					return true;
				elseif (((6019 - 2893) == (4025 - (503 + 396))) and (v44 == "On Bosses") and v14:IsInBossList()) then
					return true;
				elseif ((v44 == "Auto") or ((2368 - (92 + 89)) >= (9610 - 4656))) then
					if (((v13:InstanceDifficulty() == (9 + 7)) and (v14:NPCID() == (82248 + 56719))) or ((15182 - 11305) == (489 + 3086))) then
						return true;
					elseif (((1611 - 904) > (552 + 80)) and ((v14:NPCID() == (79750 + 87219)) or (v14:NPCID() == (508538 - 341567)) or (v14:NPCID() == (20840 + 146130)))) then
						return true;
					elseif ((v14:NPCID() == (279783 - 96320)) or (v14:NPCID() == (184915 - (485 + 759))) or ((1263 - 717) >= (3873 - (442 + 747)))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v89(v120, v121, v122, v123)
		local v124 = 1135 - (832 + 303);
		local v125;
		local v126;
		local v127;
		while true do
			if (((2411 - (88 + 858)) <= (1311 + 2990)) and (v124 == (1 + 0))) then
				for v205, v206 in v26(v123) do
					if (((71 + 1633) > (2214 - (766 + 23))) and (v206:GUID() ~= v127) and v31.UnitIsCycleValid(v206, v126, -v206:DebuffRemains(v120)) and v121(v206)) then
						v125, v126 = v206, v206:TimeToDie();
					end
				end
				if ((v125 and (v14:GUID() == v125:GUID())) or ((3391 - 2704) == (5790 - 1556))) then
					v10.Press(v120);
				elseif (v45 or ((8773 - 5443) < (4849 - 3420))) then
					v125, v126 = nil, v122;
					for v224, v225 in v26(v71) do
						if (((2220 - (1036 + 37)) >= (238 + 97)) and (v225:GUID() ~= v127) and v31.UnitIsCycleValid(v225, v126, -v225:DebuffRemains(v120)) and v121(v225)) then
							v125, v126 = v225, v225:TimeToDie();
						end
					end
					if (((6689 - 3254) > (1650 + 447)) and v125 and (v14:GUID() == v125:GUID())) then
						v10.Press(v120);
					end
				end
				break;
			end
			if ((v124 == (1480 - (641 + 839))) or ((4683 - (910 + 3)) >= (10301 - 6260))) then
				v125, v126 = nil, v122;
				v127 = v14:GUID();
				v124 = 1685 - (1466 + 218);
			end
		end
	end
	local function v90()
		return 10 + 10 + (v34.Vigor:TalentRank() * (1173 - (556 + 592))) + (v24(v34.ThistleTea:IsAvailable()) * (8 + 12)) + (v24(v34.Shadowcraft:IsAvailable()) * (828 - (329 + 479)));
	end
	local function v91()
		return v34.ShadowDance:ChargesFractional() >= ((854.75 - (174 + 680)) + v18(v34.ShadowDanceTalent:IsAvailable()));
	end
	local function v92()
		return v82 >= (10 - 7);
	end
	local function v93()
		return v13:BuffUp(v34.SliceandDice) or (v72 >= v32.CPMaxSpend());
	end
	local function v94()
		return v34.Premeditation:IsAvailable() and (v72 < (10 - 5));
	end
	local function v95(v128)
		return (v13:BuffUp(v34.ThistleTea) and (v72 == (1 + 0))) or (v128 and ((v72 == (740 - (396 + 343))) or (v14:DebuffUp(v34.Rupture) and (v72 >= (1 + 1)))));
	end
	local function v96()
		return (not v13:BuffUp(v34.TheRotten) or not v13:HasTier(1507 - (29 + 1448), 1391 - (135 + 1254))) and (not v34.ColdBlood:IsAvailable() or (v34.ColdBlood:CooldownRemains() < (14 - 10)) or (v34.ColdBlood:CooldownRemains() > (46 - 36)));
	end
	local function v97(v129)
		return v13:BuffUp(v34.ShadowDanceBuff) and (v129:TimeSinceLastCast() < v34.ShadowDance:TimeSinceLastCast());
	end
	local function v98()
		return ((v97(v34.Shadowstrike) or v97(v34.ShurikenStorm)) and (v97(v34.Eviscerate) or v97(v34.BlackPowder) or v97(v34.Rupture))) or not v34.DanseMacabre:IsAvailable();
	end
	local function v99()
		return (not v35.WitherbarksBranch:IsEquipped() and not v35.AshesoftheEmbersoul:IsEquipped()) or (not v35.WitherbarksBranch:IsEquipped() and (v35.WitherbarksBranch:CooldownRemains() <= (6 + 2))) or (v35.WitherbarksBranch:IsEquipped() and (v35.WitherbarksBranch:CooldownRemains() <= (1535 - (389 + 1138)))) or v35.BandolierOfTwistedBlades:IsEquipped() or v34.InvigoratingShadowdust:IsAvailable();
	end
	local function v100(v130, v131)
		local v132 = v13:BuffUp(v34.ShadowDanceBuff);
		local v133 = v13:BuffRemains(v34.ShadowDanceBuff);
		local v134 = v13:BuffRemains(v34.SymbolsofDeath);
		local v135 = v81;
		local v136 = v34.ColdBlood:CooldownRemains();
		local v137 = v34.SymbolsofDeath:CooldownRemains();
		local v138 = v13:BuffUp(v34.PremeditationBuff) or (v131 and v34.Premeditation:IsAvailable());
		if ((v131 and (v131:ID() == v34.ShadowDance:ID())) or ((4365 - (102 + 472)) <= (1521 + 90))) then
			local v185 = 0 + 0;
			while true do
				if ((v185 == (1 + 0)) or ((6123 - (320 + 1225)) <= (3574 - 1566))) then
					if (((689 + 436) <= (3540 - (157 + 1307))) and v34.TheFirstDance:IsAvailable()) then
						v135 = v28(v13:ComboPointsMax(), v81 + (1863 - (821 + 1038)));
					end
					if (v13:HasTier(74 - 44, 1 + 1) or ((1319 - 576) >= (1637 + 2762))) then
						v134 = v29(v134, 14 - 8);
					end
					break;
				end
				if (((2181 - (834 + 192)) < (107 + 1566)) and ((0 + 0) == v185)) then
					v132 = true;
					v133 = 1 + 7 + v34.ImprovedShadowDance:TalentRank();
					v185 = 1 - 0;
				end
			end
		end
		if ((v131 and (v131:ID() == v34.Vanish:ID())) or ((2628 - (300 + 4)) <= (155 + 423))) then
			v136 = v28(0 - 0, v34.ColdBlood:CooldownRemains() - ((377 - (112 + 250)) * v34.InvigoratingShadowdust:TalentRank()));
			v137 = v28(0 + 0, v34.SymbolsofDeath:CooldownRemains() - ((37 - 22) * v34.InvigoratingShadowdust:TalentRank()));
		end
		if (((2159 + 1608) == (1949 + 1818)) and v34.Rupture:IsCastable() and v34.Rupture:IsReady()) then
			if (((3059 + 1030) == (2028 + 2061)) and v14:DebuffDown(v34.Rupture) and (v14:TimeToDie() > (5 + 1))) then
				if (((5872 - (1001 + 413)) >= (3732 - 2058)) and v130) then
					return v34.Rupture;
				else
					if (((1854 - (244 + 638)) <= (2111 - (627 + 66))) and v34.Rupture:IsReady() and v19(v34.Rupture)) then
						return "Cast Rupture";
					end
					v86(v34.Rupture);
				end
			end
		end
		if ((not v13:StealthUp(true, true) and not v94() and (v72 < (17 - 11)) and not v132 and v10.BossFilteredFightRemains(">", v13:BuffRemains(v34.SliceandDice)) and (v13:BuffRemains(v34.SliceandDice) < (((603 - (512 + 90)) + v13:ComboPoints()) * (1907.8 - (1665 + 241))))) or ((5655 - (373 + 344)) < (2148 + 2614))) then
			if (v130 or ((663 + 1841) > (11247 - 6983))) then
				return v34.SliceandDice;
			else
				local v207 = 0 - 0;
				while true do
					if (((3252 - (35 + 1064)) == (1567 + 586)) and (v207 == (0 - 0))) then
						if ((v34.SliceandDice:IsReady() and v19(v34.SliceandDice)) or ((3 + 504) >= (3827 - (298 + 938)))) then
							return "Cast Slice and Dice Premed";
						end
						v86(v34.SliceandDice);
						break;
					end
				end
			end
		end
		if (((5740 - (233 + 1026)) == (6147 - (636 + 1030))) and (not v95(v132) or v84) and (v14:TimeToDie() > (4 + 2)) and v14:DebuffRefreshable(v34.Rupture, v78)) then
			if (v130 or ((2274 + 54) < (206 + 487))) then
				return v34.Rupture;
			else
				local v208 = 0 + 0;
				while true do
					if (((4549 - (55 + 166)) == (839 + 3489)) and (v208 == (0 + 0))) then
						if (((6064 - 4476) >= (1629 - (36 + 261))) and v34.Rupture:IsReady() and v19(v34.Rupture)) then
							return "Cast Rupture";
						end
						v86(v34.Rupture);
						break;
					end
				end
			end
		end
		if ((v13:BuffUp(v34.FinalityRuptureBuff) and v132 and (v72 <= (6 - 2)) and not v97(v34.Rupture)) or ((5542 - (34 + 1334)) > (1634 + 2614))) then
			if (v130 or ((3564 + 1022) <= (1365 - (1035 + 248)))) then
				return v34.Rupture;
			else
				if (((3884 - (20 + 1)) == (2013 + 1850)) and v34.Rupture:IsReady() and v19(v34.Rupture)) then
					return "Cast Rupture Finality";
				end
				v86(v34.Rupture);
			end
		end
		if ((v34.ColdBlood:IsReady() and v98(v132, v138) and v34.SecretTechnique:IsReady()) or ((601 - (134 + 185)) <= (1175 - (549 + 584)))) then
			local v186 = 685 - (314 + 371);
			while true do
				if (((15822 - 11213) >= (1734 - (478 + 490))) and ((0 + 0) == v186)) then
					if (v130 or ((2324 - (786 + 386)) == (8058 - 5570))) then
						return v34.ColdBlood;
					end
					if (((4801 - (1055 + 324)) > (4690 - (1093 + 247))) and v19(v34.ColdBlood)) then
						return "Cast Cold Blood (SecTec)";
					end
					break;
				end
			end
		end
		if (((780 + 97) > (40 + 336)) and v34.SecretTechnique:IsReady()) then
			if ((v98(v132, v138) and (not v34.ColdBlood:IsAvailable() or v13:BuffUp(v34.ColdBlood) or (v136 > (v133 - (7 - 5))) or not v34.ImprovedShadowDance:IsAvailable())) or ((10581 - 7463) <= (5266 - 3415))) then
				local v209 = 0 - 0;
				while true do
					if ((v209 == (0 + 0)) or ((635 - 470) >= (12036 - 8544))) then
						if (((2978 + 971) < (12418 - 7562)) and v130) then
							return v34.SecretTechnique;
						end
						if (v19(v34.SecretTechnique) or ((4964 - (364 + 324)) < (8267 - 5251))) then
							return "Cast Secret Technique";
						end
						break;
					end
				end
			end
		end
		if (((11254 - 6564) > (1368 + 2757)) and not v95(v132) and v34.Rupture:IsCastable()) then
			local v187 = 0 - 0;
			while true do
				if (((0 - 0) == v187) or ((151 - 101) >= (2164 - (1249 + 19)))) then
					if ((not v130 and v38 and not v84 and (v72 >= (2 + 0))) or ((6671 - 4957) >= (4044 - (686 + 400)))) then
						local function v217(v226)
							return v31.CanDoTUnit(v226, v79) and v226:DebuffRefreshable(v34.Rupture, v78);
						end
						v89(v34.Rupture, v217, (2 + 0) * v135, v73);
					end
					if ((v68 and (v14:DebuffRemains(v34.Rupture) < (v137 + (239 - (73 + 156)))) and (v137 <= (1 + 4)) and v32.CanDoTUnit(v14, v79) and v14:FilteredTimeToDie(">", (816 - (721 + 90)) + v137, -v14:DebuffRemains(v34.Rupture))) or ((17 + 1474) < (2090 - 1446))) then
						if (((1174 - (224 + 246)) < (1598 - 611)) and v130) then
							return v34.Rupture;
						else
							local v228 = 0 - 0;
							while true do
								if (((675 + 3043) > (46 + 1860)) and ((0 + 0) == v228)) then
									if ((v34.Rupture:IsReady() and v19(v34.Rupture)) or ((1904 - 946) > (12096 - 8461))) then
										return "Cast Rupture 2";
									end
									v86(v34.Rupture);
									break;
								end
							end
						end
					end
					break;
				end
			end
		end
		if (((4014 - (203 + 310)) <= (6485 - (1238 + 755))) and v34.BlackPowder:IsCastable() and not v84 and (v72 >= (1 + 2)) and not v42) then
			if (v130 or ((4976 - (709 + 825)) < (4695 - 2147))) then
				return v34.BlackPowder;
			else
				if (((4187 - 1312) >= (2328 - (196 + 668))) and v34.BlackPowder:IsReady() and v19(v34.BlackPowder)) then
					return "Cast Black Powder";
				end
				v86(v34.BlackPowder);
			end
		end
		if ((v34.Eviscerate:IsCastable() and v68) or ((18939 - 14142) >= (10135 - 5242))) then
			if (v130 or ((1384 - (171 + 662)) > (2161 - (4 + 89)))) then
				return v34.Eviscerate;
			else
				local v210 = 0 - 0;
				while true do
					if (((770 + 1344) > (4146 - 3202)) and (v210 == (0 + 0))) then
						if ((v34.Eviscerate:IsReady() and v19(v34.Eviscerate)) or ((3748 - (35 + 1451)) >= (4549 - (28 + 1425)))) then
							return "Cast Eviscerate";
						end
						v86(v34.Eviscerate);
						break;
					end
				end
			end
		end
		return false;
	end
	local function v101(v139, v140)
		local v141 = 1993 - (941 + 1052);
		local v142;
		local v143;
		local v144;
		local v145;
		local v146;
		local v147;
		local v148;
		local v149;
		local v150;
		local v151;
		while true do
			if ((v141 == (3 + 0)) or ((3769 - (822 + 692)) >= (5049 - 1512))) then
				if ((v150 >= v32.CPMaxSpend()) or ((1808 + 2029) < (1603 - (45 + 252)))) then
					return v100(v139, v140);
				end
				if (((2919 + 31) == (1016 + 1934)) and v13:BuffUp(v34.ShurikenTornado) and (v146 <= (4 - 2))) then
					return v100(v139, v140);
				end
				if ((v82 <= ((434 - (114 + 319)) + v24(v34.DeeperStratagem:IsAvailable() or v34.SecretStratagem:IsAvailable()))) or ((6780 - 2057) < (4225 - 927))) then
					return v100(v139, v140);
				end
				if (((725 + 411) >= (228 - 74)) and v34.Backstab:IsCastable() and not v147 and (v143 >= (5 - 2)) and v13:BuffUp(v34.ShadowBlades) and not v97(v34.Backstab) and v34.DanseMacabre:IsAvailable() and (v72 <= (1966 - (556 + 1407))) and not v144) then
					if (v139 or ((1477 - (741 + 465)) > (5213 - (170 + 295)))) then
						if (((2498 + 2242) >= (2896 + 256)) and v140) then
							return v34.Backstab;
						else
							return {v34.Backstab,v34.Stealth};
						end
					elseif (v22(v34.Backstab, v34.Stealth) or ((1654 + 924) >= (1920 + 1470))) then
						return "Cast Backstab (Stealth)";
					end
				end
				v141 = 1234 - (957 + 273);
			end
			if (((11 + 30) <= (665 + 996)) and (v141 == (7 - 5))) then
				v150 = v32.EffectiveComboPoints(v145);
				v151 = v34.Shadowstrike:IsCastable() or v148 or v149 or v142 or v13:BuffUp(v34.SepsisBuff);
				if (((1583 - 982) < (10874 - 7314)) and (v148 or v149)) then
					v151 = v151 and v14:IsInRange(123 - 98);
				else
					v151 = v151 and v68;
				end
				if (((2015 - (389 + 1391)) < (432 + 255)) and v151 and v148 and ((v72 < (1 + 3)) or v84)) then
					if (((10356 - 5807) > (2104 - (783 + 168))) and v139) then
						return v34.Shadowstrike;
					elseif (v19(v34.Shadowstrike) or ((15686 - 11012) < (4596 + 76))) then
						return "Cast Shadowstrike (Stealth)";
					end
				end
				v141 = 314 - (309 + 2);
			end
			if (((11264 - 7596) < (5773 - (1090 + 122))) and (v141 == (2 + 3))) then
				return false;
			end
			if ((v141 == (13 - 9)) or ((312 + 143) == (4723 - (628 + 490)))) then
				if (v34.Gloomblade:IsAvailable() or ((478 + 2185) == (8199 - 4887))) then
					if (((19545 - 15268) <= (5249 - (431 + 343))) and not v147 and (v143 >= (5 - 2)) and v13:BuffUp(v34.ShadowBlades) and not v97(v34.Gloomblade) and v34.DanseMacabre:IsAvailable() and (v72 <= (11 - 7))) then
						if (v139 or ((688 + 182) == (153 + 1036))) then
							if (((3248 - (556 + 1139)) <= (3148 - (6 + 9))) and v140) then
								return v34.Gloomblade;
							else
								return {v34.Gloomblade,v34.Stealth};
							end
						elseif (v22(v34.Gloomblade, v34.Stealth) or ((2406 - (28 + 141)) >= (1360 + 2151))) then
							return "Cast Gloomblade (Danse)";
						end
					end
				end
				if ((not v97(v34.Shadowstrike) and v13:BuffUp(v34.ShadowBlades)) or ((1633 - 309) > (2139 + 881))) then
					if (v139 or ((4309 - (486 + 831)) == (4894 - 3013))) then
						return v34.Shadowstrike;
					elseif (((10935 - 7829) > (289 + 1237)) and v19(v34.Shadowstrike)) then
						return "Cast Shadowstrike (Danse)";
					end
				end
				if (((9558 - 6535) < (5133 - (668 + 595))) and not v147 and (v72 >= (4 + 0))) then
					if (((29 + 114) > (201 - 127)) and v139) then
						return v34.ShurikenStorm;
					elseif (((308 - (23 + 267)) < (4056 - (1129 + 815))) and v19(v34.ShurikenStorm)) then
						return "Cast Shuriken Storm";
					end
				end
				if (((1484 - (371 + 16)) <= (3378 - (1326 + 424))) and v151) then
					if (((8769 - 4139) == (16919 - 12289)) and v139) then
						return v34.Shadowstrike;
					elseif (((3658 - (88 + 30)) > (3454 - (720 + 51))) and v19(v34.Shadowstrike)) then
						return "Cast Shadowstrike";
					end
				end
				v141 = 11 - 6;
			end
			if (((6570 - (421 + 1355)) >= (5402 - 2127)) and (v141 == (0 + 0))) then
				v142 = v13:BuffUp(v34.ShadowDanceBuff);
				v143 = v13:BuffRemains(v34.ShadowDanceBuff);
				v144 = v13:BuffUp(v34.TheRottenBuff);
				v145, v146 = v81, v82;
				v141 = 1084 - (286 + 797);
			end
			if (((5424 - 3940) == (2457 - 973)) and (v141 == (440 - (397 + 42)))) then
				v147 = v13:BuffUp(v34.PremeditationBuff) or (v140 and v34.Premeditation:IsAvailable());
				v148 = v13:BuffUp(v32.StealthSpell()) or (v140 and (v140:ID() == v32.StealthSpell():ID()));
				v149 = v13:BuffUp(v32.VanishBuffSpell()) or (v140 and (v140:ID() == v34.Vanish:ID()));
				if (((448 + 984) < (4355 - (24 + 776))) and v140 and (v140:ID() == v34.ShadowDance:ID())) then
					v142 = true;
					v143 = (12 - 4) + v34.ImprovedShadowDance:TalentRank();
					if ((v34.TheRotten:IsAvailable() and v13:HasTier(815 - (222 + 563), 3 - 1)) or ((767 + 298) > (3768 - (23 + 167)))) then
						v144 = true;
					end
					if (v34.TheFirstDance:IsAvailable() or ((6593 - (690 + 1108)) < (508 + 899))) then
						local v218 = 0 + 0;
						while true do
							if (((2701 - (40 + 808)) < (793 + 4020)) and (v218 == (0 - 0))) then
								v145 = v28(v13:ComboPointsMax(), v81 + 4 + 0);
								v146 = v13:ComboPointsMax() - v145;
								break;
							end
						end
					end
				end
				v141 = 2 + 0;
			end
		end
	end
	local function v102(v152, v153)
		local v154 = 0 + 0;
		local v155;
		local v156;
		while true do
			if (((574 - (47 + 524)) == v154) or ((1831 + 990) < (6645 - 4214))) then
				return false;
			end
			if ((v154 == (0 - 0)) or ((6554 - 3680) < (3907 - (1165 + 561)))) then
				v155 = v101(true, v152);
				if ((v41 and (v152:ID() == v34.Vanish:ID()) and (not v46 or not v155)) or ((80 + 2609) <= (1062 - 719))) then
					if (v19(v34.Vanish, nil) or ((714 + 1155) == (2488 - (341 + 138)))) then
						return "Cast Vanish";
					end
					return false;
				elseif (((v152:ID() == v34.Shadowmeld:ID()) and (not v47 or not v155)) or ((958 + 2588) < (4791 - 2469))) then
					if (v19(v34.Shadowmeld, nil) or ((2408 - (89 + 237)) == (15354 - 10581))) then
						return "Cast Shadowmeld";
					end
					return false;
				elseif (((6829 - 3585) > (1936 - (581 + 300))) and (v152:ID() == v34.ShadowDance:ID()) and (not v48 or not v155)) then
					if (v19(v34.ShadowDance, nil) or ((4533 - (855 + 365)) <= (4222 - 2444))) then
						return "Cast Shadow Dance";
					end
					return false;
				end
				v154 = 1 + 0;
			end
			if (((1236 - (1030 + 205)) == v154) or ((1335 + 86) >= (1958 + 146))) then
				v156 = {v152,v155};
				if (((3053 - 1241) <= (6653 - 3404)) and v153 and (v13:EnergyPredicted() < v153)) then
					v85(v156, v153);
					return false;
				end
				v154 = 1 + 1;
			end
			if (((947 + 676) <= (2026 - (10 + 59))) and (v154 == (1 + 1))) then
				v74 = v22(unpack(v156));
				if (((21728 - 17316) == (5575 - (671 + 492))) and v74) then
					return "| " .. v156[2 + 0]:Name();
				end
				v154 = 1218 - (369 + 846);
			end
		end
	end
	local function v103()
		if (((464 + 1286) >= (719 + 123)) and not v13:IsCasting() and not v13:IsChanneling()) then
			local v188 = v31.Interrupt(v34.Kick, 1953 - (1036 + 909), true);
			if (((3477 + 895) > (3106 - 1256)) and v188) then
				return v188;
			end
			v188 = v31.Interrupt(v34.Kick, 211 - (11 + 192), true, MouseOver, v36.KickMouseover);
			if (((118 + 114) < (996 - (135 + 40))) and v188) then
				return v188;
			end
			v188 = v31.Interrupt(v34.Blind, 36 - 21, BlindInterrupt);
			if (((313 + 205) < (1986 - 1084)) and v188) then
				return v188;
			end
			v188 = v31.Interrupt(v34.Blind, 22 - 7, BlindInterrupt, MouseOver, v36.BlindMouseover);
			if (((3170 - (50 + 126)) > (2389 - 1531)) and v188) then
				return v188;
			end
			v188 = v31.InterruptWithStun(v34.CheapShot, 2 + 6, v13:StealthUp(false, false));
			if (v188 or ((5168 - (1233 + 180)) <= (1884 - (522 + 447)))) then
				return v188;
			end
			v188 = v31.InterruptWithStun(v34.KidneyShot, 1429 - (107 + 1314), v13:ComboPoints() > (0 + 0));
			if (((12023 - 8077) > (1590 + 2153)) and v188) then
				return v188;
			end
		end
	end
	local function v104()
		local v157 = v31.HandleTopTrinket(v65, v39, 79 - 39, nil);
		if (v157 or ((5282 - 3947) >= (5216 - (716 + 1194)))) then
			return v157;
		end
		local v157 = v31.HandleBottomTrinket(v65, v39, 1 + 39, nil);
		if (((519 + 4325) > (2756 - (74 + 429))) and v157) then
			return v157;
		end
	end
	local function v105()
		if (((871 - 419) == (225 + 227)) and v39) then
			local v189 = 0 - 0;
			local v190;
			while true do
				if ((v189 == (0 + 0)) or ((14048 - 9491) < (5159 - 3072))) then
					v190 = v31.HandleDPSPotion(v10.BossFilteredFightRemains("<", 463 - (279 + 154)) or (v13:BuffUp(v34.SymbolsofDeath) and (v13:BuffUp(v34.ShadowBlades) or (v34.ShadowBlades:CooldownRemains() <= (788 - (454 + 324))))));
					if (((3048 + 826) == (3891 - (12 + 5))) and v190) then
						return v190;
					end
					break;
				end
			end
		end
	end
	local function v106()
		local v158 = 0 + 0;
		local v159;
		while true do
			if ((v158 == (4 - 2)) or ((717 + 1221) > (6028 - (277 + 816)))) then
				if ((v39 and v34.EchoingReprimand:IsCastable() and v34.EchoingReprimand:IsAvailable()) or ((18181 - 13926) < (4606 - (1058 + 125)))) then
					if (((273 + 1181) <= (3466 - (815 + 160))) and v93() and (v82 >= (12 - 9))) then
						if (v19(v34.EchoingReprimand, nil, nil) or ((9867 - 5710) <= (669 + 2134))) then
							return "Cast Echoing Reprimand";
						end
					end
				end
				if (((14186 - 9333) >= (4880 - (41 + 1857))) and v39 and v34.ShurikenTornado:IsAvailable() and v34.ShurikenTornado:IsReady()) then
					if (((6027 - (1222 + 671)) > (8676 - 5319)) and v93() and v13:BuffUp(v34.SymbolsofDeath) and (v80 <= (2 - 0)) and not v13:BuffUp(v34.Premeditation) and (not v34.Flagellation:IsAvailable() or (v34.Flagellation:CooldownRemains() > (1202 - (229 + 953)))) and (v72 >= (1777 - (1111 + 663)))) then
						if (v19(v34.ShurikenTornado, nil) or ((4996 - (874 + 705)) < (355 + 2179))) then
							return "Cast Shuriken Tornado";
						end
					end
				end
				if ((v39 and v34.ShurikenTornado:IsAvailable() and v34.ShurikenTornado:IsReady()) or ((1858 + 864) <= (340 - 176))) then
					if ((v93() and not v13:BuffUp(v34.ShadowDance) and not v13:BuffUp(v34.Flagellation) and not v13:BuffUp(v34.FlagellationPersistBuff) and not v13:BuffUp(v34.ShadowBlades) and (v72 <= (1 + 1))) or ((3087 - (642 + 37)) < (481 + 1628))) then
						if (v19(v34.ShurikenTornado, nil) or ((6 + 27) == (3653 - 2198))) then
							return "Cast Shuriken Tornado";
						end
					end
				end
				v158 = 457 - (233 + 221);
			end
			if ((v158 == (0 - 0)) or ((390 + 53) >= (5556 - (718 + 823)))) then
				if (((2129 + 1253) > (971 - (266 + 539))) and v39) then
					if ((v34.ArcaneTorrent:IsReady() and v68 and (v13:EnergyDeficitPredicted() >= ((42 - 27) + v13:EnergyRegen())) and v51) or ((1505 - (636 + 589)) == (7260 - 4201))) then
						if (((3879 - 1998) > (1025 + 268)) and v19(v34.ArcaneTorrent, nil)) then
							return "Cast Arcane Torrent";
						end
					end
					if (((857 + 1500) == (3372 - (657 + 358))) and v34.ArcanePulse:IsReady() and v68 and v51) then
						if (((325 - 202) == (280 - 157)) and v19(v34.ArcanePulse, nil)) then
							return "Cast Arcane Pulse";
						end
					end
					if ((v34.BagofTricks:IsReady() and v51) or ((2243 - (1151 + 36)) >= (3276 + 116))) then
						if (v19(v34.BagofTricks, nil) or ((285 + 796) < (3210 - 2135))) then
							return "Cast Bag of Tricks";
						end
					end
				end
				if ((v39 and v34.ColdBlood:IsReady() and not v34.SecretTechnique:IsAvailable() and (v81 >= (1837 - (1552 + 280)))) or ((1883 - (64 + 770)) >= (3010 + 1422))) then
					if (v19(v34.ColdBlood, nil) or ((10823 - 6055) <= (151 + 695))) then
						return "Cast Cold Blood";
					end
				end
				if ((v39 and v34.Sepsis:IsAvailable() and v34.Sepsis:IsReady()) or ((4601 - (157 + 1086)) <= (2842 - 1422))) then
					if ((v93() and v14:FilteredTimeToDie(">=", 70 - 54) and (v13:BuffUp(v34.PerforatedVeins) or not v34.PerforatedVeins:IsAvailable())) or ((5734 - 1995) <= (4100 - 1095))) then
						if (v19(v34.Sepsis, nil, nil) or ((2478 - (599 + 220)) >= (4249 - 2115))) then
							return "Cast Sepsis";
						end
					end
				end
				v158 = 1932 - (1813 + 118);
			end
			if ((v158 == (1 + 0)) or ((4477 - (841 + 376)) < (3299 - 944))) then
				if ((v39 and v34.Flagellation:IsAvailable() and v34.Flagellation:IsReady()) or ((156 + 513) == (11526 - 7303))) then
					if ((v93() and (v80 >= (864 - (464 + 395))) and (v14:TimeToDie() > (25 - 15)) and ((v99() and (v34.ShadowBlades:CooldownRemains() <= (2 + 1))) or v10.BossFilteredFightRemains("<=", 865 - (467 + 370)) or ((v34.ShadowBlades:CooldownRemains() >= (28 - 14)) and v34.InvigoratingShadowdust:IsAvailable() and v34.ShadowDance:IsAvailable())) and (not v34.InvigoratingShadowdust:IsAvailable() or v34.Sepsis:IsAvailable() or not v34.ShadowDance:IsAvailable() or ((v34.InvigoratingShadowdust:TalentRank() == (2 + 0)) and (v72 >= (6 - 4))) or (v34.SymbolsofDeath:CooldownRemains() <= (1 + 2)) or (v13:BuffRemains(v34.SymbolsofDeath) > (6 - 3)))) or ((2212 - (150 + 370)) < (1870 - (74 + 1208)))) then
						if (v19(v34.Flagellation, nil, nil) or ((11798 - 7001) < (17315 - 13664))) then
							return "Cast Flagellation";
						end
					end
				end
				if ((v39 and v34.SymbolsofDeath:IsReady()) or ((2973 + 1204) > (5240 - (14 + 376)))) then
					if ((v93() and (not v13:BuffUp(v34.TheRotten) or not v13:HasTier(52 - 22, 2 + 0)) and (v13:BuffRemains(v34.SymbolsofDeath) <= (3 + 0)) and (not v34.Flagellation:IsAvailable() or (v34.Flagellation:CooldownRemains() > (10 + 0)) or ((v13:BuffRemains(v34.ShadowDance) >= (5 - 3)) and v34.InvigoratingShadowdust:IsAvailable()) or (v34.Flagellation:IsReady() and (v80 >= (4 + 1)) and not v34.InvigoratingShadowdust:IsAvailable()))) or ((478 - (23 + 55)) > (2632 - 1521))) then
						if (((2036 + 1015) > (903 + 102)) and v19(v34.SymbolsofDeath, nil)) then
							return "Cast Symbols of Death";
						end
					end
				end
				if (((5725 - 2032) <= (1379 + 3003)) and v39 and v34.ShadowBlades:IsReady()) then
					if ((v93() and ((v80 <= (902 - (652 + 249))) or v13:HasTier(82 - 51, 1872 - (708 + 1160))) and (v13:BuffUp(v34.Flagellation) or v13:BuffUp(v34.FlagellationPersistBuff) or not v34.Flagellation:IsAvailable())) or ((8908 - 5626) > (7475 - 3375))) then
						if (v19(v34.ShadowBlades, nil) or ((3607 - (10 + 17)) < (639 + 2205))) then
							return "Cast Shadow Blades";
						end
					end
				end
				v158 = 1734 - (1400 + 332);
			end
			if (((170 - 81) < (6398 - (242 + 1666))) and ((3 + 3) == v158)) then
				return false;
			end
			if ((v158 == (2 + 1)) or ((4247 + 736) < (2748 - (850 + 90)))) then
				if (((6705 - 2876) > (5159 - (360 + 1030))) and v39 and v34.ShadowDance:IsAvailable() and v87() and v34.ShadowDance:IsReady()) then
					if (((1315 + 170) <= (8196 - 5292)) and not v13:BuffUp(v34.ShadowDance) and v10.BossFilteredFightRemains("<=", (10 - 2) + ((1664 - (909 + 752)) * v24(v34.Subterfuge:IsAvailable())))) then
						if (((5492 - (109 + 1114)) == (7815 - 3546)) and v19(v34.ShadowDance)) then
							return "Cast Shadow Dance";
						end
					end
				end
				if (((151 + 236) <= (3024 - (6 + 236))) and v39 and v34.GoremawsBite:IsAvailable() and v34.GoremawsBite:IsReady()) then
					if ((v93() and (v82 >= (2 + 1)) and (not v34.ShadowDance:IsReady() or (v34.ShadowDance:IsAvailable() and v13:BuffUp(v34.ShadowDance) and not v34.InvigoratingShadowdust:IsAvailable()) or ((v72 < (4 + 0)) and not v34.InvigoratingShadowdust:IsAvailable()) or v34.TheRotten:IsAvailable())) or ((4478 - 2579) <= (1601 - 684))) then
						if (v19(v34.GoremawsBite) or ((5445 - (1076 + 57)) <= (145 + 731))) then
							return "Cast Goremaw's Bite";
						end
					end
				end
				if (((2921 - (579 + 110)) <= (205 + 2391)) and v34.ThistleTea:IsReady()) then
					if (((1853 + 242) < (1957 + 1729)) and ((((v34.SymbolsofDeath:CooldownRemains() >= (410 - (174 + 233))) or v13:BuffUp(v34.SymbolsofDeath)) and not v13:BuffUp(v34.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (279 - 179)) and ((v82 >= (3 - 1)) or (v72 >= (2 + 1)))) or ((v34.ThistleTea:ChargesFractional() >= ((1176.75 - (663 + 511)) - ((0.15 + 0) * v34.InvigoratingShadowdust:TalentRank()))) and (v34.Vanish:IsReady() or not v41) and v13:BuffUp(v34.ShadowDance) and v14:DebuffUp(v34.Rupture) and (v72 < (1 + 2))))) or ((v13:BuffRemains(v34.ShadowDance) >= (12 - 8)) and not v13:BuffUp(v34.ThistleTea) and (v72 >= (2 + 1))) or (not v13:BuffUp(v34.ThistleTea) and v10.BossFilteredFightRemains("<=", (13 - 7) * v34.ThistleTea:Charges())))) then
						if (v19(v34.ThistleTea, nil, nil) or ((3861 - 2266) >= (2135 + 2339))) then
							return "Thistle Tea";
						end
					end
				end
				v158 = 7 - 3;
			end
			if (((4 + 1) == v158) or ((423 + 4196) < (3604 - (478 + 244)))) then
				if ((v34.Fireblood:IsCastable() and v159 and v51) or ((811 - (440 + 77)) >= (2197 + 2634))) then
					if (((7426 - 5397) <= (4640 - (655 + 901))) and v19(v34.Fireblood, nil)) then
						return "Cast Fireblood";
					end
				end
				if ((v34.AncestralCall:IsCastable() and v159 and v51) or ((378 + 1659) == (1853 + 567))) then
					if (((3011 + 1447) > (15727 - 11823)) and v19(v34.AncestralCall, nil)) then
						return "Cast Ancestral Call";
					end
				end
				if (((1881 - (695 + 750)) >= (419 - 296)) and v34.ThistleTea:IsReady()) then
					if (((771 - 271) < (7303 - 5487)) and ((((v34.SymbolsofDeath:CooldownRemains() >= (354 - (285 + 66))) or v13:BuffUp(v34.SymbolsofDeath)) and not v13:BuffUp(v34.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (233 - 133)) and ((v13:ComboPointsDeficit() >= (1312 - (682 + 628))) or (v72 >= (1 + 2)))) or ((v34.ThistleTea:ChargesFractional() >= (301.75 - (176 + 123))) and v13:BuffUp(v34.ShadowDanceBuff)))) or ((v13:BuffRemains(v34.ShadowDanceBuff) >= (2 + 2)) and not v13:BuffUp(v34.ThistleTea) and (v72 >= (3 + 0))) or (not v13:BuffUp(v34.ThistleTea) and v10.BossFilteredFightRemains("<=", (275 - (239 + 30)) * v34.ThistleTea:Charges())))) then
						if (((972 + 2602) == (3436 + 138)) and v19(v34.ThistleTea, nil, nil)) then
							return "Thistle Tea";
						end
					end
				end
				v158 = 10 - 4;
			end
			if (((689 - 468) < (705 - (306 + 9))) and (v158 == (13 - 9))) then
				v159 = v13:BuffUp(v34.ShadowBlades) or (not v34.ShadowBlades:IsAvailable() and v13:BuffUp(v34.SymbolsofDeath)) or v10.BossFilteredFightRemains("<", 4 + 16);
				if ((v34.BloodFury:IsCastable() and v159 and v51) or ((1358 + 855) <= (684 + 737))) then
					if (((8744 - 5686) < (6235 - (1140 + 235))) and v19(v34.BloodFury, nil)) then
						return "Cast Blood Fury";
					end
				end
				if ((v34.Berserking:IsCastable() and v159 and v51) or ((825 + 471) >= (4078 + 368))) then
					if (v19(v34.Berserking, nil) or ((358 + 1035) > (4541 - (33 + 19)))) then
						return "Cast Berserking";
					end
				end
				v158 = 2 + 3;
			end
		end
	end
	local function v107(v160)
		if ((v39 and not (v31.IsSoloMode() and v13:IsTanking(v14))) or ((13259 - 8835) < (12 + 15))) then
			local v191 = 0 - 0;
			while true do
				if ((v191 == (0 + 0)) or ((2686 - (586 + 103)) > (348 + 3467))) then
					if (((10667 - 7202) > (3401 - (1309 + 179))) and v41 and v34.Vanish:IsCastable()) then
						if (((1323 - 590) < (792 + 1027)) and ((v82 > (2 - 1)) or (v13:BuffUp(v34.ShadowBlades) and v34.InvigoratingShadowdust:IsAvailable())) and not v91() and ((v34.Flagellation:CooldownRemains() >= (46 + 14)) or not v34.Flagellation:IsAvailable() or v10.BossFilteredFightRemains("<=", (63 - 33) * v34.Vanish:Charges())) and ((v34.SymbolsofDeath:CooldownRemains() > (5 - 2)) or not v13:HasTier(639 - (295 + 314), 4 - 2)) and ((v34.SecretTechnique:CooldownRemains() >= (1972 - (1300 + 662))) or not v34.SecretTechnique:IsAvailable() or ((v34.Vanish:Charges() >= (6 - 4)) and v34.InvigoratingShadowdust:IsAvailable() and (v13:BuffUp(v34.TheRotten) or not v34.TheRotten:IsAvailable())))) then
							local v229 = 1755 - (1178 + 577);
							while true do
								if ((v229 == (0 + 0)) or ((12992 - 8597) == (6160 - (851 + 554)))) then
									v74 = v102(v34.Vanish, v160);
									if (v74 or ((3355 + 438) < (6569 - 4200))) then
										return "Vanish Macro " .. v74;
									end
									break;
								end
							end
						end
					end
					if ((v51 and v49 and (v13:Energy() < (86 - 46)) and v34.Shadowmeld:IsCastable()) or ((4386 - (115 + 187)) == (203 + 62))) then
						if (((4126 + 232) == (17173 - 12815)) and v21(v34.Shadowmeld, v13:EnergyTimeToX(1201 - (160 + 1001)))) then
							return "Pool for Shadowmeld";
						end
					end
					v191 = 1 + 0;
				end
				if ((v191 == (1 + 0)) or ((6423 - 3285) < (1351 - (237 + 121)))) then
					if (((4227 - (525 + 372)) > (4403 - 2080)) and v51 and v34.Shadowmeld:IsCastable() and v68 and not v13:IsMoving() and (v13:EnergyPredicted() >= (131 - 91)) and (v13:EnergyDeficitPredicted() >= (152 - (96 + 46))) and not v91() and (v82 > (781 - (643 + 134)))) then
						v74 = v102(v34.Shadowmeld, v160);
						if (v74 or ((1309 + 2317) == (9564 - 5575))) then
							return "Shadowmeld Macro " .. v74;
						end
					end
					break;
				end
			end
		end
		if ((v68 and v34.ShadowDance:IsCastable()) or ((3400 - 2484) == (2562 + 109))) then
			if (((533 - 261) == (555 - 283)) and (v14:DebuffUp(v34.Rupture) or v34.InvigoratingShadowdust:IsAvailable()) and v96() and (not v34.TheFirstDance:IsAvailable() or (v82 >= (723 - (316 + 403))) or v13:BuffUp(v34.ShadowBlades)) and ((v92() and v91()) or ((v13:BuffUp(v34.ShadowBlades) or (v13:BuffUp(v34.SymbolsofDeath) and not v34.Sepsis:IsAvailable()) or ((v13:BuffRemains(v34.SymbolsofDeath) >= (3 + 1)) and not v13:HasTier(82 - 52, 1 + 1)) or (not v13:BuffUp(v34.SymbolsofDeath) and v13:HasTier(75 - 45, 2 + 0))) and (v34.SecretTechnique:CooldownRemains() < (4 + 6 + ((41 - 29) * v24(not v34.InvigoratingShadowdust:IsAvailable() or v13:HasTier(143 - 113, 3 - 1)))))))) then
				local v211 = 0 + 0;
				while true do
					if (((8364 - 4115) <= (237 + 4602)) and (v211 == (0 - 0))) then
						v74 = v102(v34.ShadowDance, v160);
						if (((2794 - (12 + 5)) < (12428 - 9228)) and v74) then
							return "ShadowDance Macro 1 " .. v74;
						end
						break;
					end
				end
			end
		end
		return false;
	end
	local function v108(v161)
		local v162 = not v161 or (v13:EnergyPredicted() >= v161);
		if (((202 - 107) < (4159 - 2202)) and v38 and v34.ShurikenStorm:IsCastable() and (v72 >= ((4 - 2) + v18((v34.Gloomblade:IsAvailable() and (v13:BuffRemains(v34.LingeringShadowBuff) >= (2 + 4))) or v13:BuffUp(v34.PerforatedVeinsBuff))))) then
			local v192 = 1973 - (1656 + 317);
			while true do
				if (((737 + 89) < (1376 + 341)) and (v192 == (0 - 0))) then
					if (((7018 - 5592) >= (1459 - (5 + 349))) and v162 and v19(v34.ShurikenStorm)) then
						return "Cast Shuriken Storm";
					end
					v85(v34.ShurikenStorm, v161);
					break;
				end
			end
		end
		if (((13081 - 10327) <= (4650 - (266 + 1005))) and v68) then
			if (v34.Gloomblade:IsCastable() or ((2588 + 1339) == (4821 - 3408))) then
				local v212 = 0 - 0;
				while true do
					if (((1696 - (561 + 1135)) == v212) or ((1503 - 349) <= (2590 - 1802))) then
						if ((v162 and v19(v34.Gloomblade)) or ((2709 - (507 + 559)) > (8478 - 5099))) then
							return "Cast Gloomblade";
						end
						v85(v34.Gloomblade, v161);
						break;
					end
				end
			elseif (v34.Backstab:IsCastable() or ((8668 - 5865) > (4937 - (212 + 176)))) then
				local v214 = 905 - (250 + 655);
				while true do
					if ((v214 == (0 - 0)) or ((384 - 164) >= (4727 - 1705))) then
						if (((4778 - (1869 + 87)) == (9787 - 6965)) and v162 and v19(v34.Backstab)) then
							return "Cast Backstab";
						end
						v85(v34.Backstab, v161);
						break;
					end
				end
			end
		end
		return false;
	end
	local function v109()
		local v163 = 1901 - (484 + 1417);
		while true do
			if ((v163 == (2 - 1)) or ((1777 - 716) == (2630 - (48 + 725)))) then
				if (((4508 - 1748) > (3659 - 2295)) and v52 and (v13:HealthPercentage() <= v54)) then
					local v213 = 0 + 0;
					while true do
						if ((v213 == (0 - 0)) or ((1372 + 3530) <= (1048 + 2547))) then
							if ((v53 == "Refreshing Healing Potion") or ((4705 - (152 + 701)) == (1604 - (430 + 881)))) then
								if (v35.RefreshingHealingPotion:IsReady() or ((598 + 961) == (5483 - (557 + 338)))) then
									if (Press(v36.RefreshingHealingPotion, nil, nil, true) or ((1326 + 3158) == (2220 - 1432))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((15996 - 11428) >= (10379 - 6472)) and (v53 == "Dreamwalker's Healing Potion")) then
								if (((2684 - 1438) < (4271 - (499 + 302))) and v35.DreamwalkersHealingPotion:IsReady()) then
									if (((4934 - (39 + 827)) >= (2682 - 1710)) and Press(v36.RefreshingHealingPotion, nil, nil, true)) then
										return "dreamwalker's healing potion defensive 4";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((1100 - 607) < (15462 - 11569)) and (v163 == (0 - 0))) then
				if ((v55 and v40 and v34.Shiv:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v31.UnitHasEnrageBuff(v14)) or ((127 + 1346) >= (9752 - 6420))) then
					if (Press(v34.Shiv, not IsInMeleeRange) or ((649 + 3402) <= (1830 - 673))) then
						return "shiv dispel enrage";
					end
				end
				if (((708 - (103 + 1)) < (3435 - (475 + 79))) and v35.Healthstone:IsReady() and v56 and (v13:HealthPercentage() <= v57)) then
					if (Press(v36.Healthstone, nil, nil, true) or ((1945 - 1045) == (10806 - 7429))) then
						return "healthstone defensive 3";
					end
				end
				v163 = 1 + 0;
			end
		end
	end
	local function v110()
		if (((3925 + 534) > (2094 - (1395 + 108))) and not v13:AffectingCombat() and v37) then
			if (((9888 - 6490) >= (3599 - (7 + 1197))) and v34.Stealth:IsCastable() and (v63 == "Always")) then
				v74 = v32.Stealth(v32.StealthSpell());
				if (v74 or ((952 + 1231) >= (986 + 1838))) then
					return v74;
				end
			elseif (((2255 - (27 + 292)) == (5672 - 3736)) and v34.Stealth:IsCastable() and (v63 == "Distance") and v14:IsInRange(v64)) then
				local v215 = 0 - 0;
				while true do
					if ((v215 == (0 - 0)) or ((9528 - 4696) < (8213 - 3900))) then
						v74 = v32.Stealth(v32.StealthSpell());
						if (((4227 - (43 + 96)) > (15802 - 11928)) and v74) then
							return v74;
						end
						break;
					end
				end
			end
			if (((9793 - 5461) == (3595 + 737)) and not v13:BuffUp(v34.ShadowDanceBuff) and not v13:BuffUp(v32.VanishBuffSpell())) then
				v74 = v32.Stealth(v32.StealthSpell());
				if (((1130 + 2869) >= (5731 - 2831)) and v74) then
					return v74;
				end
			end
			if ((v31.TargetIsValid() and (v14:IsSpellInRange(v34.Shadowstrike) or v68)) or ((968 + 1557) > (7615 - 3551))) then
				if (((1377 + 2994) == (321 + 4050)) and v13:StealthUp(true, true)) then
					local v216 = 1751 - (1414 + 337);
					while true do
						if ((v216 == (1940 - (1642 + 298))) or ((693 - 427) > (14343 - 9357))) then
							v75 = v101(true);
							if (((5908 - 3917) >= (305 + 620)) and v75) then
								if (((355 + 100) < (3025 - (357 + 615))) and (type(v75) == "table") and (#v75 > (1 + 0))) then
									if (v23(nil, unpack(v75)) or ((2026 - 1200) == (4157 + 694))) then
										return "Stealthed Macro Cast or Pool (OOC): " .. v75[2 - 1]:Name();
									end
								elseif (((147 + 36) == (13 + 170)) and v21(v75)) then
									return "Stealthed Cast or Pool (OOC): " .. v75:Name();
								end
							end
							break;
						end
					end
				elseif (((729 + 430) <= (3089 - (384 + 917))) and (v81 >= (702 - (128 + 569)))) then
					local v227 = 1543 - (1407 + 136);
					while true do
						if ((v227 == (1887 - (687 + 1200))) or ((5217 - (556 + 1154)) > (15190 - 10872))) then
							v74 = v100();
							if (v74 or ((3170 - (9 + 86)) <= (3386 - (275 + 146)))) then
								return v74 .. " (OOC)";
							end
							break;
						end
					end
				elseif (((222 + 1143) <= (2075 - (29 + 35))) and v34.Backstab:IsCastable()) then
					if (v19(v34.Backstab) or ((12303 - 9527) > (10678 - 7103))) then
						return "Cast Backstab (OOC)";
					end
				end
			end
			return;
		end
	end
	local v111 = {{v34.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v34.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v81 > (0 - 0);
	end},{v34.CheapShot,"Cast Cheap Shot (Interrupt)",function()
		return v13:StealthUp(true, true);
	end}};
	local function v112()
		local v164 = 303 - (121 + 182);
		while true do
			if ((v164 == (0 + 0)) or ((3794 - (988 + 252)) == (543 + 4261))) then
				v37 = EpicSettings.Toggles['ooc'];
				v38 = EpicSettings.Toggles['aoe'];
				v164 = 1 + 0;
			end
			if (((4547 - (49 + 1921)) == (3467 - (223 + 667))) and (v164 == (53 - (51 + 1)))) then
				v39 = EpicSettings.Toggles['cds'];
				v40 = EpicSettings.Toggles['dispel'];
				v164 = 2 - 0;
			end
			if ((v164 == (3 - 1)) or ((1131 - (146 + 979)) >= (534 + 1355))) then
				v41 = EpicSettings.Toggles['vanish'];
				v42 = EpicSettings.Toggles['funnel'];
				break;
			end
		end
	end
	local function v113()
		v43 = EpicSettings.Settings['BurnShadowDance'];
		v44 = EpicSettings.Settings['UsePriorityRotation'];
		v45 = EpicSettings.Settings['RangedMultiDoT'];
		v46 = EpicSettings.Settings['StealthMacroVanish'];
		v47 = EpicSettings.Settings['StealthMacroShadowmeld'];
		v48 = EpicSettings.Settings['StealthMacroShadowDance'];
		v49 = EpicSettings.Settings['PoolForShadowmeld'];
		v50 = EpicSettings.Settings['EviscerateDMGOffset'] or (606 - (311 + 294));
		v51 = EpicSettings.Settings['UseRacials'];
		v52 = EpicSettings.Settings['UseHealingPotion'];
		v53 = EpicSettings.Settings['HealingPotionName'];
		v54 = EpicSettings.Settings['HealingPotionHP'] or (2 - 1);
		v55 = EpicSettings.Settings['DispelBuffs'];
		v56 = EpicSettings.Settings['UseHealthstone'];
		v57 = EpicSettings.Settings['HealthstoneHP'] or (1 + 0);
		v58 = EpicSettings.Settings['InterruptWithStun'];
		v59 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v60 = EpicSettings.Settings['InterruptThreshold'];
		v61 = EpicSettings.Settings['AutoFocusTank'];
		v62 = EpicSettings.Settings['AutoTricksTank'];
		v63 = EpicSettings.Settings['UsageStealthOOC'];
		v64 = EpicSettings.Settings['StealthRange'] or (1443 - (496 + 947));
	end
	local function v114()
		v113();
		v112();
		v75 = nil;
		v77 = nil;
		v76 = 1358 - (1233 + 125);
		v66 = (v34.AcrobaticStrikes:IsAvailable() and (4 + 4)) or (5 + 0);
		v67 = (v34.AcrobaticStrikes:IsAvailable() and (3 + 10)) or (1655 - (963 + 682));
		v68 = v14:IsInMeleeRange(v66);
		v69 = v14:IsInMeleeRange(v67);
		if (((423 + 83) <= (3396 - (504 + 1000))) and v38) then
			local v193 = 0 + 0;
			while true do
				if ((v193 == (1 + 0)) or ((190 + 1818) > (3270 - 1052))) then
					v72 = #v71;
					v73 = v13:GetEnemiesInMeleeRange(v66);
					break;
				end
				if (((324 + 55) <= (2412 + 1735)) and (v193 == (182 - (156 + 26)))) then
					v70 = v13:GetEnemiesInRange(18 + 12);
					v71 = v13:GetEnemiesInMeleeRange(v67);
					v193 = 1 - 0;
				end
			end
		else
			v70 = {};
			v71 = {};
			v72 = 165 - (149 + 15);
			v73 = {};
		end
		v81 = v13:ComboPoints();
		v80 = v32.EffectiveComboPoints(v81);
		v82 = v13:ComboPointsDeficit();
		v84 = v88();
		v83 = v13:EnergyMax() - v90();
		if ((v13:BuffUp(v34.ShurikenTornado, nil, true) and (v81 < v32.CPMaxSpend())) or ((5474 - (890 + 70)) <= (1126 - (39 + 78)))) then
			local v194 = 482 - (14 + 468);
			local v195;
			while true do
				if ((v194 == (0 - 0)) or ((9771 - 6275) == (616 + 576))) then
					v195 = v32.TimeToNextTornado();
					if ((v195 <= v13:GCDRemains()) or (v30(v13:GCDRemains() - v195) < (0.25 + 0)) or ((45 + 163) == (1337 + 1622))) then
						local v219 = 0 + 0;
						local v220;
						while true do
							if (((8186 - 3909) >= (1298 + 15)) and (v219 == (0 - 0))) then
								v220 = v72 + v24(v13:BuffUp(v34.ShadowBlades));
								v81 = v28(v81 + v220, v32.CPMaxSpend());
								v219 = 1 + 0;
							end
							if (((2638 - (12 + 39)) < (2953 + 221)) and (v219 == (2 - 1))) then
								v82 = v29(v82 - v220, 0 - 0);
								if ((v80 < v32.CPMaxSpend()) or ((1222 + 2898) <= (1157 + 1041))) then
									v80 = v81;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
		v78 = ((9 - 5) + (v80 * (3 + 1))) * (0.3 - 0);
		v79 = v34.Eviscerate:Damage() * v50;
		if ((not v13:AffectingCombat() and v61) or ((3306 - (1596 + 114)) == (2239 - 1381))) then
			local v196 = v31.FocusUnit(false, nil, nil, "TANK", 733 - (164 + 549));
			if (((4658 - (1059 + 379)) == (3998 - 778)) and v196) then
				return v196;
			end
		end
		if ((Focus and v62 and (v31.UnitGroupRole(Focus) == "TANK") and v34.TricksoftheTrade:IsCastable()) or ((727 + 675) > (611 + 3009))) then
			if (((2966 - (145 + 247)) == (2113 + 461)) and Press(v36.TricksoftheTradeFocus)) then
				return "tricks of the trade tank";
			end
		end
		v74 = v32.CrimsonVial();
		if (((831 + 967) < (8173 - 5416)) and v74) then
			return v74;
		end
		v74 = v32.Feint();
		if (v74 or ((73 + 304) > (2244 + 360))) then
			return v74;
		end
		v32.Poisons();
		v74 = v110();
		if (((921 - 353) < (1631 - (254 + 466))) and v74) then
			return v74;
		end
		if (((3845 - (544 + 16)) < (13436 - 9208)) and v31.TargetIsValid()) then
			local v197 = 628 - (294 + 334);
			local v198;
			while true do
				if (((4169 - (236 + 17)) > (1435 + 1893)) and (v197 == (0 + 0))) then
					v74 = v103();
					if (((9415 - 6915) < (18175 - 14336)) and ShoulReturn) then
						return "Interrupts " .. v74;
					end
					v74 = v109();
					if (((262 + 245) == (418 + 89)) and ShoulReturn) then
						return v74;
					end
					v197 = 795 - (413 + 381);
				end
				if (((11 + 229) <= (6731 - 3566)) and (v197 == (9 - 5))) then
					if (((2804 - (582 + 1388)) >= (1371 - 566)) and ((v82 <= (1 + 0)) or (v10.BossFilteredFightRemains("<=", 365 - (326 + 38)) and (v80 >= (8 - 5))))) then
						local v221 = 0 - 0;
						while true do
							if ((v221 == (620 - (47 + 573))) or ((1344 + 2468) < (9836 - 7520))) then
								v74 = v100();
								if (v74 or ((4304 - 1652) <= (3197 - (1269 + 395)))) then
									return "Finish: " .. v74;
								end
								break;
							end
						end
					end
					if (((v72 >= (496 - (76 + 416))) and (v80 >= (447 - (319 + 124)))) or ((8224 - 4626) < (2467 - (564 + 443)))) then
						local v222 = 0 - 0;
						while true do
							if ((v222 == (458 - (337 + 121))) or ((12060 - 7944) < (3970 - 2778))) then
								v74 = v100();
								if (v74 or ((5288 - (1261 + 650)) <= (383 + 520))) then
									return "Finish: " .. v74;
								end
								break;
							end
						end
					end
					if (((6335 - 2359) >= (2256 - (772 + 1045))) and v77) then
						v85(v77);
					end
					v74 = v108(v83);
					v197 = 1 + 4;
				end
				if (((3896 - (102 + 42)) == (5596 - (1524 + 320))) and ((1272 - (1049 + 221)) == v197)) then
					v74 = v105();
					if (((4202 - (18 + 138)) > (6596 - 3901)) and v74) then
						return "DPS Potion";
					end
					if ((v34.SliceandDice:IsCastable() and (v72 < v32.CPMaxSpend()) and (v13:BuffRemains(v34.SliceandDice) < v13:GCD()) and v10.BossFilteredFightRemains(">", 1108 - (67 + 1035)) and (v81 >= (352 - (136 + 212)))) or ((15064 - 11519) == (2562 + 635))) then
						if (((2207 + 187) > (1977 - (240 + 1364))) and v34.SliceandDice:IsReady() and v19(v34.SliceandDice)) then
							return "Cast Slice and Dice (Low Duration)";
						end
						v86(v34.SliceandDice);
					end
					if (((5237 - (1050 + 32)) <= (15110 - 10878)) and v13:StealthUp(true, true)) then
						local v223 = 0 + 0;
						while true do
							if ((v223 == (1056 - (331 + 724))) or ((289 + 3292) == (4117 - (269 + 375)))) then
								v19(v34.PoolEnergy);
								return "Stealthed Pooling";
							end
							if (((5720 - (267 + 458)) > (1042 + 2306)) and ((0 - 0) == v223)) then
								v75 = v101(true);
								if (v75 or ((1572 - (667 + 151)) > (5221 - (1410 + 87)))) then
									if (((2114 - (1504 + 393)) >= (153 - 96)) and (type(v75) == "table") and (#v75 > (2 - 1))) then
										if (v23(nil, unpack(v75)) or ((2866 - (461 + 335)) >= (516 + 3521))) then
											return "Stealthed Macro " .. v75[1762 - (1730 + 31)]:Name() .. "|" .. v75[1669 - (728 + 939)]:Name();
										end
									elseif (((9580 - 6875) == (5486 - 2781)) and v13:BuffUp(v34.ShurikenTornado) and (v81 ~= v13:ComboPoints()) and ((v75 == v34.BlackPowder) or (v75 == v34.Eviscerate) or (v75 == v34.Rupture) or (v75 == v34.SliceandDice))) then
										if (((139 - 78) == (1129 - (138 + 930))) and v23(nil, v34.ShurikenTornado, v75)) then
											return "Stealthed Tornado Cast  " .. v75:Name();
										end
									elseif ((type(v75) ~= "boolean") or ((639 + 60) >= (1014 + 282))) then
										if (v21(v75) or ((1529 + 254) >= (14764 - 11148))) then
											return "Stealthed Cast " .. v75:Name();
										end
									end
								end
								v223 = 1767 - (459 + 1307);
							end
						end
					end
					v197 = 1873 - (474 + 1396);
				end
				if ((v197 == (8 - 3)) or ((3668 + 245) > (15 + 4512))) then
					if (((12534 - 8158) > (104 + 713)) and v74) then
						return "Build: " .. v74;
					end
					if (((16227 - 11366) > (3593 - 2769)) and v75 and v68) then
						if (((type(v75) == "table") and (#v75 > (592 - (562 + 29)))) or ((1180 + 203) >= (3550 - (374 + 1045)))) then
							if (v23(v13:EnergyTimeToX(v76), unpack(v75)) or ((1485 + 391) >= (7890 - 5349))) then
								return "Macro pool towards " .. v75[639 - (448 + 190)]:Name() .. " at " .. v76;
							end
						elseif (((576 + 1206) <= (1703 + 2069)) and v75:IsCastable()) then
							local v230 = 0 + 0;
							while true do
								if ((v230 == (0 - 0)) or ((14604 - 9904) < (2307 - (1307 + 187)))) then
									v76 = v29(v76, v75:Cost());
									if (((12685 - 9486) < (9482 - 5432)) and v21(v75, v13:EnergyTimeToX(v76))) then
										return "Pool towards: " .. v75:Name() .. " at " .. v76;
									end
									break;
								end
							end
						end
					end
					if ((v34.ShurikenToss:IsCastable() and v14:IsInRange(91 - 61) and not v69 and not v13:StealthUp(true, true) and not v13:BuffUp(v34.Sprint) and (v13:EnergyDeficitPredicted() < (703 - (232 + 451))) and ((v82 >= (1 + 0)) or (v13:EnergyTimeToMax() <= (1.2 + 0)))) or ((5515 - (510 + 54)) < (8925 - 4495))) then
						if (((132 - (13 + 23)) == (186 - 90)) and v21(v34.ShurikenToss)) then
							return "Cast Shuriken Toss";
						end
					end
					break;
				end
				if ((v197 == (3 - 0)) or ((4975 - 2236) > (5096 - (830 + 258)))) then
					v198 = nil;
					if (not v34.Vigor:IsAvailable() or v34.Shadowcraft:IsAvailable() or ((80 - 57) == (710 + 424))) then
						v198 = v13:EnergyDeficitPredicted() <= v90();
					else
						v198 = v13:EnergyPredicted() >= v90();
					end
					if (v198 or v34.InvigoratingShadowdust:IsAvailable() or ((2292 + 401) >= (5552 - (860 + 581)))) then
						v74 = v107(v83);
						if (v74 or ((15920 - 11604) <= (1704 + 442))) then
							return "Stealth CDs: " .. v74;
						end
					end
					if ((v80 >= v32.CPMaxSpend()) or ((3787 - (237 + 4)) <= (6601 - 3792))) then
						v74 = v100();
						if (((12407 - 7503) > (4106 - 1940)) and v74) then
							return "Finish: " .. v74;
						end
					end
					v197 = 4 + 0;
				end
				if (((63 + 46) >= (339 - 249)) and (v197 == (1 + 0))) then
					v74 = v106();
					if (((2708 + 2270) > (4331 - (85 + 1341))) and v74) then
						return "CDs: " .. v74;
					end
					v74 = v104();
					if (v74 or ((5163 - 2137) <= (6439 - 4159))) then
						return "Trinkets";
					end
					v197 = 374 - (45 + 327);
				end
			end
		end
	end
	local function v115()
		v10.Print("Subtlety Rogue by Epic BoomK");
		EpicSettings.SetupVersion("Subtlety Rogue  X v 10.2.5.02 By BoomK");
	end
	v10.SetAPL(492 - 231, v114, v115);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

