local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((1355 + 3203) == (308 + 4250)) and (v5 == (222 - (55 + 166)))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((78 + 688) >= (17601 - 12992))) then
			v6 = v0[v4];
			if (not v6 or ((1449 - (36 + 261)) == (4350 - 1862))) then
				return v1(v4, ...);
			end
			v5 = 1369 - (34 + 1334);
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
	local v67 = {v37.Mirror:ID(),v37.WitherbarksBranch:ID(),v37.AshesoftheEmbersoul:ID()};
	local v68, v69, v70, v71;
	local v72, v73, v74, v75;
	local v76;
	local v77, v78, v79;
	local v80, v81;
	local v82, v83, v84, v85;
	local v86;
	v36.Eviscerate:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v82 * (21.176 - (20 + 1)) * (1.21 + 0) * ((v36.Nightstalker:IsAvailable() and v13:StealthUp(true, false) and (320.08 - (134 + 185))) or (1134 - (549 + 584))) * ((v36.DeeperStratagem:IsAvailable() and (686.05 - (314 + 371))) or (3 - 2)) * ((v36.DarkShadow:IsAvailable() and v13:BuffUp(v36.ShadowDanceBuff) and (969.3 - (478 + 490))) or (1 + 0)) * ((v13:BuffUp(v36.SymbolsofDeath) and (1173.1 - (786 + 386))) or (3 - 2)) * ((v13:BuffUp(v36.FinalityEviscerateBuff) and (1380.3 - (1055 + 324))) or (1341 - (1093 + 247))) * (1 + 0 + (v13:MasteryPct() / (11 + 89))) * ((3 - 2) + (v13:VersatilityDmgPct() / (339 - 239))) * ((v14:DebuffUp(v36.FindWeaknessDebuff) and (2.5 - 1)) or (2 - 1));
	end);
	local function v87(v118, v119)
		if (((1218 + 2204) > (12905 - 9555)) and not v77) then
			local v174 = 0 - 0;
			while true do
				if (((662 + 215) > (961 - 585)) and (v174 == (688 - (364 + 324)))) then
					v77 = v118;
					v78 = v119 or (0 - 0);
					break;
				end
			end
		end
	end
	local function v88(v120)
		if (not v79 or ((7481 - 4363) <= (614 + 1237))) then
			v79 = v120;
		end
	end
	local function v89()
		if (((v45 == "On Bosses not in Dungeons") and v13:IsInDungeonArea()) or ((690 - 525) >= (5591 - 2099))) then
			return false;
		elseif (((11993 - 8044) < (6124 - (1249 + 19))) and (v45 ~= "Always") and not v14:IsInBossList()) then
			return false;
		else
			return true;
		end
	end
	local function v90()
		local v121 = 0 + 0;
		while true do
			if ((v121 == (0 - 0)) or ((5362 - (686 + 400)) < (2367 + 649))) then
				if (((4919 - (73 + 156)) > (20 + 4105)) and (v74 < (813 - (721 + 90)))) then
					return false;
				elseif ((v46 == "Always") or ((1 + 49) >= (2909 - 2013))) then
					return true;
				elseif (((v46 == "On Bosses") and v14:IsInBossList()) or ((2184 - (224 + 246)) >= (4791 - 1833))) then
					return true;
				elseif ((v46 == "Auto") or ((2745 - 1254) < (117 + 527))) then
					if (((17 + 687) < (725 + 262)) and (v13:InstanceDifficulty() == (31 - 15)) and (v14:NPCID() == (462457 - 323490))) then
						return true;
					elseif (((4231 - (203 + 310)) > (3899 - (1238 + 755))) and ((v14:NPCID() == (11665 + 155304)) or (v14:NPCID() == (168505 - (709 + 825))) or (v14:NPCID() == (307687 - 140717)))) then
						return true;
					elseif ((v14:NPCID() == (267251 - 83788)) or (v14:NPCID() == (184535 - (196 + 668))) or ((3782 - 2824) > (7529 - 3894))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v91(v122, v123, v124, v125)
		local v126, v127 = nil, v124;
		local v128 = v14:GUID();
		for v171, v172 in v28(v125) do
			if (((4334 - (171 + 662)) <= (4585 - (4 + 89))) and (v172:GUID() ~= v128) and v33.UnitIsCycleValid(v172, v127, -v172:DebuffRemains(v122)) and v123(v172)) then
				v126, v127 = v172, v172:TimeToDie();
			end
		end
		if ((v126 and (v14:GUID() == v126:GUID())) or ((12063 - 8621) < (928 + 1620))) then
			v10.Press(v122);
		elseif (((12627 - 9752) >= (575 + 889)) and v47) then
			local v205 = 1486 - (35 + 1451);
			while true do
				if ((v205 == (1454 - (28 + 1425))) or ((6790 - (941 + 1052)) >= (4692 + 201))) then
					if ((v126 and (v14:GUID() == v126:GUID())) or ((2065 - (822 + 692)) > (2952 - 884))) then
						v10.Press(v122);
					end
					break;
				end
				if (((996 + 1118) > (1241 - (45 + 252))) and (v205 == (0 + 0))) then
					v126, v127 = nil, v124;
					for v232, v233 in v28(v73) do
						if (((v233:GUID() ~= v128) and v33.UnitIsCycleValid(v233, v127, -v233:DebuffRemains(v122)) and v123(v233)) or ((779 + 1483) >= (7534 - 4438))) then
							v126, v127 = v233, v233:TimeToDie();
						end
					end
					v205 = 434 - (114 + 319);
				end
			end
		end
	end
	local function v92()
		return (28 - 8) + (v36.Vigor:TalentRank() * (32 - 7)) + (v26(v36.ThistleTea:IsAvailable()) * (13 + 7)) + (v26(v36.Shadowcraft:IsAvailable()) * (29 - 9));
	end
	local function v93()
		return v36.ShadowDance:ChargesFractional() >= ((0.75 - 0) + v18(v36.ShadowDanceTalent:IsAvailable()));
	end
	local function v94()
		return v84 >= (1966 - (556 + 1407));
	end
	local function v95()
		return v13:BuffUp(v36.SliceandDice) or (v74 >= v34.CPMaxSpend());
	end
	local function v96()
		return v36.Premeditation:IsAvailable() and (v74 < (1211 - (741 + 465)));
	end
	local function v97(v129)
		return (v13:BuffUp(v36.ThistleTea) and (v74 == (466 - (170 + 295)))) or (v129 and ((v74 == (1 + 0)) or (v14:DebuffUp(v36.Rupture) and (v74 >= (2 + 0)))));
	end
	local function v98()
		return (not v13:BuffUp(v36.TheRotten) or not v13:HasTier(73 - 43, 2 + 0)) and (not v36.ColdBlood:IsAvailable() or (v36.ColdBlood:CooldownRemains() < (3 + 1)) or (v36.ColdBlood:CooldownRemains() > (6 + 4)));
	end
	local function v99(v130)
		return v13:BuffUp(v36.ShadowDanceBuff) and (v130:TimeSinceLastCast() < v36.ShadowDance:TimeSinceLastCast());
	end
	local function v100()
		return ((v99(v36.Shadowstrike) or v99(v36.ShurikenStorm)) and (v99(v36.Eviscerate) or v99(v36.BlackPowder) or v99(v36.Rupture))) or not v36.DanseMacabre:IsAvailable();
	end
	local function v101()
		return (not v37.WitherbarksBranch:IsEquipped() and not v37.AshesoftheEmbersoul:IsEquipped()) or (not v37.WitherbarksBranch:IsEquipped() and (v37.WitherbarksBranch:CooldownRemains() <= (1238 - (957 + 273)))) or (v37.WitherbarksBranch:IsEquipped() and (v37.WitherbarksBranch:CooldownRemains() <= (3 + 5))) or v37.BandolierOfTwistedBlades:IsEquipped() or v36.InvigoratingShadowdust:IsAvailable();
	end
	local function v102(v131, v132)
		local v133 = 0 + 0;
		local v134;
		local v135;
		local v136;
		local v137;
		local v138;
		local v139;
		local v140;
		while true do
			if ((v133 == (7 - 5)) or ((5942 - 3687) >= (10803 - 7266))) then
				v140 = v13:BuffUp(v36.PremeditationBuff) or (v132 and v36.Premeditation:IsAvailable());
				if ((v132 and (v132:ID() == v36.ShadowDance:ID())) or ((18999 - 15162) < (3086 - (389 + 1391)))) then
					local v207 = 0 + 0;
					while true do
						if (((308 + 2642) == (6716 - 3766)) and (v207 == (951 - (783 + 168)))) then
							v134 = true;
							v135 = (26 - 18) + v36.ImprovedShadowDance:TalentRank();
							v207 = 1 + 0;
						end
						if ((v207 == (312 - (309 + 2))) or ((14503 - 9780) < (4510 - (1090 + 122)))) then
							if (((369 + 767) >= (517 - 363)) and v36.TheFirstDance:IsAvailable()) then
								v137 = v30(v13:ComboPointsMax(), v83 + 3 + 1);
							end
							if (v13:HasTier(1148 - (628 + 490), 1 + 1) or ((670 - 399) > (21698 - 16950))) then
								v136 = v31(v136, 780 - (431 + 343));
							end
							break;
						end
					end
				end
				if (((9572 - 4832) >= (9118 - 5966)) and v132 and (v132:ID() == v36.Vanish:ID())) then
					v138 = v30(0 + 0, v36.ColdBlood:CooldownRemains() - ((2 + 13) * v36.InvigoratingShadowdust:TalentRank()));
					v139 = v30(1695 - (556 + 1139), v36.SymbolsofDeath:CooldownRemains() - ((30 - (6 + 9)) * v36.InvigoratingShadowdust:TalentRank()));
				end
				v133 = 1 + 2;
			end
			if (((3 + 2) == v133) or ((2747 - (28 + 141)) >= (1314 + 2076))) then
				if (((50 - 9) <= (1177 + 484)) and not v97(v134) and v36.Rupture:IsCastable()) then
					if (((1918 - (486 + 831)) < (9263 - 5703)) and not v131 and v40 and not v86 and (v74 >= (6 - 4))) then
						local v221 = 0 + 0;
						local v222;
						while true do
							if (((742 - 507) < (1950 - (668 + 595))) and (v221 == (0 + 0))) then
								v222 = nil;
								function v222(v247)
									return v33.CanDoTUnit(v247, v81) and v247:DebuffRefreshable(v36.Rupture, v80);
								end
								v221 = 1 + 0;
							end
							if (((12405 - 7856) > (1443 - (23 + 267))) and (v221 == (1945 - (1129 + 815)))) then
								v91(v36.Rupture, v222, (389 - (371 + 16)) * v137, v75);
								break;
							end
						end
					end
					if ((v70 and (v14:DebuffRemains(v36.Rupture) < (v139 + (1760 - (1326 + 424)))) and (v139 <= (9 - 4)) and v34.CanDoTUnit(v14, v81) and v14:FilteredTimeToDie(">", (18 - 13) + v139, -v14:DebuffRemains(v36.Rupture))) or ((4792 - (88 + 30)) < (5443 - (720 + 51)))) then
						if (((8159 - 4491) < (6337 - (421 + 1355))) and v131) then
							return v36.Rupture;
						else
							if ((v36.Rupture:IsReady() and v19(v36.Rupture)) or ((750 - 295) == (1771 + 1834))) then
								return "Cast Rupture 2";
							end
							v88(v36.Rupture);
						end
					end
				end
				if ((v36.BlackPowder:IsCastable() and not v86 and (v74 >= (1086 - (286 + 797))) and not v44) or ((9734 - 7071) == (5485 - 2173))) then
					if (((4716 - (397 + 42)) <= (1398 + 3077)) and v131) then
						return v36.BlackPowder;
					else
						local v223 = 800 - (24 + 776);
						while true do
							if ((v223 == (0 - 0)) or ((1655 - (222 + 563)) == (2619 - 1430))) then
								if (((1119 + 434) <= (3323 - (23 + 167))) and v36.BlackPowder:IsReady() and v19(v36.BlackPowder)) then
									return "Cast Black Powder";
								end
								v88(v36.BlackPowder);
								break;
							end
						end
					end
				end
				if ((v36.Eviscerate:IsCastable() and v70) or ((4035 - (690 + 1108)) >= (1267 + 2244))) then
					if (v131 or ((1093 + 231) > (3868 - (40 + 808)))) then
						return v36.Eviscerate;
					else
						if ((v36.Eviscerate:IsReady() and v19(v36.Eviscerate)) or ((493 + 2499) == (7192 - 5311))) then
							return "Cast Eviscerate";
						end
						v88(v36.Eviscerate);
					end
				end
				v133 = 6 + 0;
			end
			if (((1644 + 1462) > (837 + 689)) and (v133 == (577 - (47 + 524)))) then
				return false;
			end
			if (((1962 + 1061) < (10578 - 6708)) and (v133 == (1 - 0))) then
				v137 = v83;
				v138 = v36.ColdBlood:CooldownRemains();
				v139 = v36.SymbolsofDeath:CooldownRemains();
				v133 = 4 - 2;
			end
			if (((1869 - (1165 + 561)) > (3 + 71)) and ((9 - 6) == v133)) then
				if (((7 + 11) < (2591 - (341 + 138))) and v36.Rupture:IsCastable() and v36.Rupture:IsReady()) then
					if (((297 + 800) <= (3359 - 1731)) and v14:DebuffDown(v36.Rupture) and (v14:TimeToDie() > (332 - (89 + 237)))) then
						if (((14894 - 10264) == (9747 - 5117)) and v131) then
							return v36.Rupture;
						else
							local v234 = 881 - (581 + 300);
							while true do
								if (((4760 - (855 + 365)) > (6372 - 3689)) and ((0 + 0) == v234)) then
									if (((6029 - (1030 + 205)) >= (3075 + 200)) and v36.Rupture:IsReady() and v19(v36.Rupture)) then
										return "Cast Rupture";
									end
									v88(v36.Rupture);
									break;
								end
							end
						end
					end
				end
				if (((1381 + 103) == (1770 - (156 + 130))) and not v13:StealthUp(true, true) and not v96() and (v74 < (13 - 7)) and not v134 and v10.BossFilteredFightRemains(">", v13:BuffRemains(v36.SliceandDice)) and (v13:BuffRemains(v36.SliceandDice) < (((1 - 0) + v13:ComboPoints()) * (1.8 - 0)))) then
					if (((378 + 1054) < (2074 + 1481)) and v131) then
						return v36.SliceandDice;
					else
						local v224 = 69 - (10 + 59);
						while true do
							if ((v224 == (0 + 0)) or ((5244 - 4179) > (4741 - (671 + 492)))) then
								if ((v36.SliceandDice:IsReady() and v19(v36.SliceandDice)) or ((3818 + 977) < (2622 - (369 + 846)))) then
									return "Cast Slice and Dice Premed";
								end
								v88(v36.SliceandDice);
								break;
							end
						end
					end
				end
				if (((491 + 1362) < (4108 + 705)) and (not v97(v134) or v86) and (v14:TimeToDie() > (1951 - (1036 + 909))) and v14:DebuffRefreshable(v36.Rupture, v80)) then
					if (v131 or ((2243 + 578) < (4081 - 1650))) then
						return v36.Rupture;
					else
						if ((v36.Rupture:IsReady() and v19(v36.Rupture)) or ((3077 - (11 + 192)) < (1103 + 1078))) then
							return "Cast Rupture";
						end
						v88(v36.Rupture);
					end
				end
				v133 = 179 - (135 + 40);
			end
			if ((v133 == (0 - 0)) or ((1621 + 1068) <= (755 - 412))) then
				v134 = v13:BuffUp(v36.ShadowDanceBuff);
				v135 = v13:BuffRemains(v36.ShadowDanceBuff);
				v136 = v13:BuffRemains(v36.SymbolsofDeath);
				v133 = 1 - 0;
			end
			if ((v133 == (180 - (50 + 126))) or ((5204 - 3335) == (445 + 1564))) then
				if ((v13:BuffUp(v36.FinalityRuptureBuff) and v134 and (v74 <= (1417 - (1233 + 180))) and not v99(v36.Rupture)) or ((4515 - (522 + 447)) < (3743 - (107 + 1314)))) then
					if (v131 or ((967 + 1115) == (14543 - 9770))) then
						return v36.Rupture;
					else
						local v225 = 0 + 0;
						while true do
							if (((6441 - 3197) > (4174 - 3119)) and ((1910 - (716 + 1194)) == v225)) then
								if ((v36.Rupture:IsReady() and v19(v36.Rupture)) or ((57 + 3256) <= (191 + 1587))) then
									return "Cast Rupture Finality";
								end
								v88(v36.Rupture);
								break;
							end
						end
					end
				end
				if ((v36.ColdBlood:IsReady() and v100(v134, v140) and v36.SecretTechnique:IsReady()) or ((1924 - (74 + 429)) >= (4058 - 1954))) then
					local v208 = 0 + 0;
					while true do
						if (((4147 - 2335) <= (2299 + 950)) and (v208 == (0 - 0))) then
							if (((4012 - 2389) <= (2390 - (279 + 154))) and v131) then
								return v36.ColdBlood;
							end
							if (((5190 - (454 + 324)) == (3472 + 940)) and v19(v36.ColdBlood)) then
								return "Cast Cold Blood (SecTec)";
							end
							break;
						end
					end
				end
				if (((1767 - (12 + 5)) >= (454 + 388)) and v36.SecretTechnique:IsReady()) then
					if (((11139 - 6767) > (684 + 1166)) and v100(v134, v140) and (not v36.ColdBlood:IsAvailable() or v13:BuffUp(v36.ColdBlood) or (v138 > (v135 - (1095 - (277 + 816)))) or not v36.ImprovedShadowDance:IsAvailable())) then
						local v226 = 0 - 0;
						while true do
							if (((1415 - (1058 + 125)) < (154 + 667)) and (v226 == (975 - (815 + 160)))) then
								if (((2222 - 1704) < (2140 - 1238)) and v131) then
									return v36.SecretTechnique;
								end
								if (((715 + 2279) > (2508 - 1650)) and v19(v36.SecretTechnique)) then
									return "Cast Secret Technique";
								end
								break;
							end
						end
					end
				end
				v133 = 1903 - (41 + 1857);
			end
		end
	end
	local function v103(v141, v142)
		local v143 = v13:BuffUp(v36.ShadowDanceBuff);
		local v144 = v13:BuffRemains(v36.ShadowDanceBuff);
		local v145 = v13:BuffUp(v36.TheRottenBuff);
		local v146, v147 = v83, v84;
		local v148 = v13:BuffUp(v36.PremeditationBuff) or (v142 and v36.Premeditation:IsAvailable());
		local v149 = v13:BuffUp(v34.StealthSpell()) or (v142 and (v142:ID() == v34.StealthSpell():ID()));
		local v150 = v13:BuffUp(v34.VanishBuffSpell()) or (v142 and (v142:ID() == v36.Vanish:ID()));
		if ((v142 and (v142:ID() == v36.ShadowDance:ID())) or ((5648 - (1222 + 671)) <= (2364 - 1449))) then
			local v175 = 0 - 0;
			while true do
				if (((5128 - (229 + 953)) > (5517 - (1111 + 663))) and ((1579 - (874 + 705)) == v175)) then
					v143 = true;
					v144 = 2 + 6 + v36.ImprovedShadowDance:TalentRank();
					v175 = 1 + 0;
				end
				if (((1 - 0) == v175) or ((38 + 1297) >= (3985 - (642 + 37)))) then
					if (((1105 + 3739) > (361 + 1892)) and v36.TheRotten:IsAvailable() and v13:HasTier(75 - 45, 456 - (233 + 221))) then
						v145 = true;
					end
					if (((1044 - 592) == (398 + 54)) and v36.TheFirstDance:IsAvailable()) then
						local v227 = 1541 - (718 + 823);
						while true do
							if ((v227 == (0 + 0)) or ((5362 - (266 + 539)) < (5908 - 3821))) then
								v146 = v30(v13:ComboPointsMax(), v83 + (1229 - (636 + 589)));
								v147 = v13:ComboPointsMax() - v146;
								break;
							end
						end
					end
					break;
				end
			end
		end
		local v151 = v34.EffectiveComboPoints(v146);
		local v152 = v36.Shadowstrike:IsCastable() or v149 or v150 or v143 or v13:BuffUp(v36.SepsisBuff);
		if (((9195 - 5321) == (7990 - 4116)) and (v149 or v150)) then
			v152 = v152 and v14:IsInRange(20 + 5);
		else
			v152 = v152 and v70;
		end
		if ((v152 and v149 and ((v74 < (2 + 2)) or v86)) or ((2953 - (657 + 358)) > (13066 - 8131))) then
			if (v141 or ((9694 - 5439) < (4610 - (1151 + 36)))) then
				return v36.Shadowstrike;
			elseif (((1405 + 49) <= (655 + 1836)) and v19(v36.Shadowstrike)) then
				return "Cast Shadowstrike (Stealth)";
			end
		end
		if ((v151 >= v34.CPMaxSpend()) or ((12414 - 8257) <= (4635 - (1552 + 280)))) then
			return v102(v141, v142);
		end
		if (((5687 - (64 + 770)) >= (2025 + 957)) and v13:BuffUp(v36.ShurikenTornado) and (v147 <= (4 - 2))) then
			return v102(v141, v142);
		end
		if (((734 + 3400) > (4600 - (157 + 1086))) and (v84 <= ((1 - 0) + v26(v36.DeeperStratagem:IsAvailable() or v36.SecretStratagem:IsAvailable())))) then
			return v102(v141, v142);
		end
		if ((v36.Backstab:IsCastable() and not v148 and (v144 >= (13 - 10)) and v13:BuffUp(v36.ShadowBlades) and not v99(v36.Backstab) and v36.DanseMacabre:IsAvailable() and (v74 <= (3 - 0)) and not v145) or ((4663 - 1246) < (3353 - (599 + 220)))) then
			if (v141 or ((5420 - 2698) <= (2095 - (1813 + 118)))) then
				if (v142 or ((1761 + 647) < (3326 - (841 + 376)))) then
					return v36.Backstab;
				else
					return {v36.Backstab,v36.Stealth};
				end
			elseif (v22(v36.Backstab, v36.Stealth) or ((89 - 56) == (2314 - (464 + 395)))) then
				return "Cast Backstab (Stealth)";
			end
		end
		if (v36.Gloomblade:IsAvailable() or ((1136 - 693) >= (1929 + 2086))) then
			if (((4219 - (467 + 370)) > (342 - 176)) and not v148 and (v144 >= (3 + 0)) and v13:BuffUp(v36.ShadowBlades) and not v99(v36.Gloomblade) and v36.DanseMacabre:IsAvailable() and (v74 <= (13 - 9))) then
				if (v141 or ((44 + 236) == (7116 - 4057))) then
					if (((2401 - (150 + 370)) > (2575 - (74 + 1208))) and v142) then
						return v36.Gloomblade;
					else
						return {v36.Gloomblade,v36.Stealth};
					end
				elseif (((1678 + 679) == (2747 - (14 + 376))) and v22(v36.Gloomblade, v36.Stealth)) then
					return "Cast Gloomblade (Danse)";
				end
			end
		end
		if (((212 - 89) == (80 + 43)) and not v99(v36.Shadowstrike) and v13:BuffUp(v36.ShadowBlades)) then
			if (v141 or ((928 + 128) >= (3235 + 157))) then
				return v36.Shadowstrike;
			elseif (v19(v36.Shadowstrike) or ((3167 - 2086) < (809 + 266))) then
				return "Cast Shadowstrike (Danse)";
			end
		end
		if ((not v148 and (v74 >= (82 - (23 + 55)))) or ((2485 - 1436) >= (2958 + 1474))) then
			if (v141 or ((4282 + 486) <= (1311 - 465))) then
				return v36.ShurikenStorm;
			elseif (v19(v36.ShurikenStorm) or ((1057 + 2301) <= (2321 - (652 + 249)))) then
				return "Cast Shuriken Storm";
			end
		end
		if (v152 or ((10006 - 6267) <= (4873 - (708 + 1160)))) then
			if (v141 or ((4503 - 2844) >= (3890 - 1756))) then
				return v36.Shadowstrike;
			elseif (v19(v36.Shadowstrike) or ((3287 - (10 + 17)) < (529 + 1826))) then
				return "Cast Shadowstrike";
			end
		end
		return false;
	end
	local function v104(v153, v154)
		local v155 = v103(true, v153);
		if ((v43 and (v153:ID() == v36.Vanish:ID()) and (not v48 or not v155)) or ((2401 - (1400 + 332)) == (8099 - 3876))) then
			local v176 = 1908 - (242 + 1666);
			while true do
				if ((v176 == (0 + 0)) or ((621 + 1071) < (502 + 86))) then
					if (v19(v36.Vanish, nil) or ((5737 - (850 + 90)) < (6394 - 2743))) then
						return "Cast Vanish";
					end
					return false;
				end
			end
		elseif (((v153:ID() == v36.Shadowmeld:ID()) and (not v49 or not v155)) or ((5567 - (360 + 1030)) > (4293 + 557))) then
			local v206 = 0 - 0;
			while true do
				if ((v206 == (0 - 0)) or ((2061 - (909 + 752)) > (2334 - (109 + 1114)))) then
					if (((5585 - 2534) > (392 + 613)) and v19(v36.Shadowmeld, nil)) then
						return "Cast Shadowmeld";
					end
					return false;
				end
			end
		elseif (((3935 - (6 + 236)) <= (2761 + 1621)) and (v153:ID() == v36.ShadowDance:ID()) and (not v50 or not v155)) then
			local v220 = 0 + 0;
			while true do
				if ((v220 == (0 - 0)) or ((5732 - 2450) > (5233 - (1076 + 57)))) then
					if (v19(v36.ShadowDance, nil) or ((589 + 2991) < (3533 - (579 + 110)))) then
						return "Cast Shadow Dance";
					end
					return false;
				end
			end
		end
		local v156 = {v153,v155};
		if (((48 + 41) < (4897 - (174 + 233))) and v154 and (v13:EnergyPredicted() < v154)) then
			local v177 = 0 - 0;
			while true do
				if ((v177 == (0 - 0)) or ((2216 + 2767) < (2982 - (663 + 511)))) then
					v87(v156, v154);
					return false;
				end
			end
		end
		v76 = v22(unpack(v156));
		if (((3416 + 413) > (819 + 2950)) and v76) then
			return "| " .. v156[5 - 3]:Name();
		end
		return false;
	end
	local function v105()
		local v157 = 0 + 0;
		while true do
			if (((3495 - 2010) <= (7029 - 4125)) and (v157 == (0 + 0))) then
				if (((8308 - 4039) == (3043 + 1226)) and not v13:IsCasting() and not v13:IsChanneling()) then
					local v209 = 0 + 0;
					local v210;
					while true do
						if (((1109 - (478 + 244)) <= (3299 - (440 + 77))) and ((2 + 1) == v209)) then
							if (v210 or ((6950 - 5051) <= (2473 - (655 + 901)))) then
								return v210;
							end
							v210 = v33.InterruptWithStun(v36.KidneyShot, 2 + 6, v13:ComboPoints() > (0 + 0));
							if (v210 or ((2912 + 1400) <= (3529 - 2653))) then
								return v210;
							end
							break;
						end
						if (((3677 - (695 + 750)) <= (8864 - 6268)) and (v209 == (0 - 0))) then
							v210 = v33.Interrupt(v36.Kick, 32 - 24, true);
							if (((2446 - (285 + 66)) < (8592 - 4906)) and v210) then
								return v210;
							end
							v210 = v33.Interrupt(v36.Kick, 1318 - (682 + 628), true, MouseOver, v38.KickMouseover);
							v209 = 1 + 0;
						end
						if (((300 - (176 + 123)) == v209) or ((668 + 927) >= (3246 + 1228))) then
							if (v210 or ((4888 - (239 + 30)) < (784 + 2098))) then
								return v210;
							end
							v210 = v33.Interrupt(v36.Blind, 15 + 0, BlindInterrupt);
							if (v210 or ((520 - 226) >= (15072 - 10241))) then
								return v210;
							end
							v209 = 317 - (306 + 9);
						end
						if (((7080 - 5051) <= (537 + 2547)) and (v209 == (2 + 0))) then
							v210 = v33.Interrupt(v36.Blind, 8 + 7, BlindInterrupt, MouseOver, v38.BlindMouseover);
							if (v210 or ((5824 - 3787) == (3795 - (1140 + 235)))) then
								return v210;
							end
							v210 = v33.InterruptWithStun(v36.CheapShot, 6 + 2, v13:StealthUp(false, false));
							v209 = 3 + 0;
						end
					end
				end
				return false;
			end
		end
	end
	local function v106()
		local v158 = 0 + 0;
		local v159;
		while true do
			if (((4510 - (33 + 19)) > (1410 + 2494)) and (v158 == (5 - 3))) then
				return false;
			end
			if (((193 + 243) >= (240 - 117)) and (v158 == (1 + 0))) then
				v159 = v33.HandleBottomTrinket(v67, v41, 729 - (586 + 103), nil);
				if (((46 + 454) < (5590 - 3774)) and v159) then
					return v159;
				end
				v158 = 1490 - (1309 + 179);
			end
			if (((6451 - 2877) == (1556 + 2018)) and (v158 == (0 - 0))) then
				v159 = v33.HandleTopTrinket(v67, v41, 31 + 9, nil);
				if (((469 - 248) < (777 - 387)) and v159) then
					return v159;
				end
				v158 = 610 - (295 + 314);
			end
		end
	end
	local function v107()
		local v160 = 0 - 0;
		while true do
			if ((v160 == (1962 - (1300 + 662))) or ((6948 - 4735) <= (3176 - (1178 + 577)))) then
				if (((1589 + 1469) < (14367 - 9507)) and v41) then
					local v211 = v33.HandleDPSPotion(v10.BossFilteredFightRemains("<", 1435 - (851 + 554)) or (v13:BuffUp(v36.SymbolsofDeath) and (v13:BuffUp(v36.ShadowBlades) or (v36.ShadowBlades:CooldownRemains() <= (9 + 1)))));
					if (v211 or ((3594 - 2298) >= (9655 - 5209))) then
						return v211;
					end
				end
				return false;
			end
		end
	end
	local function v108()
		if (v41 or ((1695 - (115 + 187)) > (3438 + 1051))) then
			local v178 = 0 + 0;
			while true do
				if ((v178 == (0 - 0)) or ((5585 - (160 + 1001)) < (24 + 3))) then
					if ((v36.ArcaneTorrent:IsReady() and v70 and (v13:EnergyDeficitPredicted() >= (11 + 4 + v13:EnergyRegen())) and v53) or ((4087 - 2090) > (4173 - (237 + 121)))) then
						if (((4362 - (525 + 372)) > (3626 - 1713)) and v19(v36.ArcaneTorrent, nil)) then
							return "Cast Arcane Torrent";
						end
					end
					if (((2408 - 1675) < (1961 - (96 + 46))) and v36.ArcanePulse:IsReady() and v70 and v53) then
						if (v19(v36.ArcanePulse, nil) or ((5172 - (643 + 134)) == (1717 + 3038))) then
							return "Cast Arcane Pulse";
						end
					end
					v178 = 2 - 1;
				end
				if ((v178 == (3 - 2)) or ((3638 + 155) < (4648 - 2279))) then
					if ((v36.BagofTricks:IsReady() and v53) or ((8347 - 4263) == (984 - (316 + 403)))) then
						if (((2897 + 1461) == (11981 - 7623)) and v19(v36.BagofTricks, nil)) then
							return "Cast Bag of Tricks";
						end
					end
					break;
				end
			end
		end
		if ((v41 and v36.ColdBlood:IsReady() and not v36.SecretTechnique:IsAvailable() and (v83 >= (2 + 3))) or ((7902 - 4764) < (704 + 289))) then
			if (((1074 + 2256) > (8049 - 5726)) and v19(v36.ColdBlood, nil)) then
				return "Cast Cold Blood";
			end
		end
		if ((v41 and v36.Sepsis:IsAvailable() and v36.Sepsis:IsReady()) or ((17317 - 13691) == (8286 - 4297))) then
			if ((v95() and v14:FilteredTimeToDie(">=", 1 + 15) and (v13:BuffUp(v36.PerforatedVeins) or not v36.PerforatedVeins:IsAvailable())) or ((1803 - 887) == (131 + 2540))) then
				if (((800 - 528) == (289 - (12 + 5))) and v19(v36.Sepsis, nil, nil)) then
					return "Cast Sepsis";
				end
			end
		end
		if (((16503 - 12254) <= (10324 - 5485)) and v41 and v36.Flagellation:IsAvailable() and v36.Flagellation:IsReady()) then
			if (((5902 - 3125) < (7935 - 4735)) and v95() and (v82 >= (2 + 3)) and (v14:TimeToDie() > (1983 - (1656 + 317))) and ((v101() and (v36.ShadowBlades:CooldownRemains() <= (3 + 0))) or v10.BossFilteredFightRemains("<=", 23 + 5) or ((v36.ShadowBlades:CooldownRemains() >= (36 - 22)) and v36.InvigoratingShadowdust:IsAvailable() and v36.ShadowDance:IsAvailable())) and (not v36.InvigoratingShadowdust:IsAvailable() or v36.Sepsis:IsAvailable() or not v36.ShadowDance:IsAvailable() or ((v36.InvigoratingShadowdust:TalentRank() == (9 - 7)) and (v74 >= (356 - (5 + 349)))) or (v36.SymbolsofDeath:CooldownRemains() <= (14 - 11)) or (v13:BuffRemains(v36.SymbolsofDeath) > (1274 - (266 + 1005))))) then
				if (((63 + 32) < (6677 - 4720)) and v19(v36.Flagellation, nil, nil)) then
					return "Cast Flagellation";
				end
			end
		end
		if (((1087 - 261) < (3413 - (561 + 1135))) and v41 and v36.SymbolsofDeath:IsReady()) then
			if (((1857 - 431) >= (3632 - 2527)) and v95() and (not v13:BuffUp(v36.TheRotten) or not v13:HasTier(1096 - (507 + 559), 4 - 2)) and (v13:BuffRemains(v36.SymbolsofDeath) <= (9 - 6)) and (not v36.Flagellation:IsAvailable() or (v36.Flagellation:CooldownRemains() > (398 - (212 + 176))) or ((v13:BuffRemains(v36.ShadowDance) >= (907 - (250 + 655))) and v36.InvigoratingShadowdust:IsAvailable()) or (v36.Flagellation:IsReady() and (v82 >= (13 - 8)) and not v36.InvigoratingShadowdust:IsAvailable()))) then
				if (((4811 - 2057) <= (5286 - 1907)) and v19(v36.SymbolsofDeath, nil)) then
					return "Cast Symbols of Death";
				end
			end
		end
		if ((v41 and v36.ShadowBlades:IsReady()) or ((5883 - (1869 + 87)) == (4900 - 3487))) then
			if ((v95() and ((v82 <= (1902 - (484 + 1417))) or v13:HasTier(66 - 35, 6 - 2)) and (v13:BuffUp(v36.Flagellation) or v13:BuffUp(v36.FlagellationPersistBuff) or not v36.Flagellation:IsAvailable())) or ((1927 - (48 + 725)) <= (1286 - 498))) then
				if (v19(v36.ShadowBlades, nil) or ((4407 - 2764) > (1964 + 1415))) then
					return "Cast Shadow Blades";
				end
			end
		end
		if ((v41 and v36.EchoingReprimand:IsCastable() and v36.EchoingReprimand:IsAvailable()) or ((7490 - 4687) > (1274 + 3275))) then
			if ((v95() and (v84 >= (1 + 2))) or ((1073 - (152 + 701)) >= (4333 - (430 + 881)))) then
				if (((1081 + 1741) == (3717 - (557 + 338))) and v19(v36.EchoingReprimand, nil, nil)) then
					return "Cast Echoing Reprimand";
				end
			end
		end
		if ((v41 and v36.ShurikenTornado:IsAvailable() and v36.ShurikenTornado:IsReady()) or ((314 + 747) == (5232 - 3375))) then
			if (((9664 - 6904) > (3623 - 2259)) and v95() and v13:BuffUp(v36.SymbolsofDeath) and (v82 <= (4 - 2)) and not v13:BuffUp(v36.Premeditation) and (not v36.Flagellation:IsAvailable() or (v36.Flagellation:CooldownRemains() > (821 - (499 + 302)))) and (v74 >= (869 - (39 + 827)))) then
				if (v19(v36.ShurikenTornado, nil) or ((13531 - 8629) <= (8029 - 4434))) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if ((v41 and v36.ShurikenTornado:IsAvailable() and v36.ShurikenTornado:IsReady()) or ((15299 - 11447) == (449 - 156))) then
			if ((v95() and not v13:BuffUp(v36.ShadowDance) and not v13:BuffUp(v36.Flagellation) and not v13:BuffUp(v36.FlagellationPersistBuff) and not v13:BuffUp(v36.ShadowBlades) and (v74 <= (1 + 1))) or ((4562 - 3003) == (734 + 3854))) then
				if (v19(v36.ShurikenTornado, nil) or ((7094 - 2610) == (892 - (103 + 1)))) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if (((5122 - (475 + 79)) >= (8445 - 4538)) and v41 and v36.ShadowDance:IsAvailable() and v89() and v36.ShadowDance:IsReady()) then
			if (((3987 - 2741) < (449 + 3021)) and not v13:BuffUp(v36.ShadowDance) and v10.BossFilteredFightRemains("<=", 8 + 0 + ((1506 - (1395 + 108)) * v26(v36.Subterfuge:IsAvailable())))) then
				if (((11837 - 7769) >= (2176 - (7 + 1197))) and v19(v36.ShadowDance)) then
					return "Cast Shadow Dance";
				end
			end
		end
		if (((215 + 278) < (1359 + 2534)) and v41 and v36.GoremawsBite:IsAvailable() and v36.GoremawsBite:IsReady()) then
			if ((v95() and (v84 >= (322 - (27 + 292))) and (not v36.ShadowDance:IsReady() or (v36.ShadowDance:IsAvailable() and v13:BuffUp(v36.ShadowDance) and not v36.InvigoratingShadowdust:IsAvailable()) or ((v74 < (11 - 7)) and not v36.InvigoratingShadowdust:IsAvailable()) or v36.TheRotten:IsAvailable())) or ((1877 - 404) >= (13973 - 10641))) then
				if (v19(v36.GoremawsBite) or ((7988 - 3937) <= (2203 - 1046))) then
					return "Cast Goremaw's Bite";
				end
			end
		end
		if (((743 - (43 + 96)) < (11751 - 8870)) and v36.ThistleTea:IsReady()) then
			if ((((v36.SymbolsofDeath:CooldownRemains() >= (6 - 3)) or v13:BuffUp(v36.SymbolsofDeath)) and not v13:BuffUp(v36.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (83 + 17)) and ((v84 >= (1 + 1)) or (v74 >= (5 - 2)))) or ((v36.ThistleTea:ChargesFractional() >= ((1.75 + 1) - ((0.15 - 0) * v36.InvigoratingShadowdust:TalentRank()))) and (v36.Vanish:IsReady() or not v43) and v13:BuffUp(v36.ShadowDance) and v14:DebuffUp(v36.Rupture) and (v74 < (1 + 2))))) or ((v13:BuffRemains(v36.ShadowDance) >= (1 + 3)) and not v13:BuffUp(v36.ThistleTea) and (v74 >= (1754 - (1414 + 337)))) or (not v13:BuffUp(v36.ThistleTea) and v10.BossFilteredFightRemains("<=", (1946 - (1642 + 298)) * v36.ThistleTea:Charges())) or ((2346 - 1446) == (9715 - 6338))) then
				if (((13232 - 8773) > (195 + 396)) and v19(v36.ThistleTea, nil, nil)) then
					return "Thistle Tea";
				end
			end
		end
		local v161 = v13:BuffUp(v36.ShadowBlades) or (not v36.ShadowBlades:IsAvailable() and v13:BuffUp(v36.SymbolsofDeath)) or v10.BossFilteredFightRemains("<", 16 + 4);
		if (((4370 - (357 + 615)) >= (1682 + 713)) and v36.BloodFury:IsCastable() and v161 and v53) then
			if (v19(v36.BloodFury, nil) or ((5355 - 3172) >= (2420 + 404))) then
				return "Cast Blood Fury";
			end
		end
		if (((4148 - 2212) == (1549 + 387)) and v36.Berserking:IsCastable() and v161 and v53) then
			if (v19(v36.Berserking, nil) or ((329 + 4503) < (2711 + 1602))) then
				return "Cast Berserking";
			end
		end
		if (((5389 - (384 + 917)) > (4571 - (128 + 569))) and v36.Fireblood:IsCastable() and v161 and v53) then
			if (((5875 - (1407 + 136)) == (6219 - (687 + 1200))) and v19(v36.Fireblood, nil)) then
				return "Cast Fireblood";
			end
		end
		if (((5709 - (556 + 1154)) >= (10202 - 7302)) and v36.AncestralCall:IsCastable() and v161 and v53) then
			if (v19(v36.AncestralCall, nil) or ((2620 - (9 + 86)) > (4485 - (275 + 146)))) then
				return "Cast Ancestral Call";
			end
		end
		if (((711 + 3660) == (4435 - (29 + 35))) and v36.ThistleTea:IsReady()) then
			if ((((v36.SymbolsofDeath:CooldownRemains() >= (13 - 10)) or v13:BuffUp(v36.SymbolsofDeath)) and not v13:BuffUp(v36.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (298 - 198)) and ((v13:ComboPointsDeficit() >= (8 - 6)) or (v74 >= (2 + 1)))) or ((v36.ThistleTea:ChargesFractional() >= (1014.75 - (53 + 959))) and v13:BuffUp(v36.ShadowDanceBuff)))) or ((v13:BuffRemains(v36.ShadowDanceBuff) >= (412 - (312 + 96))) and not v13:BuffUp(v36.ThistleTea) and (v74 >= (4 - 1))) or (not v13:BuffUp(v36.ThistleTea) and v10.BossFilteredFightRemains("<=", (291 - (147 + 138)) * v36.ThistleTea:Charges())) or ((1165 - (813 + 86)) > (4506 + 480))) then
				if (((3688 - 1697) >= (1417 - (18 + 474))) and v19(v36.ThistleTea, nil, nil)) then
					return "Thistle Tea";
				end
			end
		end
		return false;
	end
	local function v109(v162)
		local v163 = 0 + 0;
		while true do
			if (((1485 - 1030) < (3139 - (860 + 226))) and ((304 - (121 + 182)) == v163)) then
				return false;
			end
			if ((v163 == (0 + 0)) or ((2066 - (988 + 252)) == (548 + 4303))) then
				if (((58 + 125) == (2153 - (49 + 1921))) and v41 and not (v33.IsSoloMode() and v13:IsTanking(v14))) then
					local v212 = 890 - (223 + 667);
					while true do
						if (((1211 - (51 + 1)) <= (3077 - 1289)) and (v212 == (0 - 0))) then
							if ((v43 and v36.Vanish:IsCastable()) or ((4632 - (146 + 979)) > (1219 + 3099))) then
								if ((((v84 > (606 - (311 + 294))) or (v13:BuffUp(v36.ShadowBlades) and v36.InvigoratingShadowdust:IsAvailable())) and not v93() and ((v36.Flagellation:CooldownRemains() >= (167 - 107)) or not v36.Flagellation:IsAvailable() or v10.BossFilteredFightRemains("<=", (13 + 17) * v36.Vanish:Charges())) and ((v36.SymbolsofDeath:CooldownRemains() > (1446 - (496 + 947))) or not v13:HasTier(1388 - (1233 + 125), 1 + 1)) and ((v36.SecretTechnique:CooldownRemains() >= (9 + 1)) or not v36.SecretTechnique:IsAvailable() or ((v36.Vanish:Charges() >= (1 + 1)) and v36.InvigoratingShadowdust:IsAvailable() and (v13:BuffUp(v36.TheRotten) or not v36.TheRotten:IsAvailable())))) or ((4720 - (963 + 682)) <= (2475 + 490))) then
									local v249 = 1504 - (504 + 1000);
									while true do
										if (((920 + 445) <= (1832 + 179)) and (v249 == (0 + 0))) then
											v76 = v104(v36.Vanish, v162);
											if (v76 or ((4093 - 1317) > (3055 + 520))) then
												return "Vanish Macro " .. v76;
											end
											break;
										end
									end
								end
							end
							if ((v53 and v51 and (v13:Energy() < (24 + 16)) and v36.Shadowmeld:IsCastable()) or ((2736 - (156 + 26)) == (2768 + 2036))) then
								if (((4031 - 1454) == (2741 - (149 + 15))) and v21(v36.Shadowmeld, v13:EnergyTimeToX(1000 - (890 + 70)))) then
									return "Pool for Shadowmeld";
								end
							end
							v212 = 118 - (39 + 78);
						end
						if ((v212 == (483 - (14 + 468))) or ((13 - 7) >= (5279 - 3390))) then
							if (((262 + 244) <= (1137 + 755)) and v53 and v36.Shadowmeld:IsCastable() and v70 and not v13:IsMoving() and (v13:EnergyPredicted() >= (9 + 31)) and (v13:EnergyDeficitPredicted() >= (5 + 5)) and not v93() and (v84 > (2 + 2))) then
								local v238 = 0 - 0;
								while true do
									if ((v238 == (0 + 0)) or ((7055 - 5047) > (56 + 2162))) then
										v76 = v104(v36.Shadowmeld, v162);
										if (((430 - (12 + 39)) <= (3859 + 288)) and v76) then
											return "Shadowmeld Macro " .. v76;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if ((v70 and v36.ShadowDance:IsCastable()) or ((13972 - 9458) <= (3593 - 2584))) then
					if (((v14:DebuffUp(v36.Rupture) or v36.InvigoratingShadowdust:IsAvailable()) and v98() and (not v36.TheFirstDance:IsAvailable() or (v84 >= (2 + 2)) or v13:BuffUp(v36.ShadowBlades)) and ((v94() and v93()) or ((v13:BuffUp(v36.ShadowBlades) or (v13:BuffUp(v36.SymbolsofDeath) and not v36.Sepsis:IsAvailable()) or ((v13:BuffRemains(v36.SymbolsofDeath) >= (3 + 1)) and not v13:HasTier(76 - 46, 2 + 0)) or (not v13:BuffUp(v36.SymbolsofDeath) and v13:HasTier(144 - 114, 1712 - (1596 + 114)))) and (v36.SecretTechnique:CooldownRemains() < ((26 - 16) + ((725 - (164 + 549)) * v26(not v36.InvigoratingShadowdust:IsAvailable() or v13:HasTier(1468 - (1059 + 379), 2 - 0)))))))) or ((1812 + 1684) == (201 + 991))) then
						local v228 = 392 - (145 + 247);
						while true do
							if (((0 + 0) == v228) or ((97 + 111) == (8772 - 5813))) then
								v76 = v104(v36.ShadowDance, v162);
								if (((821 + 3456) >= (1131 + 182)) and v76) then
									return "ShadowDance Macro 1 " .. v76;
								end
								break;
							end
						end
					end
				end
				v163 = 1 - 0;
			end
		end
	end
	local function v110(v164)
		local v165 = 720 - (254 + 466);
		local v166;
		while true do
			if (((3147 - (544 + 16)) < (10086 - 6912)) and (v165 == (628 - (294 + 334)))) then
				v166 = not v164 or (v13:EnergyPredicted() >= v164);
				if ((v40 and v36.ShurikenStorm:IsCastable() and (v74 >= ((255 - (236 + 17)) + v18((v36.Gloomblade:IsAvailable() and (v13:BuffRemains(v36.LingeringShadowBuff) >= (3 + 3))) or v13:BuffUp(v36.PerforatedVeinsBuff))))) or ((3208 + 912) <= (8277 - 6079))) then
					if ((v166 and v19(v36.ShurikenStorm)) or ((7556 - 5960) == (442 + 416))) then
						return "Cast Shuriken Storm";
					end
					v87(v36.ShurikenStorm, v164);
				end
				v165 = 1 + 0;
			end
			if (((4014 - (413 + 381)) == (136 + 3084)) and (v165 == (1 - 0))) then
				if (v70 or ((3641 - 2239) > (5590 - (582 + 1388)))) then
					if (((4385 - 1811) == (1843 + 731)) and v36.Gloomblade:IsCastable()) then
						local v229 = 364 - (326 + 38);
						while true do
							if (((5318 - 3520) < (3935 - 1178)) and ((620 - (47 + 573)) == v229)) then
								if ((v166 and v19(v36.Gloomblade)) or ((133 + 244) > (11059 - 8455))) then
									return "Cast Gloomblade";
								end
								v87(v36.Gloomblade, v164);
								break;
							end
						end
					elseif (((921 - 353) < (2575 - (1269 + 395))) and v36.Backstab:IsCastable()) then
						local v235 = 492 - (76 + 416);
						while true do
							if (((3728 - (319 + 124)) < (9664 - 5436)) and (v235 == (1007 - (564 + 443)))) then
								if (((10840 - 6924) > (3786 - (337 + 121))) and v166 and v19(v36.Backstab)) then
									return "Cast Backstab";
								end
								v87(v36.Backstab, v164);
								break;
							end
						end
					end
				end
				return false;
			end
		end
	end
	local function v111()
		if (((7325 - 4825) < (12787 - 8948)) and v57 and v42 and v36.Shiv:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v33.UnitHasEnrageBuff(v14)) then
			if (((2418 - (1261 + 650)) == (215 + 292)) and v24(v36.Shiv, not IsInMeleeRange)) then
				return "shiv dispel enrage";
			end
		end
		if (((382 - 142) <= (4982 - (772 + 1045))) and v37.Healthstone:IsReady() and v58 and (v13:HealthPercentage() <= v59)) then
			if (((118 + 716) >= (949 - (102 + 42))) and v24(v38.Healthstone, nil, nil, true)) then
				return "healthstone defensive 3";
			end
		end
		if ((v54 and (v13:HealthPercentage() <= v56)) or ((5656 - (1524 + 320)) < (3586 - (1049 + 221)))) then
			local v179 = 156 - (18 + 138);
			while true do
				if ((v179 == (0 - 0)) or ((3754 - (67 + 1035)) <= (1881 - (136 + 212)))) then
					if ((v55 == "Refreshing Healing Potion") or ((15289 - 11691) < (1170 + 290))) then
						if (v37.RefreshingHealingPotion:IsReady() or ((3795 + 321) < (2796 - (240 + 1364)))) then
							if (v24(v38.RefreshingHealingPotion, nil, nil, true) or ((4459 - (1050 + 32)) <= (3224 - 2321))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((2352 + 1624) >= (1494 - (331 + 724))) and (v55 == "Dreamwalker's Healing Potion")) then
						if (((303 + 3449) == (4396 - (269 + 375))) and v37.DreamwalkersHealingPotion:IsReady()) then
							if (((4771 - (267 + 458)) > (839 + 1856)) and v24(v38.RefreshingHealingPotion, nil, nil, true)) then
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
		if ((not v13:AffectingCombat() and v39) or ((6817 - 3272) == (4015 - (667 + 151)))) then
			local v180 = 1497 - (1410 + 87);
			while true do
				if (((4291 - (1504 + 393)) > (1008 - 635)) and (v180 == (0 - 0))) then
					if (((4951 - (461 + 335)) <= (541 + 3691)) and v36.Stealth:IsCastable() and (v65 == "Always")) then
						local v230 = 1761 - (1730 + 31);
						while true do
							if ((v230 == (1667 - (728 + 939))) or ((12682 - 9101) == (7044 - 3571))) then
								v76 = v34.Stealth(v34.StealthSpell());
								if (((11444 - 6449) > (4416 - (138 + 930))) and v76) then
									return v76;
								end
								break;
							end
						end
					elseif ((v36.Stealth:IsCastable() and (v65 == "Distance") and v14:IsInRange(v66)) or ((690 + 64) > (2912 + 812))) then
						local v236 = 0 + 0;
						while true do
							if (((886 - 669) >= (1823 - (459 + 1307))) and (v236 == (1870 - (474 + 1396)))) then
								v76 = v34.Stealth(v34.StealthSpell());
								if (v76 or ((3614 - 1544) >= (3784 + 253))) then
									return v76;
								end
								break;
							end
						end
					end
					if (((9 + 2696) == (7748 - 5043)) and not v13:BuffUp(v36.ShadowDanceBuff) and not v13:BuffUp(v34.VanishBuffSpell())) then
						local v231 = 0 + 0;
						while true do
							if (((203 - 142) == (265 - 204)) and (v231 == (591 - (562 + 29)))) then
								v76 = v34.Stealth(v34.StealthSpell());
								if (v76 or ((596 + 103) >= (2715 - (374 + 1045)))) then
									return v76;
								end
								break;
							end
						end
					end
					v180 = 1 + 0;
				end
				if ((v180 == (2 - 1)) or ((2421 - (448 + 190)) >= (1168 + 2448))) then
					if ((v33.TargetIsValid() and (v14:IsSpellInRange(v36.Shadowstrike) or v70)) or ((1767 + 2146) > (2950 + 1577))) then
						if (((16824 - 12448) > (2538 - 1721)) and v13:StealthUp(true, true)) then
							local v237 = 1494 - (1307 + 187);
							while true do
								if (((19276 - 14415) > (1928 - 1104)) and ((0 - 0) == v237)) then
									v77 = v103(true);
									if (v77 or ((2066 - (232 + 451)) >= (2035 + 96))) then
										if (((type(v77) == "table") and (#v77 > (1 + 0))) or ((2440 - (510 + 54)) >= (5119 - 2578))) then
											if (((1818 - (13 + 23)) <= (7352 - 3580)) and v25(nil, unpack(v77))) then
												return "Stealthed Macro Cast or Pool (OOC): " .. v77[1 - 0]:Name();
											end
										elseif (v21(v77) or ((8539 - 3839) < (1901 - (830 + 258)))) then
											return "Stealthed Cast or Pool (OOC): " .. v77:Name();
										end
									end
									break;
								end
							end
						elseif (((11284 - 8085) < (2534 + 1516)) and (v83 >= (5 + 0))) then
							local v248 = 1441 - (860 + 581);
							while true do
								if (((0 - 0) == v248) or ((3930 + 1021) < (4671 - (237 + 4)))) then
									v76 = v102();
									if (((225 - 129) == (242 - 146)) and v76) then
										return v76 .. " (OOC)";
									end
									break;
								end
							end
						elseif (v36.Backstab:IsCastable() or ((5192 - 2453) > (3281 + 727))) then
							if (v19(v36.Backstab) or ((14 + 9) == (4281 - 3147))) then
								return "Cast Backstab (OOC)";
							end
						end
					end
					return;
				end
			end
		end
	end
	local v113 = {{v36.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v36.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v83 > (0 + 0);
	end},{v36.CheapShot,"Cast Cheap Shot (Interrupt)",function()
		return v13:StealthUp(true, true);
	end}};
	local function v114()
		local v167 = 1973 - (1227 + 746);
		while true do
			if ((v167 == (5 - 3)) or ((4997 - 2304) >= (4605 - (415 + 79)))) then
				v43 = EpicSettings.Toggles['vanish'];
				v44 = EpicSettings.Toggles['funnel'];
				break;
			end
			if ((v167 == (1 + 0)) or ((4807 - (142 + 349)) <= (920 + 1226))) then
				v41 = EpicSettings.Toggles['cds'];
				v42 = EpicSettings.Toggles['dispel'];
				v167 = 2 - 0;
			end
			if ((v167 == (0 + 0)) or ((2499 + 1047) <= (7649 - 4840))) then
				v39 = EpicSettings.Toggles['ooc'];
				v40 = EpicSettings.Toggles['aoe'];
				v167 = 1865 - (1710 + 154);
			end
		end
	end
	local function v115()
		local v168 = 318 - (200 + 118);
		while true do
			if (((1944 + 2960) > (3786 - 1620)) and ((1 - 0) == v168)) then
				v48 = EpicSettings.Settings['StealthMacroVanish'];
				v49 = EpicSettings.Settings['StealthMacroShadowmeld'];
				v50 = EpicSettings.Settings['StealthMacroShadowDance'];
				v168 = 2 + 0;
			end
			if (((108 + 1) >= (49 + 41)) and (v168 == (1 + 5))) then
				v63 = EpicSettings.Settings['AutoFocusTank'];
				v64 = EpicSettings.Settings['AutoTricksTank'];
				v65 = EpicSettings.Settings['UsageStealthOOC'];
				v168 = 14 - 7;
			end
			if (((6228 - (363 + 887)) > (5072 - 2167)) and (v168 == (0 - 0))) then
				v45 = EpicSettings.Settings['BurnShadowDance'];
				v46 = EpicSettings.Settings['UsePriorityRotation'];
				v47 = EpicSettings.Settings['RangedMultiDoT'];
				v168 = 1 + 0;
			end
			if ((v168 == (6 - 3)) or ((2068 + 958) <= (3944 - (674 + 990)))) then
				v54 = EpicSettings.Settings['UseHealingPotion'];
				v55 = EpicSettings.Settings['HealingPotionName'];
				v56 = EpicSettings.Settings['HealingPotionHP'] or (1 + 0);
				v168 = 2 + 2;
			end
			if ((v168 == (11 - 4)) or ((2708 - (507 + 548)) <= (1945 - (289 + 548)))) then
				v66 = EpicSettings.Settings['StealthRange'] or (1818 - (821 + 997));
				break;
			end
			if (((3164 - (195 + 60)) > (702 + 1907)) and (v168 == (1505 - (251 + 1250)))) then
				v57 = EpicSettings.Settings['DispelBuffs'];
				v58 = EpicSettings.Settings['UseHealthstone'];
				v59 = EpicSettings.Settings['HealthstoneHP'] or (2 - 1);
				v168 = 4 + 1;
			end
			if (((1789 - (809 + 223)) > (282 - 88)) and (v168 == (14 - 9))) then
				v60 = EpicSettings.Settings['InterruptWithStun'];
				v61 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v62 = EpicSettings.Settings['InterruptThreshold'];
				v168 = 19 - 13;
			end
			if (((2 + 0) == v168) or ((17 + 14) >= (2015 - (14 + 603)))) then
				v51 = EpicSettings.Settings['PoolForShadowmeld'];
				v52 = EpicSettings.Settings['EviscerateDMGOffset'] or (130 - (118 + 11));
				v53 = EpicSettings.Settings['UseRacials'];
				v168 = 1 + 2;
			end
		end
	end
	local function v116()
		local v169 = 0 + 0;
		while true do
			if (((9313 - 6117) <= (5821 - (551 + 398))) and (v169 == (4 + 1))) then
				v76 = v34.CrimsonVial();
				if (((1184 + 2142) == (2703 + 623)) and v76) then
					return v76;
				end
				v76 = v34.Feint();
				if (((5329 - 3896) <= (8935 - 5057)) and v76) then
					return v76;
				end
				v169 = 2 + 4;
			end
			if ((v169 == (11 - 8)) or ((438 + 1145) == (1824 - (40 + 49)))) then
				v84 = v13:ComboPointsDeficit();
				v86 = v90();
				v85 = v13:EnergyMax() - v92();
				if ((v13:BuffUp(v36.ShurikenTornado, nil, true) and (v83 < v34.CPMaxSpend())) or ((11352 - 8371) == (2840 - (99 + 391)))) then
					local v213 = 0 + 0;
					local v214;
					while true do
						if ((v213 == (0 - 0)) or ((11059 - 6593) <= (481 + 12))) then
							v214 = v34.TimeToNextTornado();
							if ((v214 <= v13:GCDRemains()) or (v32(v13:GCDRemains() - v214) < (0.25 - 0)) or ((4151 - (1032 + 572)) <= (2404 - (203 + 214)))) then
								local v239 = 1817 - (568 + 1249);
								local v240;
								while true do
									if (((2317 + 644) > (6581 - 3841)) and (v239 == (3 - 2))) then
										v84 = v31(v84 - v240, 1306 - (913 + 393));
										if (((10437 - 6741) >= (5103 - 1491)) and (v82 < v34.CPMaxSpend())) then
											v82 = v83;
										end
										break;
									end
									if ((v239 == (410 - (269 + 141))) or ((6605 - 3635) == (3859 - (362 + 1619)))) then
										v240 = v74 + v26(v13:BuffUp(v36.ShadowBlades));
										v83 = v30(v83 + v240, v34.CPMaxSpend());
										v239 = 1626 - (950 + 675);
									end
								end
							end
							break;
						end
					end
				end
				v169 = 2 + 2;
			end
			if ((v169 == (1185 - (216 + 963))) or ((4980 - (485 + 802)) < (2536 - (432 + 127)))) then
				v34.Poisons();
				v76 = v112();
				if (v76 or ((2003 - (1065 + 8)) > (1168 + 933))) then
					return v76;
				end
				if (((5754 - (635 + 966)) > (2219 + 867)) and v33.TargetIsValid()) then
					local v215 = 42 - (5 + 37);
					local v216;
					while true do
						if ((v215 == (9 - 5)) or ((1937 + 2717) <= (6410 - 2360))) then
							if ((v84 <= (1 + 0)) or (v10.BossFilteredFightRemains("<=", 1 - 0) and (v82 >= (11 - 8))) or ((4906 - 2304) < (3576 - 2080))) then
								local v241 = 0 + 0;
								while true do
									if ((v241 == (529 - (318 + 211))) or ((5018 - 3998) > (3875 - (963 + 624)))) then
										v76 = v102();
										if (((141 + 187) == (1174 - (518 + 328))) and v76) then
											return "Finish: " .. v76;
										end
										break;
									end
								end
							end
							if (((3522 - 2011) < (6086 - 2278)) and (v74 >= (321 - (301 + 16))) and (v82 >= (11 - 7))) then
								local v242 = 0 - 0;
								while true do
									if ((v242 == (0 - 0)) or ((2274 + 236) > (2793 + 2126))) then
										v76 = v102();
										if (((10168 - 5405) == (2866 + 1897)) and v76) then
											return "Finish: " .. v76;
										end
										break;
									end
								end
							end
							if (((394 + 3743) > (5875 - 4027)) and v79) then
								v87(v79);
							end
							v76 = v110(v85);
							v215 = 2 + 3;
						end
						if (((3455 - (829 + 190)) <= (11181 - 8047)) and (v215 == (0 - 0))) then
							v76 = v105();
							if (((5145 - 1422) == (9248 - 5525)) and ShoulReturn) then
								return "Interrupts " .. v76;
							end
							v76 = v111();
							if (ShoulReturn or ((959 + 3087) >= (1410 + 2906))) then
								return v76;
							end
							v215 = 2 - 1;
						end
						if ((v215 == (1 + 0)) or ((2621 - (520 + 93)) < (2205 - (259 + 17)))) then
							v76 = v108();
							if (((138 + 2246) > (639 + 1136)) and v76) then
								return "CDs: " .. v76;
							end
							v76 = v106();
							if (v76 or ((15380 - 10837) <= (4967 - (396 + 195)))) then
								return "Trinkets";
							end
							v215 = 5 - 3;
						end
						if (((2489 - (440 + 1321)) == (2557 - (1059 + 770))) and (v215 == (13 - 10))) then
							v216 = nil;
							if (not v36.Vigor:IsAvailable() or v36.Shadowcraft:IsAvailable() or ((1621 - (424 + 121)) > (852 + 3819))) then
								v216 = v13:EnergyDeficitPredicted() <= v92();
							else
								v216 = v13:EnergyPredicted() >= v92();
							end
							if (((3198 - (641 + 706)) >= (150 + 228)) and (v216 or v36.InvigoratingShadowdust:IsAvailable())) then
								local v243 = 440 - (249 + 191);
								while true do
									if (((0 - 0) == v243) or ((870 + 1078) >= (13396 - 9920))) then
										v76 = v109(v85);
										if (((5221 - (183 + 244)) >= (41 + 792)) and v76) then
											return "Stealth CDs: " .. v76;
										end
										break;
									end
								end
							end
							if (((4820 - (434 + 296)) == (13051 - 8961)) and (v82 >= v34.CPMaxSpend())) then
								local v244 = 512 - (169 + 343);
								while true do
									if (((0 + 0) == v244) or ((6612 - 2854) == (7331 - 4833))) then
										v76 = v102();
										if (v76 or ((2190 + 483) < (4466 - 2891))) then
											return "Finish: " .. v76;
										end
										break;
									end
								end
							end
							v215 = 1127 - (651 + 472);
						end
						if ((v215 == (2 + 0)) or ((1606 + 2115) <= (1775 - 320))) then
							v76 = v107();
							if (((1417 - (397 + 86)) < (3146 - (423 + 453))) and v76) then
								return "DPS Potion";
							end
							if ((v36.SliceandDice:IsCastable() and (v74 < v34.CPMaxSpend()) and (v13:BuffRemains(v36.SliceandDice) < v13:GCD()) and v10.BossFilteredFightRemains(">", 1 + 5) and (v83 >= (1 + 3))) or ((1408 + 204) == (1002 + 253))) then
								local v245 = 0 + 0;
								while true do
									if (((1190 - (50 + 1140)) == v245) or ((3762 + 590) < (2484 + 1722))) then
										if ((v36.SliceandDice:IsReady() and v19(v36.SliceandDice)) or ((178 + 2682) <= (259 - 78))) then
											return "Cast Slice and Dice (Low Duration)";
										end
										v88(v36.SliceandDice);
										break;
									end
								end
							end
							if (((2332 + 890) >= (2123 - (157 + 439))) and v13:StealthUp(true, true)) then
								local v246 = 0 - 0;
								while true do
									if (((5000 - 3495) <= (6273 - 4152)) and (v246 == (918 - (782 + 136)))) then
										v77 = v103(true);
										if (((1599 - (112 + 743)) == (1915 - (1026 + 145))) and v77) then
											if (((type(v77) == "table") and (#v77 > (1 + 0))) or ((2697 - (493 + 225)) >= (10424 - 7588))) then
												if (((1115 + 718) <= (7153 - 4485)) and v25(nil, unpack(v77))) then
													return "Stealthed Macro " .. v77[1 + 0]:Name() .. "|" .. v77[5 - 3]:Name();
												end
											elseif (((1074 + 2612) == (6157 - 2471)) and v13:BuffUp(v36.ShurikenTornado) and (v83 ~= v13:ComboPoints()) and ((v77 == v36.BlackPowder) or (v77 == v36.Eviscerate) or (v77 == v36.Rupture) or (v77 == v36.SliceandDice))) then
												if (((5062 - (210 + 1385)) > (2166 - (1201 + 488))) and v25(nil, v36.ShurikenTornado, v77)) then
													return "Stealthed Tornado Cast  " .. v77:Name();
												end
											elseif ((type(v77) ~= "boolean") or ((2038 + 1250) >= (6297 - 2756))) then
												if (v21(v77) or ((6378 - 2821) == (5125 - (352 + 233)))) then
													return "Stealthed Cast " .. v77:Name();
												end
											end
										end
										v246 = 2 - 1;
									end
									if ((v246 == (1 + 0)) or ((742 - 481) > (1841 - (489 + 85)))) then
										v19(v36.PoolEnergy);
										return "Stealthed Pooling";
									end
								end
							end
							v215 = 1504 - (277 + 1224);
						end
						if (((2765 - (663 + 830)) < (3389 + 469)) and (v215 == (12 - 7))) then
							if (((4539 - (461 + 414)) == (615 + 3049)) and v76) then
								return "Build: " .. v76;
							end
							if (((777 + 1164) >= (43 + 407)) and v77 and v70) then
								if (((type(v77) == "table") and (#v77 > (1 + 0))) or ((4896 - (172 + 78)) < (522 - 198))) then
									if (((1411 + 2422) == (5530 - 1697)) and v25(v13:EnergyTimeToX(v78), unpack(v77))) then
										return "Macro pool towards " .. v77[1 + 0]:Name() .. " at " .. v78;
									end
								elseif (v77:IsCastable() or ((415 + 825) > (5646 - 2276))) then
									local v250 = 0 - 0;
									while true do
										if ((v250 == (0 + 0)) or ((1372 + 1109) == (1667 + 3015))) then
											v78 = v31(v78, v77:Cost());
											if (((18816 - 14089) >= (484 - 276)) and v21(v77, v13:EnergyTimeToX(v78))) then
												return "Pool towards: " .. v77:Name() .. " at " .. v78;
											end
											break;
										end
									end
								end
							end
							if (((86 + 194) < (2199 + 1652)) and v36.ShurikenToss:IsCastable() and v14:IsInRange(477 - (133 + 314)) and not v71 and not v13:StealthUp(true, true) and not v13:BuffUp(v36.Sprint) and (v13:EnergyDeficitPredicted() < (4 + 16)) and ((v84 >= (214 - (199 + 14))) or (v13:EnergyTimeToMax() <= (3.2 - 2)))) then
								if (v21(v36.ShurikenToss) or ((4556 - (647 + 902)) > (9603 - 6409))) then
									return "Cast Shuriken Toss";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v169 == (234 - (85 + 148))) or ((3425 - (426 + 863)) >= (13787 - 10841))) then
				v78 = 1654 - (873 + 781);
				v68 = (v36.AcrobaticStrikes:IsAvailable() and (10 - 2)) or (13 - 8);
				v69 = (v36.AcrobaticStrikes:IsAvailable() and (6 + 7)) or (36 - 26);
				v70 = v14:IsInMeleeRange(v68);
				v169 = 2 - 0;
			end
			if (((6428 - 4263) <= (4468 - (414 + 1533))) and (v169 == (0 + 0))) then
				v115();
				v114();
				v77 = nil;
				v79 = nil;
				v169 = 556 - (443 + 112);
			end
			if (((4340 - (888 + 591)) > (1707 - 1046)) and (v169 == (1 + 1))) then
				v71 = v14:IsInMeleeRange(v69);
				if (((17042 - 12517) > (1765 + 2754)) and v40) then
					local v217 = 0 + 0;
					while true do
						if (((340 + 2838) > (1851 - 879)) and (v217 == (1 - 0))) then
							v74 = #v73;
							v75 = v13:GetEnemiesInMeleeRange(v68);
							break;
						end
						if (((6444 - (136 + 1542)) == (15628 - 10862)) and (v217 == (0 + 0))) then
							v72 = v13:GetEnemiesInRange(47 - 17);
							v73 = v13:GetEnemiesInMeleeRange(v69);
							v217 = 1 + 0;
						end
					end
				else
					v72 = {};
					v73 = {};
					v74 = 487 - (68 + 418);
					v75 = {};
				end
				v83 = v13:ComboPoints();
				v82 = v34.EffectiveComboPoints(v83);
				v169 = 8 - 5;
			end
			if (((6 - 2) == v169) or ((2370 + 375) > (4220 - (770 + 322)))) then
				v80 = (1 + 3 + (v82 * (2 + 2))) * (0.3 + 0);
				v81 = v36.Eviscerate:Damage() * v52;
				if ((not v13:AffectingCombat() and v63) or ((1636 - 492) >= (8930 - 4324))) then
					local v218 = 0 - 0;
					local v219;
					while true do
						if (((12278 - 8940) >= (155 + 122)) and (v218 == (0 - 0))) then
							v219 = v33.FocusUnit(false, nil, nil, "TANK", 10 + 10);
							if (((1601 + 1009) > (2007 + 553)) and v219) then
								return v219;
							end
							break;
						end
					end
				end
				if ((v23 and v64 and (v33.UnitGroupRole(v23) == "TANK") and v36.TricksoftheTrade:IsCastable()) or ((4495 - 3301) > (4281 - 1198))) then
					if (((310 + 606) >= (3440 - 2693)) and v24(v38.TricksoftheTradeFocus)) then
						return "tricks of the trade tank";
					end
				end
				v169 = 16 - 11;
			end
		end
	end
	local function v117()
		local v170 = 0 + 0;
		while true do
			if ((v170 == (0 - 0)) or ((3275 - (762 + 69)) > (9565 - 6611))) then
				v10.Print("Subtlety Rogue by Epic BoomK");
				EpicSettings.SetupVersion("Subtlety Rogue  X v 10.2.5.03 By BoomK");
				break;
			end
		end
	end
	v10.SetAPL(225 + 36, v116, v117);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

