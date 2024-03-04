local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((4561 - 2973) >= (93 + 1239)) and not v5) then
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
	local v15 = v9.Spell;
	local v16 = v9.MultiSpell;
	local v17 = v9.Item;
	local v18 = v9.Utils.BoolToInt;
	local v19 = v9.Cast;
	local v20 = v9.Press;
	local v21 = v9.CastLeftNameplate;
	local v22 = v9.CastPooling;
	local v23 = v9.CastQueue;
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
	local v35 = v15.Rogue.Subtlety;
	local v36 = v17.Rogue.Subtlety;
	local v37 = v34.Rogue.Subtlety;
	local v38 = false;
	local v39 = false;
	local v40 = false;
	local v41 = false;
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
	local v64 = {v36.Mirror:ID(),v36.WitherbarksBranch:ID(),v36.AshesoftheEmbersoul:ID()};
	local v65, v66, v67, v68;
	local v69, v70, v71, v72;
	local v73;
	local v74, v75, v76;
	local v77, v78;
	local v79, v80, v81, v82;
	local v83;
	v35.Eviscerate:RegisterDamageFormula(function()
		return v12:AttackPowerDamageMod() * v79 * (0.176 + 0) * (2.21 - 1) * ((v35.Nightstalker:IsAvailable() and v12:StealthUp(true, false) and (1027.08 - (834 + 192))) or (1 + 0)) * ((v35.DeeperStratagem:IsAvailable() and (1.05 + 0)) or (1 + 0)) * ((v35.DarkShadow:IsAvailable() and v12:BuffUp(v35.ShadowDanceBuff) and (1.3 - 0)) or (305 - (300 + 4))) * ((v12:BuffUp(v35.SymbolsofDeath) and (1.1 + 0)) or (2 - 1)) * ((v12:BuffUp(v35.FinalityEviscerateBuff) and (363.3 - (112 + 250))) or (1 + 0)) * ((2 - 1) + (v12:MasteryPct() / (58 + 42))) * (1 + 0 + (v12:VersatilityDmgPct() / (75 + 25))) * ((v13:DebuffUp(v35.FindWeaknessDebuff) and (1.5 + 0)) or (1 + 0));
	end);
	local function v84(v109, v110)
		if (not v74 or ((5588 - (1001 + 413)) > (9472 - 5224))) then
			local v161 = 882 - (244 + 638);
			while true do
				if ((v161 == (693 - (627 + 66))) or ((13664 - 9078) <= (684 - (512 + 90)))) then
					v74 = v109;
					v75 = v110 or (1906 - (1665 + 241));
					break;
				end
			end
		end
	end
	local function v85(v111)
		if (((4580 - (373 + 344)) == (1743 + 2120)) and not v76) then
			v76 = v111;
		end
	end
	local function v86()
		if (((v42 == "On Bosses not in Dungeons") and v12:IsInDungeonArea()) or ((75 + 207) <= (110 - 68))) then
			return false;
		elseif (((7799 - 3190) >= (1865 - (35 + 1064))) and (v42 ~= "Always") and not v13:IsInBossList()) then
			return false;
		else
			return true;
		end
	end
	local function v87()
		local v112 = 0 + 0;
		while true do
			if ((v112 == (0 - 0)) or ((5 + 1147) == (3724 - (298 + 938)))) then
				if (((4681 - (233 + 1026)) > (5016 - (636 + 1030))) and (v71 < (2 + 0))) then
					return false;
				elseif (((857 + 20) > (112 + 264)) and (v43 == "Always")) then
					return true;
				elseif (((v43 == "On Bosses") and v13:IsInBossList()) or ((211 + 2907) <= (2072 - (55 + 166)))) then
					return true;
				elseif ((v43 == "Auto") or ((32 + 133) >= (352 + 3140))) then
					if (((15081 - 11132) < (5153 - (36 + 261))) and (v12:InstanceDifficulty() == (27 - 11)) and (v13:NPCID() == (140335 - (34 + 1334)))) then
						return true;
					elseif ((v13:NPCID() == (64188 + 102781)) or (v13:NPCID() == (129734 + 37237)) or (v13:NPCID() == (168253 - (1035 + 248))) or ((4297 - (20 + 1)) < (1572 + 1444))) then
						return true;
					elseif (((5009 - (134 + 185)) > (5258 - (549 + 584))) and ((v13:NPCID() == (184148 - (314 + 371))) or (v13:NPCID() == (630534 - 446863)))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v88(v113, v114, v115, v116)
		local v117 = 968 - (478 + 490);
		local v118;
		local v119;
		local v120;
		while true do
			if ((v117 == (1 + 0)) or ((1222 - (786 + 386)) >= (2901 - 2005))) then
				for v187, v188 in v27(v116) do
					if (((v188:GUID() ~= v120) and v32.UnitIsCycleValid(v188, v119, -v188:DebuffRemains(v113)) and v114(v188)) or ((3093 - (1055 + 324)) >= (4298 - (1093 + 247)))) then
						v118, v119 = v188, v188:TimeToDie();
					end
				end
				if ((v118 and (v13:GUID() == v118:GUID())) or ((1325 + 166) < (68 + 576))) then
					v9.Press(v113);
				elseif (((2794 - 2090) < (3349 - 2362)) and v44) then
					local v208 = 0 - 0;
					while true do
						if (((9342 - 5624) > (679 + 1227)) and (v208 == (0 - 0))) then
							v118, v119 = nil, v115;
							for v229, v230 in v27(v70) do
								if (((v230:GUID() ~= v120) and v32.UnitIsCycleValid(v230, v119, -v230:DebuffRemains(v113)) and v114(v230)) or ((3301 - 2343) > (2741 + 894))) then
									v118, v119 = v230, v230:TimeToDie();
								end
							end
							v208 = 2 - 1;
						end
						if (((4189 - (364 + 324)) <= (12313 - 7821)) and (v208 == (2 - 1))) then
							if ((v118 and (v13:GUID() == v118:GUID())) or ((1141 + 2301) < (10661 - 8113))) then
								v9.Press(v113);
							end
							break;
						end
					end
				end
				break;
			end
			if (((4604 - 1729) >= (4446 - 2982)) and (v117 == (1268 - (1249 + 19)))) then
				v118, v119 = nil, v115;
				v120 = v13:GUID();
				v117 = 1 + 0;
			end
		end
	end
	local function v89()
		return (77 - 57) + (v35.Vigor:TalentRank() * (1111 - (686 + 400))) + (v25(v35.ThistleTea:IsAvailable()) * (16 + 4)) + (v25(v35.Shadowcraft:IsAvailable()) * (249 - (73 + 156)));
	end
	local function v90()
		return v35.ShadowDance:ChargesFractional() >= (0.75 + 0 + v18(v35.ShadowDanceTalent:IsAvailable()));
	end
	local function v91()
		return v81 >= (814 - (721 + 90));
	end
	local function v92()
		return v12:BuffUp(v35.SliceandDice) or (v71 >= v33.CPMaxSpend());
	end
	local function v93()
		return v35.Premeditation:IsAvailable() and (v71 < (1 + 4));
	end
	local function v94(v121)
		return (v12:BuffUp(v35.ThistleTea) and (v71 == (3 - 2))) or (v121 and ((v71 == (471 - (224 + 246))) or (v13:DebuffUp(v35.Rupture) and (v71 >= (2 - 0)))));
	end
	local function v95()
		return (not v12:BuffUp(v35.TheRotten) or not v12:HasTier(55 - 25, 1 + 1)) and (not v35.ColdBlood:IsAvailable() or (v35.ColdBlood:CooldownRemains() < (1 + 3)) or (v35.ColdBlood:CooldownRemains() > (8 + 2)));
	end
	local function v96(v122)
		return v12:BuffUp(v35.ShadowDanceBuff) and (v122:TimeSinceLastCast() < v35.ShadowDance:TimeSinceLastCast());
	end
	local function v97()
		return ((v96(v35.Shadowstrike) or v96(v35.ShurikenStorm)) and (v96(v35.Eviscerate) or v96(v35.BlackPowder) or v96(v35.Rupture))) or not v35.DanseMacabre:IsAvailable();
	end
	local function v98()
		return (not v36.WitherbarksBranch:IsEquipped() and not v36.AshesoftheEmbersoul:IsEquipped()) or (not v36.WitherbarksBranch:IsEquipped() and (v36.WitherbarksBranch:CooldownRemains() <= (15 - 7))) or (v36.WitherbarksBranch:IsEquipped() and (v36.WitherbarksBranch:CooldownRemains() <= (26 - 18))) or v36.BandolierOfTwistedBlades:IsEquipped() or v35.InvigoratingShadowdust:IsAvailable();
	end
	local function v99(v123, v124)
		local v125 = v12:BuffUp(v35.ShadowDanceBuff);
		local v126 = v12:BuffRemains(v35.ShadowDanceBuff);
		local v127 = v12:BuffRemains(v35.SymbolsofDeath);
		local v128 = v80;
		local v129 = v35.ColdBlood:CooldownRemains();
		local v130 = v35.SymbolsofDeath:CooldownRemains();
		local v131 = v12:BuffUp(v35.PremeditationBuff) or (v124 and v35.Premeditation:IsAvailable());
		if ((v124 and (v124:ID() == v35.ShadowDance:ID())) or ((5310 - (203 + 310)) >= (6886 - (1238 + 755)))) then
			local v162 = 0 + 0;
			while true do
				if (((1535 - (709 + 825)) == v162) or ((1015 - 464) > (3012 - 944))) then
					if (((2978 - (196 + 668)) > (3726 - 2782)) and v35.TheFirstDance:IsAvailable()) then
						v128 = v29(v12:ComboPointsMax(), v80 + (7 - 3));
					end
					if (v12:HasTier(863 - (171 + 662), 95 - (4 + 89)) or ((7928 - 5666) >= (1128 + 1968))) then
						v127 = v30(v127, 26 - 20);
					end
					break;
				end
				if ((v162 == (0 + 0)) or ((3741 - (35 + 1451)) >= (4990 - (28 + 1425)))) then
					v125 = true;
					v126 = (2001 - (941 + 1052)) + v35.ImprovedShadowDance:TalentRank();
					v162 = 1 + 0;
				end
			end
		end
		if ((v124 and (v124:ID() == v35.Vanish:ID())) or ((5351 - (822 + 692)) < (1863 - 557))) then
			local v163 = 0 + 0;
			while true do
				if (((3247 - (45 + 252)) == (2919 + 31)) and (v163 == (0 + 0))) then
					v129 = v29(0 - 0, v35.ColdBlood:CooldownRemains() - ((448 - (114 + 319)) * v35.InvigoratingShadowdust:TalentRank()));
					v130 = v29(0 - 0, v35.SymbolsofDeath:CooldownRemains() - ((19 - 4) * v35.InvigoratingShadowdust:TalentRank()));
					break;
				end
			end
		end
		if ((v35.Rupture:IsCastable() and v35.Rupture:IsReady()) or ((3011 + 1712) < (4913 - 1615))) then
			if (((2379 - 1243) >= (2117 - (556 + 1407))) and v13:DebuffDown(v35.Rupture) and (v13:TimeToDie() > (1212 - (741 + 465)))) then
				if (v123 or ((736 - (170 + 295)) > (2502 + 2246))) then
					return v35.Rupture;
				else
					if (((4354 + 386) >= (7760 - 4608)) and v35.Rupture:IsReady() and v19(v35.Rupture)) then
						return "Cast Rupture";
					end
					v85(v35.Rupture);
				end
			end
		end
		if ((not v12:StealthUp(true, true) and not v93() and (v71 < (5 + 1)) and not v125 and v9.BossFilteredFightRemains(">", v12:BuffRemains(v35.SliceandDice)) and (v12:BuffRemains(v35.SliceandDice) < ((1 + 0 + v12:ComboPoints()) * (1.8 + 0)))) or ((3808 - (957 + 273)) >= (907 + 2483))) then
			if (((17 + 24) <= (6329 - 4668)) and v123) then
				return v35.SliceandDice;
			else
				local v189 = 0 - 0;
				while true do
					if (((1835 - 1234) < (17627 - 14067)) and (v189 == (1780 - (389 + 1391)))) then
						if (((148 + 87) < (72 + 615)) and v35.SliceandDice:IsReady() and v19(v35.SliceandDice)) then
							return "Cast Slice and Dice Premed";
						end
						v85(v35.SliceandDice);
						break;
					end
				end
			end
		end
		if (((10356 - 5807) > (2104 - (783 + 168))) and (not v94(v125) or v83) and (v13:TimeToDie() > (19 - 13)) and v13:DebuffRefreshable(v35.Rupture, v77)) then
			if (v123 or ((4598 + 76) < (4983 - (309 + 2)))) then
				return v35.Rupture;
			else
				local v190 = 0 - 0;
				while true do
					if (((4880 - (1090 + 122)) < (1479 + 3082)) and (v190 == (0 - 0))) then
						if ((v35.Rupture:IsReady() and v19(v35.Rupture)) or ((312 + 143) == (4723 - (628 + 490)))) then
							return "Cast Rupture";
						end
						v85(v35.Rupture);
						break;
					end
				end
			end
		end
		if ((v12:BuffUp(v35.FinalityRuptureBuff) and v125 and (v71 <= (1 + 3)) and not v96(v35.Rupture)) or ((6593 - 3930) == (15135 - 11823))) then
			if (((5051 - (431 + 343)) <= (9037 - 4562)) and v123) then
				return v35.Rupture;
			else
				if ((v35.Rupture:IsReady() and v19(v35.Rupture)) or ((2516 - 1646) == (940 + 249))) then
					return "Cast Rupture Finality";
				end
				v85(v35.Rupture);
			end
		end
		if (((199 + 1354) <= (4828 - (556 + 1139))) and v35.ColdBlood:IsReady() and v97(v125, v131) and v35.SecretTechnique:IsReady()) then
			local v164 = 15 - (6 + 9);
			while true do
				if ((v164 == (0 + 0)) or ((1146 + 1091) >= (3680 - (28 + 141)))) then
					if (v123 or ((513 + 811) > (3727 - 707))) then
						return v35.ColdBlood;
					end
					if (v19(v35.ColdBlood) or ((2120 + 872) == (3198 - (486 + 831)))) then
						return "Cast Cold Blood (SecTec)";
					end
					break;
				end
			end
		end
		if (((8082 - 4976) > (5372 - 3846)) and v35.SecretTechnique:IsReady()) then
			if (((572 + 2451) < (12236 - 8366)) and v97(v125, v131) and (not v35.ColdBlood:IsAvailable() or v12:BuffUp(v35.ColdBlood) or (v129 > (v126 - (1265 - (668 + 595)))) or not v35.ImprovedShadowDance:IsAvailable())) then
				local v191 = 0 + 0;
				while true do
					if (((29 + 114) > (201 - 127)) and (v191 == (290 - (23 + 267)))) then
						if (((1962 - (1129 + 815)) < (2499 - (371 + 16))) and v123) then
							return v35.SecretTechnique;
						end
						if (((2847 - (1326 + 424)) <= (3083 - 1455)) and v19(v35.SecretTechnique)) then
							return "Cast Secret Technique";
						end
						break;
					end
				end
			end
		end
		if (((16919 - 12289) == (4748 - (88 + 30))) and not v94(v125) and v35.Rupture:IsCastable()) then
			if (((4311 - (720 + 51)) > (5968 - 3285)) and not v123 and v39 and not v83 and (v71 >= (1778 - (421 + 1355)))) then
				local v192 = 0 - 0;
				local v193;
				while true do
					if (((2355 + 2439) >= (4358 - (286 + 797))) and (v192 == (0 - 0))) then
						v193 = nil;
						function v193(v211)
							return v32.CanDoTUnit(v211, v78) and v211:DebuffRefreshable(v35.Rupture, v77);
						end
						v192 = 1 - 0;
					end
					if (((1923 - (397 + 42)) == (464 + 1020)) and (v192 == (801 - (24 + 776)))) then
						v88(v35.Rupture, v193, (2 - 0) * v128, v72);
						break;
					end
				end
			end
			if (((2217 - (222 + 563)) < (7832 - 4277)) and v67 and (v13:DebuffRemains(v35.Rupture) < (v130 + 8 + 2)) and (v130 <= (195 - (23 + 167))) and v33.CanDoTUnit(v13, v78) and v13:FilteredTimeToDie(">", (1803 - (690 + 1108)) + v130, -v13:DebuffRemains(v35.Rupture))) then
				if (v123 or ((385 + 680) > (2952 + 626))) then
					return v35.Rupture;
				else
					local v207 = 848 - (40 + 808);
					while true do
						if ((v207 == (0 + 0)) or ((18336 - 13541) < (1345 + 62))) then
							if (((981 + 872) < (2640 + 2173)) and v35.Rupture:IsReady() and v19(v35.Rupture)) then
								return "Cast Rupture 2";
							end
							v85(v35.Rupture);
							break;
						end
					end
				end
			end
		end
		if ((v35.BlackPowder:IsCastable() and not v83 and (v71 >= (574 - (47 + 524)))) or ((1831 + 990) < (6645 - 4214))) then
			if (v123 or ((4296 - 1422) < (4973 - 2792))) then
				return v35.BlackPowder;
			else
				local v194 = 1726 - (1165 + 561);
				while true do
					if (((0 + 0) == v194) or ((8328 - 5639) <= (131 + 212))) then
						if ((v35.BlackPowder:IsReady() and v19(v35.BlackPowder)) or ((2348 - (341 + 138)) == (543 + 1466))) then
							return "Cast Black Powder";
						end
						v85(v35.BlackPowder);
						break;
					end
				end
			end
		end
		if ((v35.Eviscerate:IsCastable() and v67) or ((7317 - 3771) < (2648 - (89 + 237)))) then
			if (v123 or ((6697 - 4615) == (10048 - 5275))) then
				return v35.Eviscerate;
			else
				local v195 = 881 - (581 + 300);
				while true do
					if (((4464 - (855 + 365)) > (2505 - 1450)) and (v195 == (0 + 0))) then
						if ((v35.Eviscerate:IsReady() and v19(v35.Eviscerate)) or ((4548 - (1030 + 205)) <= (1670 + 108))) then
							return "Cast Eviscerate";
						end
						v85(v35.Eviscerate);
						break;
					end
				end
			end
		end
		return false;
	end
	local function v100(v132, v133)
		local v134 = 0 + 0;
		local v135;
		local v136;
		local v137;
		local v138;
		local v139;
		local v140;
		local v141;
		local v142;
		local v143;
		local v144;
		while true do
			if ((v134 == (287 - (156 + 130))) or ((3228 - 1807) >= (3545 - 1441))) then
				v138, v139 = v80, v81;
				v140 = v12:BuffUp(v35.PremeditationBuff) or (v133 and v35.Premeditation:IsAvailable());
				v141 = v12:BuffUp(v33.StealthSpell()) or (v133 and (v133:ID() == v33.StealthSpell():ID()));
				v134 = 3 - 1;
			end
			if (((478 + 1334) <= (1895 + 1354)) and (v134 == (69 - (10 + 59)))) then
				v135 = v12:BuffUp(v35.ShadowDanceBuff);
				v136 = v12:BuffRemains(v35.ShadowDanceBuff);
				v137 = v12:BuffUp(v35.TheRottenBuff);
				v134 = 1 + 0;
			end
			if (((7992 - 6369) <= (3120 - (671 + 492))) and (v134 == (2 + 0))) then
				v142 = v12:BuffUp(v33.VanishBuffSpell()) or (v133 and (v133:ID() == v35.Vanish:ID()));
				if (((5627 - (369 + 846)) == (1169 + 3243)) and v133 and (v133:ID() == v35.ShadowDance:ID())) then
					local v196 = 0 + 0;
					while true do
						if (((3695 - (1036 + 909)) >= (670 + 172)) and (v196 == (1 - 0))) then
							if (((4575 - (11 + 192)) > (935 + 915)) and v35.TheRotten:IsAvailable() and v12:HasTier(205 - (135 + 40), 4 - 2)) then
								v137 = true;
							end
							if (((140 + 92) < (1808 - 987)) and v35.TheFirstDance:IsAvailable()) then
								local v215 = 0 - 0;
								while true do
									if (((694 - (50 + 126)) < (2511 - 1609)) and (v215 == (0 + 0))) then
										v138 = v29(v12:ComboPointsMax(), v80 + (1417 - (1233 + 180)));
										v139 = v12:ComboPointsMax() - v138;
										break;
									end
								end
							end
							break;
						end
						if (((3963 - (522 + 447)) > (2279 - (107 + 1314))) and (v196 == (0 + 0))) then
							v135 = true;
							v136 = (24 - 16) + v35.ImprovedShadowDance:TalentRank();
							v196 = 1 + 0;
						end
					end
				end
				v143 = v33.EffectiveComboPoints(v138);
				v134 = 5 - 2;
			end
			if ((v134 == (15 - 11)) or ((5665 - (716 + 1194)) <= (16 + 899))) then
				if (((423 + 3523) > (4246 - (74 + 429))) and (v143 >= v33.CPMaxSpend())) then
					return v99(v132, v133);
				end
				if ((v12:BuffUp(v35.ShurikenTornado) and (v139 <= (3 - 1))) or ((662 + 673) >= (7567 - 4261))) then
					return v99(v132, v133);
				end
				if (((3428 + 1416) > (6945 - 4692)) and (v81 <= ((2 - 1) + v25(v35.DeeperStratagem:IsAvailable() or v35.SecretStratagem:IsAvailable())))) then
					return v99(v132, v133);
				end
				v134 = 438 - (279 + 154);
			end
			if (((1230 - (454 + 324)) == (356 + 96)) and (v134 == (23 - (12 + 5)))) then
				if ((not v140 and (v71 >= (3 + 1))) or ((11611 - 7054) < (772 + 1315))) then
					if (((4967 - (277 + 816)) == (16553 - 12679)) and v132) then
						return v35.ShurikenStorm;
					elseif (v19(v35.ShurikenStorm) or ((3121 - (1058 + 125)) > (926 + 4009))) then
						return "Cast Shuriken Storm";
					end
				end
				if (v144 or ((5230 - (815 + 160)) < (14686 - 11263))) then
					if (((3451 - 1997) <= (595 + 1896)) and v132) then
						return v35.Shadowstrike;
					elseif (v19(v35.Shadowstrike) or ((12151 - 7994) <= (4701 - (41 + 1857)))) then
						return "Cast Shadowstrike";
					end
				end
				return false;
			end
			if (((6746 - (1222 + 671)) >= (7707 - 4725)) and (v134 == (6 - 1))) then
				if (((5316 - (229 + 953)) > (5131 - (1111 + 663))) and v35.Backstab:IsCastable() and not v140 and (v136 >= (1582 - (874 + 705))) and v12:BuffUp(v35.ShadowBlades) and not v96(v35.Backstab) and v35.DanseMacabre:IsAvailable() and (v71 <= (1 + 2)) and not v137) then
					if (v132 or ((2332 + 1085) < (5266 - 2732))) then
						if (v133 or ((77 + 2645) <= (843 - (642 + 37)))) then
							return v35.Backstab;
						else
							return {v35.Backstab,v35.Stealth};
						end
					elseif (v23(v35.Backstab, v35.Stealth) or ((6045 - 3637) < (2563 - (233 + 221)))) then
						return "Cast Backstab (Stealth)";
					end
				end
				if (v35.Gloomblade:IsAvailable() or ((76 - 43) == (1281 + 174))) then
					if ((not v140 and (v136 >= (1544 - (718 + 823))) and v12:BuffUp(v35.ShadowBlades) and not v96(v35.Gloomblade) and v35.DanseMacabre:IsAvailable() and (v71 <= (3 + 1))) or ((1248 - (266 + 539)) >= (11367 - 7352))) then
						if (((4607 - (636 + 589)) > (393 - 227)) and v132) then
							if (v133 or ((577 - 297) == (2425 + 634))) then
								return v35.Gloomblade;
							else
								return {v35.Gloomblade,v35.Stealth};
							end
						elseif (((4980 - 3099) > (2945 - 1652)) and v23(v35.Gloomblade, v35.Stealth)) then
							return "Cast Gloomblade (Danse)";
						end
					end
				end
				if (((3544 - (1151 + 36)) == (2277 + 80)) and not v96(v35.Shadowstrike) and v12:BuffUp(v35.ShadowBlades)) then
					if (((33 + 90) == (367 - 244)) and v132) then
						return v35.Shadowstrike;
					elseif (v19(v35.Shadowstrike) or ((2888 - (1552 + 280)) >= (4226 - (64 + 770)))) then
						return "Cast Shadowstrike (Danse)";
					end
				end
				v134 = 5 + 1;
			end
			if (((6 - 3) == v134) or ((192 + 889) < (2318 - (157 + 1086)))) then
				v144 = v35.Shadowstrike:IsCastable() or v141 or v142 or v135 or v12:BuffUp(v35.SepsisBuff);
				if (v141 or v142 or ((2099 - 1050) >= (19410 - 14978))) then
					v144 = v144 and v13:IsInRange(37 - 12);
				else
					v144 = v144 and v67;
				end
				if ((v144 and v141 and ((v71 < (5 - 1)) or v83)) or ((5587 - (599 + 220)) <= (1684 - 838))) then
					if (v132 or ((5289 - (1813 + 118)) <= (1038 + 382))) then
						return v35.Shadowstrike;
					elseif (v19(v35.Shadowstrike) or ((4956 - (841 + 376)) <= (4210 - 1205))) then
						return "Cast Shadowstrike (Stealth)";
					end
				end
				v134 = 1 + 3;
			end
		end
	end
	local function v101(v145, v146)
		local v147 = 0 - 0;
		local v148;
		local v149;
		while true do
			if ((v147 == (862 - (464 + 395))) or ((4257 - 2598) >= (1025 + 1109))) then
				return false;
			end
			if ((v147 == (837 - (467 + 370))) or ((6736 - 3476) < (1729 + 626))) then
				v148 = v100(true, v145);
				if (((v145:ID() == v35.Vanish:ID()) and (not v45 or not v148)) or ((2293 - 1624) == (659 + 3564))) then
					local v197 = 0 - 0;
					while true do
						if ((v197 == (520 - (150 + 370))) or ((2974 - (74 + 1208)) < (1446 - 858))) then
							if (v19(v35.Vanish, nil) or ((22750 - 17953) < (2598 + 1053))) then
								return "Cast Vanish";
							end
							return false;
						end
					end
				elseif (((v145:ID() == v35.Shadowmeld:ID()) and (not v46 or not v148)) or ((4567 - (14 + 376)) > (8412 - 3562))) then
					if (v19(v35.Shadowmeld, nil) or ((259 + 141) > (976 + 135))) then
						return "Cast Shadowmeld";
					end
					return false;
				elseif (((2910 + 141) > (2944 - 1939)) and (v145:ID() == v35.ShadowDance:ID()) and (not v47 or not v148)) then
					local v212 = 0 + 0;
					while true do
						if (((3771 - (23 + 55)) <= (10384 - 6002)) and (v212 == (0 + 0))) then
							if (v19(v35.ShadowDance, nil) or ((2948 + 334) > (6357 - 2257))) then
								return "Cast Shadow Dance";
							end
							return false;
						end
					end
				end
				v147 = 1 + 0;
			end
			if ((v147 == (903 - (652 + 249))) or ((9580 - 6000) < (4712 - (708 + 1160)))) then
				v73 = v23(unpack(v149));
				if (((241 - 152) < (8186 - 3696)) and v73) then
					return "| " .. v149[29 - (10 + 17)]:Name();
				end
				v147 = 1 + 2;
			end
			if ((v147 == (1733 - (1400 + 332))) or ((9557 - 4574) < (3716 - (242 + 1666)))) then
				v149 = {v145,v148};
				if (((3264 + 565) > (4709 - (850 + 90))) and v146 and (v12:EnergyPredicted() < v146)) then
					local v198 = 0 - 0;
					while true do
						if (((2875 - (360 + 1030)) <= (2570 + 334)) and ((0 - 0) == v198)) then
							v84(v149, v146);
							return false;
						end
					end
				end
				v147 = 2 - 0;
			end
		end
	end
	local function v102()
		if (((5930 - (909 + 752)) == (5492 - (109 + 1114))) and v40 and v35.ColdBlood:IsReady() and not v35.SecretTechnique:IsAvailable() and (v80 >= (9 - 4))) then
			if (((151 + 236) <= (3024 - (6 + 236))) and v19(v35.ColdBlood, nil)) then
				return "Cast Cold Blood";
			end
		end
		if ((v40 and v35.Sepsis:IsAvailable() and v35.Sepsis:IsReady()) or ((1197 + 702) <= (739 + 178))) then
			if ((v92() and v13:FilteredTimeToDie(">=", 37 - 21) and (v12:BuffUp(v35.PerforatedVeins) or not v35.PerforatedVeins:IsAvailable())) or ((7531 - 3219) <= (2009 - (1076 + 57)))) then
				if (((368 + 1864) <= (3285 - (579 + 110))) and v19(v35.Sepsis, nil, nil)) then
					return "Cast Sepsis";
				end
			end
		end
		if (((166 + 1929) < (3259 + 427)) and v40 and v35.Flagellation:IsAvailable() and v35.Flagellation:IsReady()) then
			if ((v92() and (v79 >= (3 + 2)) and (v13:TimeToDie() > (417 - (174 + 233))) and ((v98() and (v35.ShadowBlades:CooldownRemains() <= (8 - 5))) or v9.BossFilteredFightRemains("<=", 48 - 20) or ((v35.ShadowBlades:CooldownRemains() >= (7 + 7)) and v35.InvigoratingShadowdust:IsAvailable() and v35.ShadowDance:IsAvailable())) and (not v35.InvigoratingShadowdust:IsAvailable() or v35.Sepsis:IsAvailable() or not v35.ShadowDance:IsAvailable() or ((v35.InvigoratingShadowdust:TalentRank() == (1176 - (663 + 511))) and (v71 >= (2 + 0))) or (v35.SymbolsofDeath:CooldownRemains() <= (1 + 2)) or (v12:BuffRemains(v35.SymbolsofDeath) > (9 - 6)))) or ((966 + 629) >= (10533 - 6059))) then
				if (v19(v35.Flagellation, nil, nil) or ((11181 - 6562) < (1376 + 1506))) then
					return "Cast Flagellation";
				end
			end
		end
		if ((v40 and v35.SymbolsofDeath:IsReady()) or ((571 - 277) >= (3443 + 1388))) then
			if (((186 + 1843) <= (3806 - (478 + 244))) and v92() and (not v12:BuffUp(v35.TheRotten) or not v12:HasTier(547 - (440 + 77), 1 + 1)) and (v12:BuffRemains(v35.SymbolsofDeath) <= (10 - 7)) and (not v35.Flagellation:IsAvailable() or (v35.Flagellation:CooldownRemains() > (1566 - (655 + 901))) or ((v12:BuffRemains(v35.ShadowDance) >= (1 + 1)) and v35.InvigoratingShadowdust:IsAvailable()) or (v35.Flagellation:IsReady() and (v79 >= (4 + 1)) and not v35.InvigoratingShadowdust:IsAvailable()))) then
				if (v19(v35.SymbolsofDeath, nil) or ((1376 + 661) == (9749 - 7329))) then
					return "Cast Symbols of Death";
				end
			end
		end
		if (((5903 - (695 + 750)) > (13331 - 9427)) and v40 and v35.ShadowBlades:IsReady()) then
			if (((672 - 236) >= (494 - 371)) and v92() and ((v79 <= (352 - (285 + 66))) or v12:HasTier(71 - 40, 1314 - (682 + 628))) and (v12:BuffUp(v35.Flagellation) or v12:BuffUp(v35.FlagellationPersistBuff) or not v35.Flagellation:IsAvailable())) then
				if (((81 + 419) < (2115 - (176 + 123))) and v19(v35.ShadowBlades, nil)) then
					return "Cast Shadow Blades";
				end
			end
		end
		if (((1495 + 2079) == (2593 + 981)) and v40 and v35.EchoingReprimand:IsCastable() and v35.EchoingReprimand:IsAvailable()) then
			if (((490 - (239 + 30)) < (107 + 283)) and v92() and (v81 >= (3 + 0))) then
				if (v19(v35.EchoingReprimand, nil, nil) or ((3916 - 1703) <= (4433 - 3012))) then
					return "Cast Echoing Reprimand";
				end
			end
		end
		if (((3373 - (306 + 9)) < (16959 - 12099)) and v40 and v35.ShurikenTornado:IsAvailable() and v35.ShurikenTornado:IsReady()) then
			if ((v92() and v12:BuffUp(v35.SymbolsofDeath) and (v79 <= (1 + 1)) and not v12:BuffUp(v35.Premeditation) and (not v35.Flagellation:IsAvailable() or (v35.Flagellation:CooldownRemains() > (13 + 7))) and (v71 >= (2 + 1))) or ((3705 - 2409) >= (5821 - (1140 + 235)))) then
				if (v19(v35.ShurikenTornado, nil) or ((887 + 506) > (4117 + 372))) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if ((v40 and v35.ShurikenTornado:IsAvailable() and v35.ShurikenTornado:IsReady()) or ((1136 + 3288) < (79 - (33 + 19)))) then
			if ((v92() and not v12:BuffUp(v35.ShadowDance) and not v12:BuffUp(v35.Flagellation) and not v12:BuffUp(v35.FlagellationPersistBuff) and not v12:BuffUp(v35.ShadowBlades) and (v71 <= (1 + 1))) or ((5985 - 3988) > (1681 + 2134))) then
				if (((6794 - 3329) > (1794 + 119)) and v19(v35.ShurikenTornado, nil)) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if (((1422 - (586 + 103)) < (166 + 1653)) and v40 and v35.ShadowDance:IsAvailable() and v86() and v35.ShadowDance:IsReady()) then
			if ((not v12:BuffUp(v35.ShadowDance) and v9.BossFilteredFightRemains("<=", (24 - 16) + ((1491 - (1309 + 179)) * v25(v35.Subterfuge:IsAvailable())))) or ((7934 - 3539) == (2070 + 2685))) then
				if (v19(v35.ShadowDance) or ((10186 - 6393) < (1790 + 579))) then
					return "Cast Shadow Dance";
				end
			end
		end
		if ((v40 and v35.GoremawsBite:IsAvailable() and v35.GoremawsBite:IsReady()) or ((8676 - 4592) == (528 - 263))) then
			if (((4967 - (295 + 314)) == (10703 - 6345)) and v92() and (v81 >= (1965 - (1300 + 662))) and (not v35.ShadowDance:IsReady() or (v35.ShadowDance:IsAvailable() and v12:BuffUp(v35.ShadowDance) and not v35.InvigoratingShadowdust:IsAvailable()) or ((v71 < (12 - 8)) and not v35.InvigoratingShadowdust:IsAvailable()) or v35.TheRotten:IsAvailable())) then
				if (v19(v35.GoremawsBite) or ((4893 - (1178 + 577)) < (516 + 477))) then
					return "Cast Goremaw's Bite";
				end
			end
		end
		if (((9844 - 6514) > (3728 - (851 + 554))) and v35.ThistleTea:IsReady()) then
			if ((((v35.SymbolsofDeath:CooldownRemains() >= (3 + 0)) or v12:BuffUp(v35.SymbolsofDeath)) and not v12:BuffUp(v35.ThistleTea) and (((v12:EnergyDeficitPredicted() >= (277 - 177)) and ((v81 >= (3 - 1)) or (v71 >= (305 - (115 + 187))))) or ((v35.ThistleTea:ChargesFractional() >= ((2.75 + 0) - ((0.15 + 0) * v35.InvigoratingShadowdust:TalentRank()))) and v35.Vanish:IsReady() and v12:BuffUp(v35.ShadowDance) and v13:DebuffUp(v35.Rupture) and (v71 < (11 - 8))))) or ((v12:BuffRemains(v35.ShadowDance) >= (1165 - (160 + 1001))) and not v12:BuffUp(v35.ThistleTea) and (v71 >= (3 + 0))) or (not v12:BuffUp(v35.ThistleTea) and v9.BossFilteredFightRemains("<=", (5 + 1) * v35.ThistleTea:Charges())) or ((7422 - 3796) == (4347 - (237 + 121)))) then
				if (v19(v35.ThistleTea, nil, nil) or ((1813 - (525 + 372)) == (5063 - 2392))) then
					return "Thistle Tea";
				end
			end
		end
		local v150 = v32.HandleDPSPotion(v9.BossFilteredFightRemains("<", 98 - 68) or (v12:BuffUp(v35.SymbolsofDeath) and (v12:BuffUp(v35.ShadowBlades) or (v35.ShadowBlades:CooldownRemains() <= (152 - (96 + 46))))));
		if (((1049 - (643 + 134)) == (99 + 173)) and v150) then
			return v150;
		end
		local v151 = v12:BuffUp(v35.ShadowBlades) or (not v35.ShadowBlades:IsAvailable() and v12:BuffUp(v35.SymbolsofDeath)) or v9.BossFilteredFightRemains("<", 47 - 27);
		if (((15775 - 11526) <= (4641 + 198)) and v35.BloodFury:IsCastable() and v151 and v50) then
			if (((5449 - 2672) < (6541 - 3341)) and v19(v35.BloodFury, nil)) then
				return "Cast Blood Fury";
			end
		end
		if (((814 - (316 + 403)) < (1301 + 656)) and v35.Berserking:IsCastable() and v151 and v50) then
			if (((2270 - 1444) < (621 + 1096)) and v19(v35.Berserking, nil)) then
				return "Cast Berserking";
			end
		end
		if (((3591 - 2165) >= (784 + 321)) and v35.Fireblood:IsCastable() and v151 and v50) then
			if (((888 + 1866) <= (11707 - 8328)) and v19(v35.Fireblood, nil)) then
				return "Cast Fireblood";
			end
		end
		if ((v35.AncestralCall:IsCastable() and v151 and v50) or ((18754 - 14827) == (2935 - 1522))) then
			if (v19(v35.AncestralCall, nil) or ((67 + 1087) <= (1550 - 762))) then
				return "Cast Ancestral Call";
			end
		end
		local v152 = v32.HandleTopTrinket(v64, v40, 2 + 38, nil);
		if (v152 or ((4833 - 3190) > (3396 - (12 + 5)))) then
			return v152;
		end
		local v152 = v32.HandleBottomTrinket(v64, v40, 155 - 115, nil);
		if (v152 or ((5979 - 3176) > (9669 - 5120))) then
			return v152;
		end
		if (v35.ThistleTea:IsReady() or ((545 - 325) >= (614 + 2408))) then
			if (((4795 - (1656 + 317)) == (2515 + 307)) and ((((v35.SymbolsofDeath:CooldownRemains() >= (3 + 0)) or v12:BuffUp(v35.SymbolsofDeath)) and not v12:BuffUp(v35.ThistleTea) and (((v12:EnergyDeficitPredicted() >= (265 - 165)) and ((v12:ComboPointsDeficit() >= (9 - 7)) or (v71 >= (357 - (5 + 349))))) or ((v35.ThistleTea:ChargesFractional() >= (9.75 - 7)) and v12:BuffUp(v35.ShadowDanceBuff)))) or ((v12:BuffRemains(v35.ShadowDanceBuff) >= (1275 - (266 + 1005))) and not v12:BuffUp(v35.ThistleTea) and (v71 >= (2 + 1))) or (not v12:BuffUp(v35.ThistleTea) and v9.BossFilteredFightRemains("<=", (20 - 14) * v35.ThistleTea:Charges())))) then
				if (v19(v35.ThistleTea, nil, nil) or ((1396 - 335) == (3553 - (561 + 1135)))) then
					return "Thistle Tea";
				end
			end
		end
		return false;
	end
	local function v103(v153)
		local v154 = 0 - 0;
		while true do
			if (((9072 - 6312) > (2430 - (507 + 559))) and (v154 == (2 - 1))) then
				return false;
			end
			if ((v154 == (0 - 0)) or ((5290 - (212 + 176)) <= (4500 - (250 + 655)))) then
				if ((v40 and not (v32.IsSoloMode() and v12:IsTanking(v13))) or ((10503 - 6651) == (511 - 218))) then
					if (v35.Vanish:IsCastable() or ((2438 - 879) == (6544 - (1869 + 87)))) then
						if ((((v81 > (3 - 2)) or (v12:BuffUp(v35.ShadowBlades) and v35.InvigoratingShadowdust:IsAvailable())) and not v90() and ((v35.Flagellation:CooldownRemains() >= (1961 - (484 + 1417))) or not v35.Flagellation:IsAvailable() or v9.BossFilteredFightRemains("<=", (64 - 34) * v35.Vanish:Charges())) and ((v35.SymbolsofDeath:CooldownRemains() > (4 - 1)) or not v12:HasTier(803 - (48 + 725), 2 - 0)) and ((v35.SecretTechnique:CooldownRemains() >= (26 - 16)) or not v35.SecretTechnique:IsAvailable() or ((v35.Vanish:Charges() >= (2 + 0)) and v35.InvigoratingShadowdust:IsAvailable() and (v12:BuffUp(v35.TheRotten) or not v35.TheRotten:IsAvailable())))) or ((11982 - 7498) == (221 + 567))) then
							local v213 = 0 + 0;
							while true do
								if (((5421 - (152 + 701)) >= (5218 - (430 + 881))) and (v213 == (0 + 0))) then
									v73 = v101(v35.Vanish, v153);
									if (((2141 - (557 + 338)) < (1026 + 2444)) and v73) then
										return "Vanish Macro " .. v73;
									end
									break;
								end
							end
						end
					end
					if (((11463 - 7395) >= (3403 - 2431)) and v50 and v48 and (v12:Energy() < (106 - 66)) and v35.Shadowmeld:IsCastable()) then
						if (((1062 - 569) < (4694 - (499 + 302))) and v22(v35.Shadowmeld, v12:EnergyTimeToX(906 - (39 + 827)))) then
							return "Pool for Shadowmeld";
						end
					end
					if ((v50 and v35.Shadowmeld:IsCastable() and v67 and not v12:IsMoving() and (v12:EnergyPredicted() >= (110 - 70)) and (v12:EnergyDeficitPredicted() >= (22 - 12)) and not v90() and (v81 > (15 - 11))) or ((2260 - 787) >= (286 + 3046))) then
						local v209 = 0 - 0;
						while true do
							if ((v209 == (0 + 0)) or ((6409 - 2358) <= (1261 - (103 + 1)))) then
								v73 = v101(v35.Shadowmeld, v153);
								if (((1158 - (475 + 79)) < (6228 - 3347)) and v73) then
									return "Shadowmeld Macro " .. v73;
								end
								break;
							end
						end
					end
				end
				if ((v67 and v35.ShadowDance:IsCastable()) or ((2880 - 1980) == (437 + 2940))) then
					if (((3925 + 534) > (2094 - (1395 + 108))) and (v13:DebuffUp(v35.Rupture) or v35.InvigoratingShadowdust:IsAvailable()) and v95() and (not v35.TheFirstDance:IsAvailable() or (v81 >= (11 - 7)) or v12:BuffUp(v35.ShadowBlades)) and ((v91() and v90()) or ((v12:BuffUp(v35.ShadowBlades) or (v12:BuffUp(v35.SymbolsofDeath) and not v35.Sepsis:IsAvailable()) or ((v12:BuffRemains(v35.SymbolsofDeath) >= (1208 - (7 + 1197))) and not v12:HasTier(14 + 16, 1 + 1)) or (not v12:BuffUp(v35.SymbolsofDeath) and v12:HasTier(349 - (27 + 292), 5 - 3))) and (v35.SecretTechnique:CooldownRemains() < ((12 - 2) + ((50 - 38) * v25(not v35.InvigoratingShadowdust:IsAvailable() or v12:HasTier(59 - 29, 3 - 1)))))))) then
						v73 = v101(v35.ShadowDance, v153);
						if (((3537 - (43 + 96)) >= (9769 - 7374)) and v73) then
							return "ShadowDance Macro 1 " .. v73;
						end
					end
				end
				v154 = 1 - 0;
			end
		end
	end
	local function v104(v155)
		local v156 = 0 + 0;
		local v157;
		while true do
			if ((v156 == (0 + 0)) or ((4314 - 2131) >= (1083 + 1741))) then
				v157 = not v155 or (v12:EnergyPredicted() >= v155);
				if (((3627 - 1691) == (610 + 1326)) and v39 and v35.ShurikenStorm:IsCastable() and (v71 >= (1 + 1 + v18((v35.Gloomblade:IsAvailable() and (v12:BuffRemains(v35.LingeringShadowBuff) >= (1757 - (1414 + 337)))) or v12:BuffUp(v35.PerforatedVeinsBuff))))) then
					local v199 = 1940 - (1642 + 298);
					while true do
						if ((v199 == (0 - 0)) or ((13900 - 9068) < (12798 - 8485))) then
							if (((1346 + 2742) > (3015 + 859)) and v157 and v19(v35.ShurikenStorm)) then
								return "Cast Shuriken Storm";
							end
							v84(v35.ShurikenStorm, v155);
							break;
						end
					end
				end
				v156 = 973 - (357 + 615);
			end
			if (((3041 + 1291) == (10629 - 6297)) and (v156 == (1 + 0))) then
				if (((8569 - 4570) >= (2320 + 580)) and v67) then
					if (v35.Gloomblade:IsCastable() or ((172 + 2353) > (2555 + 1509))) then
						local v210 = 1301 - (384 + 917);
						while true do
							if (((5068 - (128 + 569)) == (5914 - (1407 + 136))) and (v210 == (1887 - (687 + 1200)))) then
								if ((v157 and v19(v35.Gloomblade)) or ((1976 - (556 + 1154)) > (17540 - 12554))) then
									return "Cast Gloomblade";
								end
								v84(v35.Gloomblade, v155);
								break;
							end
						end
					elseif (((2086 - (9 + 86)) >= (1346 - (275 + 146))) and v35.Backstab:IsCastable()) then
						local v214 = 0 + 0;
						while true do
							if (((519 - (29 + 35)) < (9098 - 7045)) and (v214 == (0 - 0))) then
								if ((v157 and v19(v35.Backstab)) or ((3646 - 2820) == (3160 + 1691))) then
									return "Cast Backstab";
								end
								v84(v35.Backstab, v155);
								break;
							end
						end
					end
				end
				return false;
			end
		end
	end
	local v105 = {{v35.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v35.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v80 > (0 + 0);
	end},{v35.CheapShot,"Cast Cheap Shot (Interrupt)",function()
		return v12:StealthUp(true, true);
	end}};
	local function v106()
		local v158 = 1240 - (988 + 252);
		while true do
			if (((21 + 162) == (58 + 125)) and (v158 == (1974 - (49 + 1921)))) then
				v58 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v59 = EpicSettings.Settings['InterruptThreshold'];
				v60 = EpicSettings.Settings['AutoFocusTank'];
				v61 = EpicSettings.Settings['AutoTricksTank'];
				v158 = 895 - (223 + 667);
			end
			if (((1211 - (51 + 1)) <= (3077 - 1289)) and (v158 == (6 - 3))) then
				v54 = EpicSettings.Settings['DispelBuffs'];
				v55 = EpicSettings.Settings['UseHealthstone'];
				v56 = EpicSettings.Settings['HealthstoneHP'] or (1126 - (146 + 979));
				v57 = EpicSettings.Settings['InterruptWithStun'];
				v158 = 2 + 2;
			end
			if ((v158 == (610 - (311 + 294))) or ((9779 - 6272) > (1830 + 2488))) then
				v62 = EpicSettings.Settings['UsageStealthOOC'];
				v63 = EpicSettings.Settings['StealthRange'] or (1443 - (496 + 947));
				break;
			end
			if ((v158 == (1360 - (1233 + 125))) or ((1248 + 1827) <= (2661 + 304))) then
				v50 = EpicSettings.Settings['UseRacials'];
				v51 = EpicSettings.Settings['UseHealingPotion'];
				v52 = EpicSettings.Settings['HealingPotionName'];
				v53 = EpicSettings.Settings['HealingPotionHP'] or (1 + 0);
				v158 = 1648 - (963 + 682);
			end
			if (((1140 + 225) <= (3515 - (504 + 1000))) and ((1 + 0) == v158)) then
				v46 = EpicSettings.Settings['StealthMacroShadowmeld'];
				v47 = EpicSettings.Settings['StealthMacroShadowDance'];
				v48 = EpicSettings.Settings['PoolForShadowmeld'];
				v49 = EpicSettings.Settings['EviscerateDMGOffset'] or (1 + 0);
				v158 = 1 + 1;
			end
			if ((v158 == (0 - 0)) or ((2372 + 404) > (2080 + 1495))) then
				v42 = EpicSettings.Settings['BurnShadowDance'];
				v43 = EpicSettings.Settings['UsePriorityRotation'];
				v44 = EpicSettings.Settings['RangedMultiDoT'];
				v45 = EpicSettings.Settings['StealthMacroVanish'];
				v158 = 183 - (156 + 26);
			end
		end
	end
	local function v107()
		local v159 = 0 + 0;
		while true do
			if ((v159 == (1 - 0)) or ((2718 - (149 + 15)) == (5764 - (890 + 70)))) then
				v41 = EpicSettings.Toggles['dispel'];
				v74 = nil;
				v76 = nil;
				v75 = 117 - (39 + 78);
				v159 = 484 - (14 + 468);
			end
			if (((5666 - 3089) == (7202 - 4625)) and (v159 == (4 + 3))) then
				if ((not v12:AffectingCombat() and v38) or ((4 + 2) >= (402 + 1487))) then
					local v200 = 0 + 0;
					while true do
						if (((133 + 373) <= (3621 - 1729)) and (v200 == (1 + 0))) then
							if ((v32.TargetIsValid() and (v13:IsSpellInRange(v35.Shadowstrike) or v67)) or ((7055 - 5047) > (56 + 2162))) then
								if (((430 - (12 + 39)) <= (3859 + 288)) and v12:StealthUp(true, true)) then
									local v231 = 0 - 0;
									while true do
										if ((v231 == (0 - 0)) or ((1339 + 3175) <= (532 + 477))) then
											v74 = v100(true);
											if (v74 or ((8864 - 5368) == (794 + 398))) then
												if (((type(v74) == "table") and (#v74 > (4 - 3))) or ((1918 - (1596 + 114)) == (7725 - 4766))) then
													if (((4990 - (164 + 549)) >= (2751 - (1059 + 379))) and v24(nil, unpack(v74))) then
														return "Stealthed Macro Cast or Pool (OOC): " .. v74[1 - 0]:Name();
													end
												elseif (((1341 + 1246) < (536 + 2638)) and v22(v74)) then
													return "Stealthed Cast or Pool (OOC): " .. v74:Name();
												end
											end
											break;
										end
									end
								elseif ((v80 >= (397 - (145 + 247))) or ((3381 + 739) <= (1016 + 1182))) then
									local v232 = 0 - 0;
									while true do
										if ((v232 == (0 + 0)) or ((1375 + 221) == (1392 - 534))) then
											v73 = v99();
											if (((3940 - (254 + 466)) == (3780 - (544 + 16))) and v73) then
												return v73 .. " (OOC)";
											end
											break;
										end
									end
								elseif (v35.Backstab:IsCastable() or ((4455 - 3053) > (4248 - (294 + 334)))) then
									if (((2827 - (236 + 17)) == (1110 + 1464)) and v19(v35.Backstab)) then
										return "Cast Backstab (OOC)";
									end
								end
							end
							return;
						end
						if (((1400 + 398) < (10383 - 7626)) and (v200 == (0 - 0))) then
							if ((v35.Stealth:IsCastable() and (v62 == "Always")) or ((195 + 182) > (2145 + 459))) then
								local v216 = 794 - (413 + 381);
								while true do
									if (((24 + 544) < (1937 - 1026)) and (v216 == (0 - 0))) then
										v73 = v33.Stealth(v33.StealthSpell());
										if (((5255 - (582 + 1388)) < (7203 - 2975)) and v73) then
											return v73;
										end
										break;
									end
								end
							elseif (((2804 + 1112) > (3692 - (326 + 38))) and v35.Stealth:IsCastable() and (v62 == "Distance") and v13:IsInRange(v63)) then
								v73 = v33.Stealth(v33.StealthSpell());
								if (((7395 - 4895) < (5479 - 1640)) and v73) then
									return v73;
								end
							end
							if (((1127 - (47 + 573)) == (179 + 328)) and not v12:BuffUp(v35.ShadowDanceBuff) and not v12:BuffUp(v33.VanishBuffSpell())) then
								v73 = v33.Stealth(v33.StealthSpell());
								if (((1019 - 779) <= (5136 - 1971)) and v73) then
									return v73;
								end
							end
							v200 = 1665 - (1269 + 395);
						end
					end
				end
				if (((1326 - (76 + 416)) >= (1248 - (319 + 124))) and v32.TargetIsValid()) then
					local v201 = 0 - 0;
					local v202;
					while true do
						if ((v201 == (1009 - (564 + 443))) or ((10552 - 6740) < (2774 - (337 + 121)))) then
							v202 = nil;
							if (not v35.Vigor:IsAvailable() or v35.Shadowcraft:IsAvailable() or ((7770 - 5118) <= (5106 - 3573))) then
								v202 = v12:EnergyDeficitPredicted() <= v89();
							else
								v202 = v12:EnergyPredicted() >= v89();
							end
							if (v202 or v35.InvigoratingShadowdust:IsAvailable() or ((5509 - (1261 + 650)) < (618 + 842))) then
								local v217 = 0 - 0;
								while true do
									if ((v217 == (1817 - (772 + 1045))) or ((581 + 3535) < (1336 - (102 + 42)))) then
										v73 = v103(v82);
										if (v73 or ((5221 - (1524 + 320)) <= (2173 - (1049 + 221)))) then
											return "Stealth CDs: " .. v73;
										end
										break;
									end
								end
							end
							if (((4132 - (18 + 138)) >= (1074 - 635)) and (v79 >= v33.CPMaxSpend())) then
								local v218 = 1102 - (67 + 1035);
								while true do
									if (((4100 - (136 + 212)) == (15943 - 12191)) and (v218 == (0 + 0))) then
										v73 = v99();
										if (((3730 + 316) > (4299 - (240 + 1364))) and v73) then
											return "Finish: " .. v73;
										end
										break;
									end
								end
							end
							v201 = 1085 - (1050 + 32);
						end
						if ((v201 == (0 - 0)) or ((2097 + 1448) == (4252 - (331 + 724)))) then
							if (((194 + 2200) > (1017 - (269 + 375))) and not v12:IsCasting() and not v12:IsChanneling()) then
								local v219 = 725 - (267 + 458);
								local v220;
								while true do
									if (((1293 + 2862) <= (8137 - 3905)) and (v219 == (819 - (667 + 151)))) then
										if (v220 or ((5078 - (1410 + 87)) == (5370 - (1504 + 393)))) then
											return v220;
										end
										v220 = v32.Interrupt(v35.Blind, 40 - 25, BlindInterrupt);
										if (((12958 - 7963) > (4144 - (461 + 335))) and v220) then
											return v220;
										end
										v219 = 1 + 1;
									end
									if ((v219 == (1764 - (1730 + 31))) or ((2421 - (728 + 939)) > (13189 - 9465))) then
										if (((440 - 223) >= (130 - 73)) and v220) then
											return v220;
										end
										v220 = v32.InterruptWithStun(v35.KidneyShot, 1076 - (138 + 930), v12:ComboPoints() > (0 + 0));
										if (v220 or ((1619 + 451) >= (3460 + 577))) then
											return v220;
										end
										break;
									end
									if (((11045 - 8340) == (4471 - (459 + 1307))) and (v219 == (1870 - (474 + 1396)))) then
										v220 = v32.Interrupt(v35.Kick, 13 - 5, true);
										if (((58 + 3) == (1 + 60)) and v220) then
											return v220;
										end
										v220 = v32.Interrupt(v35.Kick, 22 - 14, true, MouseOver, v37.KickMouseover);
										v219 = 1 + 0;
									end
									if ((v219 == (6 - 4)) or ((3048 - 2349) >= (1887 - (562 + 29)))) then
										v220 = v32.Interrupt(v35.Blind, 13 + 2, BlindInterrupt, MouseOver, v37.BlindMouseover);
										if (v220 or ((3202 - (374 + 1045)) >= (2862 + 754))) then
											return v220;
										end
										v220 = v32.InterruptWithStun(v35.CheapShot, 24 - 16, v12:StealthUp(false, false));
										v219 = 641 - (448 + 190);
									end
								end
							end
							if ((v54 and v41 and v35.Shiv:IsReady() and not v12:IsCasting() and not v12:IsChanneling() and v32.UnitHasEnrageBuff(v13)) or ((1264 + 2649) > (2044 + 2483))) then
								if (((2852 + 1524) > (3141 - 2324)) and v20(v35.Shiv, not v67)) then
									return "shiv dispel enrage";
								end
							end
							if (((15104 - 10243) > (2318 - (1307 + 187))) and v36.Healthstone:IsReady() and v55 and (v12:HealthPercentage() <= v56)) then
								if (v20(v37.Healthstone, nil, nil, true) or ((5484 - 4101) >= (4989 - 2858))) then
									return "healthstone defensive 3";
								end
							end
							if ((v51 and (v12:HealthPercentage() <= v53)) or ((5752 - 3876) >= (3224 - (232 + 451)))) then
								local v221 = 0 + 0;
								while true do
									if (((1575 + 207) <= (4336 - (510 + 54))) and (v221 == (0 - 0))) then
										if ((v52 == "Refreshing Healing Potion") or ((4736 - (13 + 23)) < (1584 - 771))) then
											if (((4596 - 1397) < (7358 - 3308)) and v36.RefreshingHealingPotion:IsReady()) then
												if (v20(v37.RefreshingHealingPotion, nil, nil, true) or ((6039 - (830 + 258)) < (15627 - 11197))) then
													return "refreshing healing potion defensive 4";
												end
											end
										end
										if (((61 + 35) == (82 + 14)) and (v52 == "Dreamwalker's Healing Potion")) then
											if (v36.DreamwalkersHealingPotion:IsReady() or ((4180 - (860 + 581)) > (14783 - 10775))) then
												if (v20(v37.RefreshingHealingPotion, nil, nil, true) or ((19 + 4) == (1375 - (237 + 4)))) then
													return "dreamwalker's healing potion defensive 4";
												end
											end
										end
										break;
									end
								end
							end
							v201 = 2 - 1;
						end
						if ((v201 == (2 - 1)) or ((5105 - 2412) >= (3365 + 746))) then
							v73 = v102();
							if (v73 or ((2479 + 1837) <= (8101 - 5955))) then
								return "CDs: " .. v73;
							end
							if ((v35.SliceandDice:IsCastable() and (v71 < v33.CPMaxSpend()) and (v12:BuffRemains(v35.SliceandDice) < v12:GCD()) and v9.BossFilteredFightRemains(">", 3 + 3) and (v80 >= (3 + 1))) or ((4972 - (85 + 1341)) <= (4792 - 1983))) then
								local v222 = 0 - 0;
								while true do
									if (((5276 - (45 + 327)) > (4086 - 1920)) and (v222 == (502 - (444 + 58)))) then
										if (((48 + 61) >= (16 + 74)) and v35.SliceandDice:IsReady() and v19(v35.SliceandDice)) then
											return "Cast Slice and Dice (Low Duration)";
										end
										v85(v35.SliceandDice);
										break;
									end
								end
							end
							if (((2434 + 2544) > (8418 - 5513)) and v12:StealthUp(true, true)) then
								local v223 = 1732 - (64 + 1668);
								while true do
									if ((v223 == (1973 - (1227 + 746))) or ((9300 - 6274) <= (4231 - 1951))) then
										v74 = v100(true);
										if (v74 or ((2147 - (415 + 79)) <= (29 + 1079))) then
											if (((3400 - (142 + 349)) > (1118 + 1491)) and (type(v74) == "table") and (#v74 > (1 - 0))) then
												if (((377 + 380) > (137 + 57)) and v24(nil, unpack(v74))) then
													return "Stealthed Macro " .. v74[2 - 1]:Name() .. "|" .. v74[1866 - (1710 + 154)]:Name();
												end
											elseif ((v12:BuffUp(v35.ShurikenTornado) and (v80 ~= v12:ComboPoints()) and ((v74 == v35.BlackPowder) or (v74 == v35.Eviscerate) or (v74 == v35.Rupture) or (v74 == v35.SliceandDice))) or ((349 - (200 + 118)) >= (554 + 844))) then
												if (((5587 - 2391) <= (7225 - 2353)) and v24(nil, v35.ShurikenTornado, v74)) then
													return "Stealthed Tornado Cast  " .. v74:Name();
												end
											elseif (((2956 + 370) == (3290 + 36)) and (type(v74) ~= "boolean")) then
												if (((770 + 663) <= (620 + 3258)) and v22(v74)) then
													return "Stealthed Cast " .. v74:Name();
												end
											end
										end
										v223 = 2 - 1;
									end
									if ((v223 == (1251 - (363 + 887))) or ((2764 - 1181) == (8258 - 6523))) then
										v19(v35.PoolEnergy);
										return "Stealthed Pooling";
									end
								end
							end
							v201 = 1 + 1;
						end
						if ((v201 == (6 - 3)) or ((2037 + 944) == (4014 - (674 + 990)))) then
							if ((v81 <= (1 + 0)) or (v9.BossFilteredFightRemains("<=", 1 + 0) and (v79 >= (3 - 0))) or ((5521 - (507 + 548)) <= (1330 - (289 + 548)))) then
								local v224 = 1818 - (821 + 997);
								while true do
									if ((v224 == (255 - (195 + 60))) or ((685 + 1862) <= (3488 - (251 + 1250)))) then
										v73 = v99();
										if (((8674 - 5713) > (1883 + 857)) and v73) then
											return "Finish: " .. v73;
										end
										break;
									end
								end
							end
							if (((4728 - (809 + 223)) >= (5270 - 1658)) and (v71 >= (11 - 7)) and (v79 >= (13 - 9))) then
								local v225 = 0 + 0;
								while true do
									if ((v225 == (0 + 0)) or ((3587 - (14 + 603)) == (2007 - (118 + 11)))) then
										v73 = v99();
										if (v73 or ((598 + 3095) < (1647 + 330))) then
											return "Finish: " .. v73;
										end
										break;
									end
								end
							end
							if (v76 or ((2710 - 1780) > (3050 - (551 + 398)))) then
								v84(v76);
							end
							v73 = v104(v82);
							v201 = 3 + 1;
						end
						if (((1478 + 2675) > (2508 + 578)) and (v201 == (14 - 10))) then
							if (v73 or ((10723 - 6069) <= (1313 + 2737))) then
								return "Build: " .. v73;
							end
							if (v40 or ((10329 - 7727) < (414 + 1082))) then
								local v226 = 89 - (40 + 49);
								while true do
									if ((v226 == (3 - 2)) or ((1510 - (99 + 391)) > (1893 + 395))) then
										if (((1441 - 1113) == (812 - 484)) and v35.BagofTricks:IsReady() and v50) then
											if (((1472 + 39) < (10019 - 6211)) and v19(v35.BagofTricks, nil)) then
												return "Cast Bag of Tricks";
											end
										end
										break;
									end
									if (((1604 - (1032 + 572)) == v226) or ((2927 - (203 + 214)) > (6736 - (568 + 1249)))) then
										if (((3727 + 1036) == (11439 - 6676)) and v35.ArcaneTorrent:IsReady() and v67 and (v12:EnergyDeficitPredicted() >= ((57 - 42) + v12:EnergyRegen())) and v50) then
											if (((5443 - (913 + 393)) > (5218 - 3370)) and v19(v35.ArcaneTorrent, nil)) then
												return "Cast Arcane Torrent";
											end
										end
										if (((3441 - 1005) <= (3544 - (269 + 141))) and v35.ArcanePulse:IsReady() and v67 and v50) then
											if (((8280 - 4557) == (5704 - (362 + 1619))) and v19(v35.ArcanePulse, nil)) then
												return "Cast Arcane Pulse";
											end
										end
										v226 = 1626 - (950 + 675);
									end
								end
							end
							if ((v74 and v67) or ((1560 + 2486) >= (5495 - (216 + 963)))) then
								if (((type(v74) == "table") and (#v74 > (1288 - (485 + 802)))) or ((2567 - (432 + 127)) < (3002 - (1065 + 8)))) then
									if (((1325 + 1059) > (3376 - (635 + 966))) and v24(v12:EnergyTimeToX(v75), unpack(v74))) then
										return "Macro pool towards " .. v74[1 + 0]:Name() .. " at " .. v75;
									end
								elseif (v74:IsCastable() or ((4585 - (5 + 37)) <= (10883 - 6507))) then
									local v233 = 0 + 0;
									while true do
										if (((1152 - 424) == (341 + 387)) and ((0 - 0) == v233)) then
											v75 = v30(v75, v74:Cost());
											if (v22(v74, v12:EnergyTimeToX(v75)) or ((4079 - 3003) > (8808 - 4137))) then
												return "Pool towards: " .. v74:Name() .. " at " .. v75;
											end
											break;
										end
									end
								end
							end
							if (((4425 - 2574) >= (272 + 106)) and v35.ShurikenToss:IsCastable() and v13:IsInRange(559 - (318 + 211)) and not v68 and not v12:StealthUp(true, true) and not v12:BuffUp(v35.Sprint) and (v12:EnergyDeficitPredicted() < (98 - 78)) and ((v81 >= (1588 - (963 + 624))) or (v12:EnergyTimeToMax() <= (1.2 + 0)))) then
								if (v22(v35.ShurikenToss) or ((2794 - (518 + 328)) >= (8103 - 4627))) then
									return "Cast Shuriken Toss";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((7662 - 2868) >= (1150 - (301 + 16))) and (v159 == (0 - 0))) then
				v106();
				v38 = EpicSettings.Toggles['ooc'];
				v39 = EpicSettings.Toggles['aoe'];
				v40 = EpicSettings.Toggles['cds'];
				v159 = 2 - 1;
			end
			if (((10672 - 6582) == (3705 + 385)) and (v159 == (3 + 1))) then
				v83 = v87();
				v82 = v12:EnergyMax() - v89();
				if ((v12:BuffUp(v35.ShurikenTornado, nil, true) and (v80 < v33.CPMaxSpend())) or ((8022 - 4264) == (1503 + 995))) then
					local v203 = 0 + 0;
					local v204;
					while true do
						if ((v203 == (0 - 0)) or ((863 + 1810) < (2594 - (829 + 190)))) then
							v204 = v33.TimeToNextTornado();
							if ((v204 <= v12:GCDRemains()) or (v31(v12:GCDRemains() - v204) < (0.25 - 0)) or ((4708 - 987) <= (2010 - 555))) then
								local v227 = 0 - 0;
								local v228;
								while true do
									if (((222 + 712) < (742 + 1528)) and (v227 == (2 - 1))) then
										v81 = v30(v81 - v228, 0 + 0);
										if ((v79 < v33.CPMaxSpend()) or ((2225 - (520 + 93)) == (1531 - (259 + 17)))) then
											v79 = v80;
										end
										break;
									end
									if ((v227 == (0 + 0)) or ((1567 + 2785) < (14239 - 10033))) then
										v228 = v71 + v25(v12:BuffUp(v35.ShadowBlades));
										v80 = v29(v80 + v228, v33.CPMaxSpend());
										v227 = 592 - (396 + 195);
									end
								end
							end
							break;
						end
					end
				end
				v77 = ((11 - 7) + (v79 * (1765 - (440 + 1321)))) * (1829.3 - (1059 + 770));
				v159 = 23 - 18;
			end
			if ((v159 == (550 - (424 + 121))) or ((522 + 2338) <= (1528 - (641 + 706)))) then
				v78 = v35.Eviscerate:Damage() * v49;
				if (((1277 + 1945) >= (1967 - (249 + 191))) and not v12:AffectingCombat() and v60) then
					local v205 = v32.FocusUnit(false, nil, nil, "TANK", 87 - 67, v35.TricksoftheTrade);
					if (((673 + 832) <= (8174 - 6053)) and v205) then
						return v205;
					end
				end
				if (((1171 - (183 + 244)) == (37 + 707)) and v14 and v61 and (v32.UnitGroupRole(v14) == "TANK") and v35.TricksoftheTrade:IsCastable()) then
					if (v20(v37.TricksoftheTradeFocus) or ((2709 - (434 + 296)) >= (9049 - 6213))) then
						return "tricks of the trade tank";
					end
				end
				v73 = v33.CrimsonVial();
				v159 = 518 - (169 + 343);
			end
			if (((1607 + 226) <= (4694 - 2026)) and (v159 == (5 - 3))) then
				v65 = (v35.AcrobaticStrikes:IsAvailable() and (7 + 1)) or (13 - 8);
				v66 = (v35.AcrobaticStrikes:IsAvailable() and (1136 - (651 + 472))) or (8 + 2);
				v67 = v13:IsInMeleeRange(v65);
				v68 = v13:IsInMeleeRange(v66);
				v159 = 2 + 1;
			end
			if (((4498 - 812) == (4169 - (397 + 86))) and ((882 - (423 + 453)) == v159)) then
				if (((353 + 3114) > (63 + 414)) and v73) then
					return v73;
				end
				v73 = v33.Feint();
				if (v73 or ((2871 + 417) >= (2826 + 715))) then
					return v73;
				end
				v33.Poisons();
				v159 = 7 + 0;
			end
			if ((v159 == (1193 - (50 + 1140))) or ((3075 + 482) == (2681 + 1859))) then
				if (v39 or ((17 + 244) > (1819 - 552))) then
					local v206 = 0 + 0;
					while true do
						if (((1868 - (157 + 439)) < (6708 - 2850)) and (v206 == (3 - 2))) then
							v71 = #v70;
							v72 = v12:GetEnemiesInMeleeRange(v65);
							break;
						end
						if (((10837 - 7173) == (4582 - (782 + 136))) and (v206 == (855 - (112 + 743)))) then
							v69 = v12:GetEnemiesInRange(1201 - (1026 + 145));
							v70 = v12:GetEnemiesInMeleeRange(v66);
							v206 = 1 + 0;
						end
					end
				else
					v69 = {};
					v70 = {};
					v71 = 719 - (493 + 225);
					v72 = {};
				end
				v80 = v12:ComboPoints();
				v79 = v33.EffectiveComboPoints(v80);
				v81 = v12:ComboPointsDeficit();
				v159 = 14 - 10;
			end
		end
	end
	local function v108()
		local v160 = 0 + 0;
		while true do
			if (((5203 - 3262) >= (9 + 441)) and (v160 == (0 - 0))) then
				v9.Print("Subtlety Rogue by Epic BoomK");
				EpicSettings.SetupVersion("Subtlety Rogue  X v 10.2.5.02 By BoomK");
				break;
			end
		end
	end
	v9.SetAPL(76 + 185, v107, v108);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

