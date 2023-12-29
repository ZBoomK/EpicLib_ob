local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((2938 - 1520) < (3153 + 1262)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Rogue_Assassination.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Utils;
	local v12 = v9.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v9.Spell;
	local v16 = v9.MultiSpell;
	local v17 = v9.Cast;
	local v18 = v9.CastCycle;
	local v19 = v12.MouseOver;
	local v20 = v9.Item;
	local v21 = v9.Macro;
	local v22 = v9.Press;
	local v23 = v9.Commons.Everyone.num;
	local v24 = v9.Commons.Everyone.bool;
	local v25 = math.min;
	local v26 = math.abs;
	local v27 = math.max;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31 = v9.Press;
	local v32 = pairs;
	local v33 = math.floor;
	local v34;
	local v35;
	local v36;
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
	local function v74()
		local v138 = 739 - (396 + 343);
		while true do
			if (((193 + 1986) == (3656 - (29 + 1448))) and (v138 == (1392 - (135 + 1254)))) then
				v57 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v58 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v59 = EpicSettings.Settings['ColdBloodOffGCD'];
				v60 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v61 = EpicSettings.Settings['CrimsonVialHP'] or (3 - 2);
				v62 = EpicSettings.Settings['FeintHP'] or (4 - 3);
				v138 = 3 + 1;
			end
			if (((6367 - (389 + 1138)) == (5414 - (102 + 472))) and (v138 == (2 + 0))) then
				v48 = EpicSettings.Settings['UsePriorityRotation'];
				v52 = EpicSettings.Settings['STMfDAsDPSCD'];
				v53 = EpicSettings.Settings['KidneyShotInterrupt'];
				v54 = EpicSettings.Settings['RacialsGCD'];
				v55 = EpicSettings.Settings['RacialsOffGCD'];
				v56 = EpicSettings.Settings['VanishOffGCD'];
				v138 = 2 + 1;
			end
			if (((920 + 66) == (2531 - (320 + 1225))) and (v138 == (8 - 3))) then
				v69 = EpicSettings.Settings['KingsbaneGCD'];
				v70 = EpicSettings.Settings['ShivGCD'];
				v71 = EpicSettings.Settings['DeathmarkOffGCD'];
				v73 = EpicSettings.Settings['IndiscriminateCarnageOffGCD'];
				v72 = EpicSettings.Settings['KickOffGCD'];
				break;
			end
			if ((v138 == (0 + 0)) or ((2045 - (157 + 1307)) > (5471 - (821 + 1038)))) then
				v34 = EpicSettings.Settings['UseRacials'];
				v36 = EpicSettings.Settings['UseHealingPotion'];
				v37 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v38 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v39 = EpicSettings.Settings['UseHealthstone'];
				v40 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v138 = 1 + 0;
			end
			if (((3301 - 1969) < (6002 - (834 + 192))) and (v138 == (1 + 3))) then
				v63 = EpicSettings.Settings['StealthOOC'];
				v64 = EpicSettings.Settings['EnvenomDMGOffset'] or (1 + 0);
				v65 = EpicSettings.Settings['MutilateDMGOffset'] or (1 + 0);
				v66 = EpicSettings.Settings['AlwaysSuggestGarrote'];
				v67 = EpicSettings.Settings['PotionTypeSelected'];
				v68 = EpicSettings.Settings['ExsanguinateGCD'];
				v138 = 7 - 2;
			end
			if (((4932 - (300 + 4)) == (1236 + 3392)) and (v138 == (2 - 1))) then
				v41 = EpicSettings.Settings['InterruptWithStun'] or (362 - (112 + 250));
				v42 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v43 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v45 = EpicSettings.Settings['PoisonRefresh'];
				v46 = EpicSettings.Settings['PoisonRefreshCombat'];
				v47 = EpicSettings.Settings['RangedMultiDoT'];
				v138 = 2 + 0;
			end
		end
	end
	local v75 = v9.Commons.Everyone;
	local v76 = v9.Commons.Rogue;
	local v77 = v15.Rogue.Assassination;
	local v78 = v21.Rogue.Assassination;
	local v79 = v20.Rogue.Assassination;
	local v80 = {v79.AlgetharPuzzleBox,v79.AshesoftheEmbersoul,v79.WitherbarksBranch};
	local v81, v82, v83, v84;
	local v85, v86, v87, v88;
	local v89;
	local v90, v91 = (2 + 0) * v13:SpellHaste(), (1415 - (1001 + 413)) * v13:SpellHaste();
	local v92, v93;
	local v94, v95, v96, v97, v98, v99, v100;
	local v101;
	local v102, v103, v104, v105, v106, v107, v108, v109;
	local v110 = 0 - 0;
	local v111 = v13:GetEquipment();
	local v112 = (v111[895 - (244 + 638)] and v20(v111[706 - (627 + 66)])) or v20(0 - 0);
	local v113 = (v111[616 - (512 + 90)] and v20(v111[1920 - (1665 + 241)])) or v20(717 - (373 + 344));
	local function v114()
		if ((v112:HasStatAnyDps() and (not v113:HasStatAnyDps() or (v112:Cooldown() >= v113:Cooldown()))) or ((25 + 29) == (105 + 290))) then
			v110 = 2 - 1;
		elseif (((138 - 56) == (1181 - (35 + 1064))) and v113:HasStatAnyDps() and (not v112:HasStatAnyDps() or (v113:Cooldown() > v112:Cooldown()))) then
			v110 = 2 + 0;
		else
			v110 = 0 - 0;
		end
	end
	v114();
	v9:RegisterForEvent(function()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (1237 - (298 + 938))) or ((1840 - (233 + 1026)) < (1948 - (636 + 1030)))) then
				v113 = (v111[8 + 6] and v20(v111[14 + 0])) or v20(0 + 0);
				v114();
				break;
			end
			if ((v139 == (0 + 0)) or ((4830 - (55 + 166)) < (484 + 2011))) then
				v111 = v13:GetEquipment();
				v112 = (v111[2 + 11] and v20(v111[49 - 36])) or v20(297 - (36 + 261));
				v139 = 1 - 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v115 = {{v77.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v77.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v92 > (685 - (314 + 371));
	end}};
	v77.Envenom:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v92 * (0.22 - 0) * (969 - (478 + 490)) * ((v14:DebuffUp(v77.ShivDebuff) and (1.3 + 0)) or (1173 - (786 + 386))) * ((v77.DeeperStratagem:IsAvailable() and (3.05 - 2)) or (1380 - (1055 + 324))) * ((1341 - (1093 + 247)) + (v13:MasteryPct() / (89 + 11))) * (1 + 0 + (v13:VersatilityDmgPct() / (397 - 297)));
	end);
	v77.Mutilate:RegisterDamageFormula(function()
		return (v13:AttackPowerDamageMod() + v13:AttackPowerDamageMod(true)) * (0.485 - 0) * (2 - 1) * ((2 - 1) + (v13:VersatilityDmgPct() / (36 + 64)));
	end);
	local function v116()
		return v13:BuffRemains(v77.MasterAssassinBuff) == (38520 - 28521);
	end
	local function v117()
		local v140 = 0 - 0;
		while true do
			if (((869 + 283) == (2945 - 1793)) and (v140 == (688 - (364 + 324)))) then
				if (((5197 - 3301) <= (8211 - 4789)) and v116()) then
					return v13:GCDRemains() + 1 + 2;
				end
				return v13:BuffRemains(v77.MasterAssassinBuff);
			end
		end
	end
	local function v118()
		local v141 = 0 - 0;
		while true do
			if (((0 - 0) == v141) or ((3006 - 2016) > (2888 - (1249 + 19)))) then
				if (v13:BuffUp(v77.ImprovedGarroteAura) or ((792 + 85) > (18275 - 13580))) then
					return v13:GCDRemains() + (1089 - (686 + 400));
				end
				return v13:BuffRemains(v77.ImprovedGarroteBuff);
			end
		end
	end
	local function v119()
		local v142 = 0 + 0;
		while true do
			if (((2920 - (73 + 156)) >= (9 + 1842)) and (v142 == (811 - (721 + 90)))) then
				if (v13:BuffUp(v77.IndiscriminateCarnageAura) or ((34 + 2951) >= (15766 - 10910))) then
					return v13:GCDRemains() + (480 - (224 + 246));
				end
				return v13:BuffRemains(v77.IndiscriminateCarnageBuff);
			end
		end
	end
	local function v48()
		local v143 = 0 - 0;
		while true do
			if (((7872 - 3596) >= (217 + 978)) and ((0 + 0) == v143)) then
				if (((2374 + 858) <= (9324 - 4634)) and (v87 < (6 - 4))) then
					return false;
				elseif ((v48 == "Always") or ((1409 - (203 + 310)) >= (5139 - (1238 + 755)))) then
					return true;
				elseif (((214 + 2847) >= (4492 - (709 + 825))) and (v48 == "On Bosses") and v14:IsInBossList()) then
					return true;
				elseif (((5872 - 2685) >= (937 - 293)) and (v48 == "Auto")) then
					if (((1508 - (196 + 668)) <= (2779 - 2075)) and (v13:InstanceDifficulty() == (33 - 17)) and (v14:NPCID() == (139800 - (171 + 662)))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v120()
		local v144 = 93 - (4 + 89);
		while true do
			if (((3357 - 2399) > (345 + 602)) and (v144 == (0 - 0))) then
				if (((1762 + 2730) >= (4140 - (35 + 1451))) and (v14:DebuffUp(v77.Deathmark) or v14:DebuffUp(v77.Kingsbane) or v13:BuffUp(v77.ShadowDanceBuff) or v14:DebuffUp(v77.ShivDebuff) or (v77.ThistleTea:FullRechargeTime() < (1473 - (28 + 1425))) or (v13:EnergyPercentage() >= (2073 - (941 + 1052))) or (v13:HasTier(30 + 1, 1518 - (822 + 692)) and ((v13:BuffUp(v77.Envenom) and (v13:BuffRemains(v77.Envenom) <= (2 - 0))) or v9.BossFilteredFightRemains("<=", 43 + 47))))) then
					return true;
				end
				return false;
			end
		end
	end
	local function v121()
		if (((3739 - (45 + 252)) >= (1488 + 15)) and (v77.Deathmark:CooldownRemains() > v77.Sepsis:CooldownRemains()) and (v9.BossFightRemainsIsNotValid() or v9.BossFilteredFightRemains(">", v77.Deathmark:CooldownRemains()))) then
			return v77.Deathmark:CooldownRemains();
		end
		return v77.Sepsis:CooldownRemains();
	end
	local function v122()
		local v145 = 0 + 0;
		while true do
			if ((v145 == (0 - 0)) or ((3603 - (114 + 319)) <= (2101 - 637))) then
				if (not v77.ScentOfBlood:IsAvailable() or ((6146 - 1349) == (2798 + 1590))) then
					return true;
				end
				return v13:BuffStack(v77.ScentOfBloodBuff) >= v25(29 - 9, v77.ScentOfBlood:TalentRank() * (3 - 1) * v87);
			end
		end
	end
	local function v123(v146, v147, v148)
		local v148 = v148 or v147:PandemicThreshold();
		return v146:DebuffRefreshable(v147, v148);
	end
	local function v124(v149, v150, v151, v152)
		local v153 = 1963 - (556 + 1407);
		local v154;
		local v155;
		local v156;
		while true do
			if (((1757 - (741 + 465)) <= (1146 - (170 + 295))) and ((1 + 0) == v153)) then
				for v211, v212 in v32(v152) do
					if (((3011 + 266) > (1002 - 595)) and (v212:GUID() ~= v156) and v75.UnitIsCycleValid(v212, v155, -v212:DebuffRemains(v149)) and v150(v212)) then
						v154, v155 = v212, v212:TimeToDie();
					end
				end
				if (((3892 + 803) >= (908 + 507)) and v154) then
					CastLeftNameplate(v154, v149);
				elseif (v47 or ((1819 + 1393) <= (2174 - (957 + 273)))) then
					local v243 = 0 + 0;
					while true do
						if ((v243 == (1 + 0)) or ((11797 - 8701) <= (4738 - 2940))) then
							if (((10803 - 7266) == (17514 - 13977)) and v154) then
								CastLeftNameplate(v154, v149);
							end
							break;
						end
						if (((5617 - (389 + 1391)) >= (986 + 584)) and ((0 + 0) == v243)) then
							v154, v155 = nil, v151;
							for v260, v261 in v32(v86) do
								if (((v261:GUID() ~= v156) and v75.UnitIsCycleValid(v261, v155, -v261:DebuffRemains(v149)) and v150(v261)) or ((6716 - 3766) == (4763 - (783 + 168)))) then
									v154, v155 = v261, v261:TimeToDie();
								end
							end
							v243 = 3 - 2;
						end
					end
				end
				break;
			end
			if (((4646 + 77) >= (2629 - (309 + 2))) and ((0 - 0) == v153)) then
				v154, v155 = nil, v151;
				v156 = v14:GUID();
				v153 = 1213 - (1090 + 122);
			end
		end
	end
	local function v125(v157, v158, v159)
		local v160 = 0 + 0;
		local v161;
		local v162;
		local v163;
		local v164;
		while true do
			if ((v160 == (0 - 0)) or ((1388 + 639) > (3970 - (628 + 490)))) then
				v161 = v158(v14);
				if (((v157 == "first") and (v161 ~= (0 + 0))) or ((2812 - 1676) > (19728 - 15411))) then
					return v14;
				end
				v160 = 775 - (431 + 343);
			end
			if (((9588 - 4840) == (13735 - 8987)) and ((2 + 0) == v160)) then
				function v164(v213)
					for v214, v215 in v32(v213) do
						local v216 = v158(v215);
						if (((478 + 3258) <= (6435 - (556 + 1139))) and not v162 and (v157 == "first")) then
							if ((v216 ~= (15 - (6 + 9))) or ((621 + 2769) <= (1568 + 1492))) then
								v162, v163 = v215, v216;
							end
						elseif ((v157 == "min") or ((1168 - (28 + 141)) > (1044 + 1649))) then
							if (((570 - 107) < (426 + 175)) and (not v162 or (v216 < v163))) then
								v162, v163 = v215, v216;
							end
						elseif ((v157 == "max") or ((3500 - (486 + 831)) < (1787 - 1100))) then
							if (((16015 - 11466) == (860 + 3689)) and (not v162 or (v216 > v163))) then
								v162, v163 = v215, v216;
							end
						end
						if (((14772 - 10100) == (5935 - (668 + 595))) and v162 and (v216 == v163) and (v215:TimeToDie() > v162:TimeToDie())) then
							v162, v163 = v215, v216;
						end
					end
				end
				v164(v88);
				v160 = 3 + 0;
			end
			if ((v160 == (1 + 3)) or ((10002 - 6334) < (685 - (23 + 267)))) then
				if ((v162 and v159(v162)) or ((6110 - (1129 + 815)) == (842 - (371 + 16)))) then
					return v162;
				end
				return nil;
			end
			if ((v160 == (1751 - (1326 + 424))) or ((8425 - 3976) == (9731 - 7068))) then
				v162, v163 = nil, 118 - (88 + 30);
				v164 = nil;
				v160 = 773 - (720 + 51);
			end
			if ((v160 == (6 - 3)) or ((6053 - (421 + 1355)) < (4930 - 1941))) then
				if (v47 or ((428 + 442) >= (5232 - (286 + 797)))) then
					v164(v86);
				end
				if (((8086 - 5874) < (5271 - 2088)) and v162 and (v163 == v161) and v159(v14)) then
					return v14;
				end
				v160 = 443 - (397 + 42);
			end
		end
	end
	local function v126(v165, v166, v167)
		local v168 = 0 + 0;
		local v169;
		while true do
			if (((5446 - (24 + 776)) > (4608 - 1616)) and (v168 == (785 - (222 + 563)))) then
				v169 = v14:TimeToDie();
				if (((3159 - 1725) < (2237 + 869)) and not v9.BossFightRemainsIsNotValid()) then
					v169 = v9.BossFightRemains();
				elseif (((976 - (23 + 167)) < (4821 - (690 + 1108))) and (v169 < v167)) then
					return false;
				end
				v168 = 1 + 0;
			end
			if ((v168 == (1 + 0)) or ((3290 - (40 + 808)) < (13 + 61))) then
				if (((17341 - 12806) == (4335 + 200)) and (v33((v169 - v167) / v165) > v33(((v169 - v167) - v166) / v165))) then
					return true;
				end
				return false;
			end
		end
	end
	local function v127(v170)
		if (v170:DebuffUp(v77.SerratedBoneSpikeDebuff) or ((1592 + 1417) <= (1155 + 950))) then
			return 1000571 - (47 + 524);
		end
		return v170:TimeToDie();
	end
	local function v128(v171)
		return not v171:DebuffUp(v77.SerratedBoneSpikeDebuff);
	end
	local function v129()
		local v172 = 0 + 0;
		while true do
			if (((5002 - 3172) < (5485 - 1816)) and (v172 == (4 - 2))) then
				if ((v77.ArcaneTorrent:IsCastable() and (v13:EnergyDeficit() > (1741 - (1165 + 561)))) or ((43 + 1387) >= (11186 - 7574))) then
					if (((1024 + 1659) >= (2939 - (341 + 138))) and v9.Cast(v77.ArcaneTorrent, v34)) then
						return "Cast Arcane Torrent";
					end
				end
				if (v77.ArcanePulse:IsCastable() or ((487 + 1317) >= (6758 - 3483))) then
					if (v9.Cast(v77.ArcanePulse, v34) or ((1743 - (89 + 237)) > (11674 - 8045))) then
						return "Cast Arcane Pulse";
					end
				end
				v172 = 6 - 3;
			end
			if (((5676 - (581 + 300)) > (1622 - (855 + 365))) and ((9 - 5) == v172)) then
				return false;
			end
			if (((1572 + 3241) > (4800 - (1030 + 205))) and (v172 == (3 + 0))) then
				if (((3640 + 272) == (4198 - (156 + 130))) and v77.LightsJudgment:IsCastable()) then
					if (((6409 - 3588) <= (8129 - 3305)) and v9.Cast(v77.LightsJudgment, v34)) then
						return "Cast Lights Judgment";
					end
				end
				if (((3559 - 1821) <= (579 + 1616)) and v77.BagofTricks:IsCastable()) then
					if (((24 + 17) <= (3087 - (10 + 59))) and v9.Cast(v77.BagofTricks, v34)) then
						return "Cast Bag of Tricks";
					end
				end
				v172 = 2 + 2;
			end
			if (((10563 - 8418) <= (5267 - (671 + 492))) and (v172 == (1 + 0))) then
				if (((3904 - (369 + 846)) < (1283 + 3562)) and v77.Fireblood:IsCastable()) then
					if (v9.Cast(v77.Fireblood, v34) or ((1982 + 340) > (4567 - (1036 + 909)))) then
						return "Cast Fireblood";
					end
				end
				if (v77.AncestralCall:IsCastable() or ((3605 + 929) == (3494 - 1412))) then
					if ((not v77.Kingsbane:IsAvailable() and v14:DebuffUp(v77.ShivDebuff)) or (v14:DebuffUp(v77.Kingsbane) and (v14:DebuffRemains(v77.Kingsbane) < (211 - (11 + 192)))) or ((794 + 777) > (2042 - (135 + 40)))) then
						if (v9.Cast(v77.AncestralCall, v34) or ((6430 - 3776) >= (1806 + 1190))) then
							return "Cast Ancestral Call";
						end
					end
				end
				v172 = 4 - 2;
			end
			if (((5963 - 1985) > (2280 - (50 + 126))) and (v172 == (0 - 0))) then
				if (((663 + 2332) > (2954 - (1233 + 180))) and v77.BloodFury:IsCastable()) then
					if (((4218 - (522 + 447)) > (2374 - (107 + 1314))) and v9.Cast(v77.BloodFury, v34)) then
						return "Cast Blood Fury";
					end
				end
				if (v77.Berserking:IsCastable() or ((1519 + 1754) > (13934 - 9361))) then
					if (v9.Cast(v77.Berserking, v34) or ((1339 + 1812) < (2549 - 1265))) then
						return "Cast Berserking";
					end
				end
				v172 = 3 - 2;
			end
		end
	end
	local function v130()
		local v173 = 1910 - (716 + 1194);
		while true do
			if ((v173 == (0 + 0)) or ((199 + 1651) == (2032 - (74 + 429)))) then
				if (((1583 - 762) < (1053 + 1070)) and v77.ShadowDance:IsCastable() and not v77.Kingsbane:IsAvailable()) then
					local v217 = 0 - 0;
					while true do
						if (((639 + 263) < (7167 - 4842)) and (v217 == (0 - 0))) then
							if (((1291 - (279 + 154)) <= (3740 - (454 + 324))) and v77.ImprovedGarrote:IsAvailable() and v77.Garrote:CooldownUp() and ((v14:PMultiplier(v77.Garrote) <= (1 + 0)) or v123(v14, v77.Garrote)) and (v77.Deathmark:AnyDebuffUp() or (v77.Deathmark:CooldownRemains() < (29 - (12 + 5))) or (v77.Deathmark:CooldownRemains() > (33 + 27))) and (v93 >= math.min(v87, 10 - 6))) then
								local v252 = 0 + 0;
								while true do
									if ((v252 == (1093 - (277 + 816))) or ((16861 - 12915) < (2471 - (1058 + 125)))) then
										if ((v13:EnergyPredicted() < (9 + 36)) or ((4217 - (815 + 160)) == (2432 - 1865))) then
											if (v22(v77.PoolEnergy) or ((2010 - 1163) >= (302 + 961))) then
												return "Pool for Shadow Dance (Garrote)";
											end
										end
										if (v22(v77.ShadowDance, v57) or ((6585 - 4332) == (3749 - (41 + 1857)))) then
											return "Cast Shadow Dance (Garrote)";
										end
										break;
									end
								end
							end
							if ((not v77.ImprovedGarrote:IsAvailable() and v77.MasterAssassin:IsAvailable() and not v123(v14, v77.Rupture) and (v14:DebuffRemains(v77.Garrote) > (1896 - (1222 + 671))) and (v14:DebuffUp(v77.Deathmark) or (v77.Deathmark:CooldownRemains() > (155 - 95))) and (v14:DebuffUp(v77.ShivDebuff) or (v14:DebuffRemains(v77.Deathmark) < (5 - 1)) or v14:DebuffUp(v77.Sepsis)) and (v14:DebuffRemains(v77.Sepsis) < (1185 - (229 + 953)))) or ((3861 - (1111 + 663)) > (3951 - (874 + 705)))) then
								if (v22(v77.ShadowDance, v57) or ((623 + 3822) < (2831 + 1318))) then
									return "Cast Shadow Dance (Master Assassin)";
								end
							end
							break;
						end
					end
				end
				if ((v77.Vanish:IsCastable() and not v13:IsTanking(v14)) or ((3778 - 1960) == (3 + 82))) then
					if (((1309 - (642 + 37)) < (485 + 1642)) and v77.ImprovedGarrote:IsAvailable() and not v77.MasterAssassin:IsAvailable() and v77.Garrote:CooldownUp() and ((v14:PMultiplier(v77.Garrote) <= (1 + 0)) or v123(v14, v77.Garrote))) then
						local v244 = 0 - 0;
						while true do
							if ((v244 == (454 - (233 + 221))) or ((4481 - 2543) == (2213 + 301))) then
								if (((5796 - (718 + 823)) >= (35 + 20)) and not v77.IndiscriminateCarnage:IsAvailable() and (v77.Deathmark:AnyDebuffUp() or (v77.Deathmark:CooldownRemains() < (809 - (266 + 539)))) and (v93 >= v25(v87, 11 - 7))) then
									local v262 = 1225 - (636 + 589);
									while true do
										if (((7118 - 4119) > (2383 - 1227)) and (v262 == (0 + 0))) then
											if (((854 + 1496) > (2170 - (657 + 358))) and (v13:EnergyPredicted() < (119 - 74))) then
												if (((9178 - 5149) <= (6040 - (1151 + 36))) and v22(v77.PoolEnergy)) then
													return "Pool for Vanish (Garrote Deathmark)";
												end
											end
											if (v22(v77.Vanish, v56) or ((499 + 17) > (903 + 2531))) then
												return "Cast Vanish (Garrote Deathmark)";
											end
											break;
										end
									end
								end
								if (((12082 - 8036) >= (4865 - (1552 + 280))) and v77.IndiscriminateCarnage:IsAvailable() and (v87 > (836 - (64 + 770)))) then
									local v263 = 0 + 0;
									while true do
										if ((v263 == (0 - 0)) or ((483 + 2236) <= (2690 - (157 + 1086)))) then
											if ((v13:EnergyPredicted() < (90 - 45)) or ((18105 - 13971) < (6021 - 2095))) then
												if (v22(v77.PoolEnergy) or ((223 - 59) >= (3604 - (599 + 220)))) then
													return "Pool for Vanish (Garrote Deathmark)";
												end
											end
											if (v22(v77.Vanish, v56) or ((1045 - 520) == (4040 - (1813 + 118)))) then
												return "Cast Vanish (Garrote Cleave)";
											end
											break;
										end
									end
								end
								break;
							end
						end
					end
					if (((25 + 8) == (1250 - (841 + 376))) and v77.MasterAssassin:IsAvailable() and v77.Kingsbane:IsAvailable() and v14:DebuffUp(v77.Kingsbane) and (v14:DebuffRemains(v77.Kingsbane) <= (3 - 0)) and v14:DebuffUp(v77.Deathmark) and (v14:DebuffRemains(v77.Deathmark) <= (1 + 2))) then
						if (((8335 - 5281) <= (4874 - (464 + 395))) and v22(v77.Vanish, v56)) then
							return "Cast Vanish (Kingsbane)";
						end
					end
					if (((4801 - 2930) < (1625 + 1757)) and not v77.ImprovedGarrote:IsAvailable() and v77.MasterAssassin:IsAvailable() and not v123(v14, v77.Rupture) and (v14:DebuffRemains(v77.Garrote) > (840 - (467 + 370))) and v14:DebuffUp(v77.Deathmark) and (v14:DebuffUp(v77.ShivDebuff) or (v14:DebuffRemains(v77.Deathmark) < (8 - 4)) or v14:DebuffUp(v77.Sepsis)) and (v14:DebuffRemains(v77.Sepsis) < (3 + 0))) then
						if (((4432 - 3139) <= (338 + 1828)) and v22(v77.Vanish, v56)) then
							return "Cast Vanish (Master Assassin)";
						end
					end
				end
				break;
			end
		end
	end
	local function v131()
		local v174 = 0 - 0;
		while true do
			if ((v174 == (520 - (150 + 370))) or ((3861 - (74 + 1208)) < (302 - 179))) then
				if (v112:IsReady() or ((4012 - 3166) >= (1685 + 683))) then
					local v218 = 390 - (14 + 376);
					local v219;
					while true do
						if ((v218 == (0 - 0)) or ((2597 + 1415) <= (2950 + 408))) then
							v219 = v75.HandleTopTrinket(v80, v30, 8 + 0, nil);
							if (((4377 - 2883) <= (2261 + 744)) and v219) then
								return v219;
							end
							break;
						end
					end
				end
				if (v113:IsReady() or ((3189 - (23 + 55)) == (5057 - 2923))) then
					local v220 = 0 + 0;
					local v221;
					while true do
						if (((2115 + 240) == (3651 - 1296)) and (v220 == (0 + 0))) then
							v221 = v75.HandleBottomTrinket(v80, v30, 909 - (652 + 249), nil);
							if (v221 or ((1573 - 985) <= (2300 - (708 + 1160)))) then
								return v221;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v132()
		local v175 = 0 - 0;
		local v176;
		local v177;
		while true do
			if (((8745 - 3948) >= (3922 - (10 + 17))) and ((1 + 1) == v175)) then
				if (((5309 - (1400 + 332)) == (6860 - 3283)) and v77.ThistleTea:IsCastable() and not v13:BuffUp(v77.ThistleTea) and (((v13:EnergyDeficit() >= ((2008 - (242 + 1666)) + v105)) and (not v77.Kingsbane:IsAvailable() or (v77.ThistleTea:Charges() >= (1 + 1)))) or (v14:DebuffUp(v77.Kingsbane) and (v14:DebuffRemains(v77.Kingsbane) < (3 + 3))) or (not v77.Kingsbane:IsAvailable() and v77.Deathmark:AnyDebuffUp()) or v9.BossFilteredFightRemains("<", v77.ThistleTea:Charges() * (6 + 0)))) then
					if (((4734 - (850 + 90)) > (6467 - 2774)) and v9.Cast(v77.ThistleTea)) then
						return "Cast Thistle Tea";
					end
				end
				if ((not v13:StealthUp(true, true) and (v118() <= (1390 - (360 + 1030))) and (v117() <= (0 + 0))) or ((3598 - 2323) == (5640 - 1540))) then
					local v222 = 1661 - (909 + 752);
					local v223;
					while true do
						if ((v222 == (1223 - (109 + 1114))) or ((2912 - 1321) >= (1394 + 2186))) then
							v223 = v130();
							if (((1225 - (6 + 236)) <= (1140 + 668)) and v223) then
								return v223;
							end
							break;
						end
					end
				end
				if ((v77.ColdBlood:IsReady() and v13:DebuffDown(v77.ColdBlood) and (v92 >= (4 + 0))) or ((5070 - 2920) <= (2090 - 893))) then
					if (((4902 - (1076 + 57)) >= (193 + 980)) and v9.Press(v77.ColdBlood)) then
						return "Cast Cold Blood";
					end
				end
				return false;
			end
			if (((2174 - (579 + 110)) == (118 + 1367)) and (v175 == (1 + 0))) then
				if ((v77.Deathmark:IsCastable() and (v177 or v9.BossFilteredFightRemains("<=", 11 + 9))) or ((3722 - (174 + 233)) <= (7770 - 4988))) then
					if (v22(v77.Deathmark) or ((1537 - 661) >= (1319 + 1645))) then
						return "Cast Deathmark";
					end
				end
				if ((v77.Shiv:IsReady() and not v14:DebuffUp(v77.ShivDebuff) and v14:DebuffUp(v77.Garrote) and v14:DebuffUp(v77.Rupture)) or ((3406 - (663 + 511)) > (2228 + 269))) then
					local v224 = 0 + 0;
					while true do
						if ((v224 == (0 - 0)) or ((1278 + 832) <= (781 - 449))) then
							if (((8922 - 5236) > (1514 + 1658)) and v9.BossFilteredFightRemains("<=", v77.Shiv:Charges() * (15 - 7))) then
								if (v22(v77.Shiv) or ((3189 + 1285) < (75 + 745))) then
									return "Cast Shiv (End of Fight)";
								end
							end
							if (((5001 - (478 + 244)) >= (3399 - (440 + 77))) and v77.Kingsbane:IsAvailable() and v13:BuffUp(v77.Envenom)) then
								local v253 = 0 + 0;
								while true do
									if (((0 - 0) == v253) or ((3585 - (655 + 901)) >= (653 + 2868))) then
										if ((not v77.LightweightShiv:IsAvailable() and ((v14:DebuffUp(v77.Kingsbane) and (v14:DebuffRemains(v77.Kingsbane) < (7 + 1))) or (v77.Kingsbane:CooldownRemains() >= (17 + 7))) and (not v77.CrimsonTempest:IsAvailable() or v108 or v14:DebuffUp(v77.CrimsonTempest))) or ((8206 - 6169) >= (6087 - (695 + 750)))) then
											if (((5873 - 4153) < (6879 - 2421)) and v22(v77.Shiv)) then
												return "Cast Shiv (Kingsbane)";
											end
										end
										if ((v77.LightweightShiv:IsAvailable() and (v14:DebuffUp(v77.Kingsbane) or (v77.Kingsbane:CooldownRemains() <= (3 - 2)))) or ((787 - (285 + 66)) > (7041 - 4020))) then
											if (((2023 - (682 + 628)) <= (137 + 710)) and v22(v77.Shiv)) then
												return "Cast Shiv (Kingsbane Lightweight)";
											end
										end
										break;
									end
								end
							end
							v224 = 300 - (176 + 123);
						end
						if (((901 + 1253) <= (2924 + 1107)) and (v224 == (270 - (239 + 30)))) then
							if (((1255 + 3360) == (4436 + 179)) and v77.ArterialPrecision:IsAvailable() and v77.Deathmark:AnyDebuffUp()) then
								if (v22(v77.Shi) or ((6708 - 2918) == (1559 - 1059))) then
									return "Cast Shiv (Arterial Precision)";
								end
							end
							if (((404 - (306 + 9)) < (771 - 550)) and not v77.Kingsbane:IsAvailable() and not v77.ArterialPrecision:IsAvailable()) then
								if (((358 + 1696) >= (872 + 549)) and v77.Sepsis:IsAvailable()) then
									if (((334 + 358) < (8744 - 5686)) and (((v77.Shiv:ChargesFractional() > ((1375.9 - (1140 + 235)) + v23(v77.LightweightShiv:IsAvailable()))) and (v103 > (4 + 1))) or v14:DebuffUp(v77.Sepsis) or v14:DebuffUp(v77.Deathmark))) then
										if (v22(v77.Shiv) or ((2984 + 270) == (425 + 1230))) then
											return "Cast Shiv (Sepsis)";
										end
									end
								elseif (not v77.CrimsonTempest:IsAvailable() or v108 or v14:DebuffUp(v77.CrimsonTempest) or ((1348 - (33 + 19)) == (1773 + 3137))) then
									if (((10094 - 6726) == (1484 + 1884)) and v22(v77.Shiv)) then
										return "Cast Shiv";
									end
								end
							end
							break;
						end
					end
				end
				if (((5182 - 2539) < (3578 + 237)) and v77.ShadowDance:IsCastable() and v77.Kingsbane:IsAvailable() and v13:BuffUp(v77.Envenom) and ((v77.Deathmark:CooldownRemains() >= (739 - (586 + 103))) or v177)) then
					if (((175 + 1738) > (1517 - 1024)) and v22(v77.ShadowDance)) then
						return "Cast Shadow Dance (Kingsbane Sync)";
					end
				end
				if (((6243 - (1309 + 179)) > (6188 - 2760)) and v77.Kingsbane:IsReady() and (v14:DebuffUp(v77.ShivDebuff) or (v77.Shiv:CooldownRemains() < (3 + 3))) and v13:BuffUp(v77.Envenom) and ((v77.Deathmark:CooldownRemains() >= (134 - 84)) or v14:DebuffUp(v77.Deathmark))) then
					if (((1044 + 337) <= (5032 - 2663)) and v22(v77.Kingsbane)) then
						return "Cast Kingsbane";
					end
				end
				v175 = 3 - 1;
			end
			if ((v175 == (609 - (295 + 314))) or ((11895 - 7052) == (6046 - (1300 + 662)))) then
				if (((14661 - 9992) > (2118 - (1178 + 577))) and v77.Sepsis:IsReady() and (v14:DebuffRemains(v77.Rupture) > (11 + 9)) and ((not v77.ImprovedGarrote:IsAvailable() and v14:DebuffUp(v77.Garrote)) or (v77.ImprovedGarrote:IsAvailable() and v77.Garrote:CooldownUp() and (v14:PMultiplier(v77.Garrote) <= (2 - 1)))) and (v14:FilteredTimeToDie(">", 1415 - (851 + 554)) or v9.BossFilteredFightRemains("<=", 9 + 1))) then
					if (v22(v77.Sepsis, nil, true) or ((5205 - 3328) >= (6815 - 3677))) then
						return "Cast Sepsis";
					end
				end
				v176 = v75.HandleDPSPotion();
				if (((5044 - (115 + 187)) >= (2777 + 849)) and v176) then
					return v176;
				end
				v177 = not v13:StealthUp(true, false) and v14:DebuffUp(v77.Rupture) and v13:BuffUp(v77.Envenom) and not v77.Deathmark:AnyDebuffUp() and (not v77.MasterAssassin:IsAvailable() or v14:DebuffUp(v77.Garrote)) and (not v77.Kingsbane:IsAvailable() or (v77.Kingsbane:CooldownRemains() <= (2 + 0)));
				v175 = 3 - 2;
			end
		end
	end
	local function v133()
		local v178 = 1161 - (160 + 1001);
		while true do
			if ((v178 == (2 + 0)) or ((3133 + 1407) == (1874 - 958))) then
				if (((v92 >= (362 - (237 + 121))) and (v14:PMultiplier(v77.Rupture) <= (898 - (525 + 372))) and (v13:BuffUp(v77.ShadowDanceBuff) or v14:DebuffUp(v77.Deathmark))) or ((2191 - 1035) > (14276 - 9931))) then
					if (((2379 - (96 + 46)) < (5026 - (643 + 134))) and v17(v77.Rupture)) then
						return "Cast Rupture (Nightstalker)";
					end
				end
				break;
			end
			if ((v178 == (1 + 0)) or ((6432 - 3749) < (85 - 62))) then
				if (((669 + 28) <= (1620 - 794)) and v29 and v77.CrimsonTempest:IsReady() and v77.Nightstalker:IsAvailable() and (v87 >= (5 - 2)) and (v92 >= (723 - (316 + 403))) and not v77.Deathmark:IsReady()) then
					if (((735 + 370) <= (3233 - 2057)) and v22(v77.CrimsonTempest)) then
						return "Cast Crimson Tempest (Stealth)";
					end
				end
				if (((1222 + 2157) <= (9599 - 5787)) and v77.Garrote:IsCastable() and (v118() > (0 + 0))) then
					local v225 = 0 + 0;
					local v226;
					local v227;
					while true do
						if ((v225 == (6 - 4)) or ((3763 - 2975) >= (3356 - 1740))) then
							if (((107 + 1747) <= (6651 - 3272)) and v29) then
								local v254 = 0 + 0;
								local v255;
								while true do
									if (((13383 - 8834) == (4566 - (12 + 5))) and (v254 == (0 - 0))) then
										v255 = v125("min", v226, v227);
										if ((v255 and (v255:GUID() == v19:GUID())) or ((6447 - 3425) >= (6427 - 3403))) then
											v22(v78.GarroteMouseOver);
										end
										break;
									end
								end
							end
							if (((11953 - 7133) > (447 + 1751)) and v227(v14)) then
								if (v17(v77.Garrote) or ((3034 - (1656 + 317)) >= (4359 + 532))) then
									return "Cast Garrote (Improved Garrote)";
								end
							end
							v225 = 3 + 0;
						end
						if (((3626 - 2262) <= (22014 - 17541)) and (v225 == (354 - (5 + 349)))) then
							v226 = nil;
							function v226(v246)
								return v246:DebuffRemains(v77.Garrote);
							end
							v225 = 4 - 3;
						end
						if ((v225 == (1272 - (266 + 1005))) or ((2369 + 1226) <= (10 - 7))) then
							v227 = nil;
							function v227(v247)
								return ((v247:PMultiplier(v77.Garrote) <= (1 - 0)) or (v247:DebuffRemains(v77.Garrote) < ((1708 - (561 + 1135)) / v76.ExsanguinatedRate(v247, v77.Garrote))) or ((v119() > (0 - 0)) and (v77.Garrote:AuraActiveCount() < v87))) and not v108 and (v247:FilteredTimeToDie(">", 6 - 4, -v247:DebuffRemains(v77.Garrote)) or v247:TimeToDieIsNotValid()) and v76.CanDoTUnit(v247, v97);
							end
							v225 = 1068 - (507 + 559);
						end
						if ((v225 == (7 - 4)) or ((14448 - 9776) == (4240 - (212 + 176)))) then
							if (((2464 - (250 + 655)) == (4251 - 2692)) and (v93 >= ((1 - 0) + ((2 - 0) * v23(v77.ShroudedSuffocation:IsAvailable()))))) then
								local v256 = 1956 - (1869 + 87);
								while true do
									if ((v256 == (0 - 0)) or ((3653 - (484 + 1417)) <= (1688 - 900))) then
										if ((v13:BuffDown(v77.ShadowDanceBuff) and ((v14:PMultiplier(v77.Garrote) <= (1 - 0)) or (v14:DebuffUp(v77.Deathmark) and (v117() < (776 - (48 + 725)))))) or ((6382 - 2475) == (474 - 297))) then
											if (((2017 + 1453) > (1483 - 928)) and v17(v77.Garrote)) then
												return "Cast Garrote (Improved Garrote Low CP)";
											end
										end
										if ((v14:PMultiplier(v77.Garrote) <= (1 + 0)) or (v14:DebuffRemains(v77.Garrote) < (4 + 8)) or ((1825 - (152 + 701)) == (1956 - (430 + 881)))) then
											if (((1219 + 1963) >= (3010 - (557 + 338))) and v17(v77.Garrote)) then
												return "Cast Garrote (Improved Garrote Low CP 2)";
											end
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v178 = 1 + 1;
			end
			if (((10970 - 7077) < (15509 - 11080)) and (v178 == (0 - 0))) then
				if ((v77.Kingsbane:IsAvailable() and v13:BuffUp(v77.Envenom)) or ((6178 - 3311) < (2706 - (499 + 302)))) then
					if ((v77.Shiv:IsReady() and (v14:DebuffUp(v77.Kingsbane) or v77.Kingsbane:CooldownUp()) and v14:DebuffDown(v77.ShivDebuff)) or ((2662 - (39 + 827)) >= (11182 - 7131))) then
						if (((3615 - 1996) <= (14918 - 11162)) and v22(v77.Shiv)) then
							return "Cast Shiv (Stealth Kingsbane)";
						end
					end
					if (((927 - 323) == (52 + 552)) and v77.Kingsbane:IsReady() and (v13:BuffRemains(v77.ShadowDanceBuff) >= (5 - 3))) then
						if (v22(v77.Kingsbane, v69) or ((718 + 3766) == (1424 - 524))) then
							return "Cast Kingsbane (Dance)";
						end
					end
				end
				if ((v92 >= (108 - (103 + 1))) or ((5013 - (475 + 79)) <= (2405 - 1292))) then
					local v228 = 0 - 0;
					while true do
						if (((470 + 3162) > (2991 + 407)) and (v228 == (1503 - (1395 + 108)))) then
							if (((11878 - 7796) <= (6121 - (7 + 1197))) and v14:DebuffUp(v77.Kingsbane) and (v13:BuffRemains(v77.Envenom) <= (1 + 1))) then
								if (((1687 + 3145) >= (1705 - (27 + 292))) and v22(v77.Envenom)) then
									return "Cast Envenom (Stealth Kingsbane)";
								end
							end
							if (((401 - 264) == (174 - 37)) and v108 and v116() and v13:BuffDown(v77.ShadowDanceBuff)) then
								if (v22(v77.Envenom) or ((6584 - 5014) >= (8542 - 4210))) then
									return "Cast Envenom (Master Assassin)";
								end
							end
							break;
						end
					end
				end
				v178 = 1 - 0;
			end
		end
	end
	local function v134()
		local v179 = 139 - (43 + 96);
		while true do
			if (((0 - 0) == v179) or ((9187 - 5123) <= (1510 + 309))) then
				if ((v29 and v77.CrimsonTempest:IsReady() and (v87 >= (1 + 1)) and (v92 >= (7 - 3)) and (v105 > (10 + 15)) and not v77.Deathmark:IsReady()) or ((9344 - 4358) < (496 + 1078))) then
					if (((325 + 4101) > (1923 - (1414 + 337))) and v22(v77.CrimsonTempest)) then
						return "Cast Crimson Tempest (AoE High Energy)";
					end
				end
				if (((2526 - (1642 + 298)) > (1185 - 730)) and v77.Garrote:IsCastable() and (v93 >= (2 - 1))) then
					local v229 = 0 - 0;
					local v230;
					while true do
						if (((272 + 554) == (643 + 183)) and (v229 == (973 - (357 + 615)))) then
							if ((v230(v14) and v76.CanDoTUnit(v14, v97) and (v14:FilteredTimeToDie(">", 9 + 3, -v14:DebuffRemains(v77.Garrote)) or v14:TimeToDieIsNotValid())) or ((9861 - 5842) > (3806 + 635))) then
								if (((4322 - 2305) < (3408 + 853)) and v31(v77.Garrote)) then
									return "Pool for Garrote (ST)";
								end
							end
							break;
						end
						if (((321 + 4395) > (51 + 29)) and (v229 == (1301 - (384 + 917)))) then
							v230 = nil;
							function v230(v248)
								return v123(v248, v77.Garrote) and (v248:PMultiplier(v77.Garrote) <= (698 - (128 + 569)));
							end
							v229 = 1544 - (1407 + 136);
						end
					end
				end
				v179 = 1888 - (687 + 1200);
			end
			if ((v179 == (1712 - (556 + 1154))) or ((12337 - 8830) == (3367 - (9 + 86)))) then
				return false;
			end
			if ((v179 == (422 - (275 + 146))) or ((143 + 733) >= (3139 - (29 + 35)))) then
				if (((19287 - 14935) > (7628 - 5074)) and v77.Rupture:IsReady() and (v92 >= (17 - 13))) then
					local v231 = 0 + 0;
					local v232;
					while true do
						if ((v231 == (1012 - (53 + 959))) or ((4814 - (312 + 96)) < (7016 - 2973))) then
							v98 = (289 - (147 + 138)) + (v23(v77.DashingScoundrel:IsAvailable()) * (904 - (813 + 86))) + (v23(v77.Doomblade:IsAvailable()) * (5 + 0)) + (v23(v107) * (10 - 4));
							v232 = nil;
							v231 = 493 - (18 + 474);
						end
						if ((v231 == (1 + 0)) or ((6165 - 4276) >= (4469 - (860 + 226)))) then
							function v232(v249)
								return v123(v249, v77.Rupture, v94) and (v249:PMultiplier(v77.Rupture) <= (304 - (121 + 182))) and (v249:FilteredTimeToDie(">", v98, -v249:DebuffRemains(v77.Rupture)) or v249:TimeToDieIsNotValid());
							end
							if (((233 + 1659) <= (3974 - (988 + 252))) and v232(v14) and v76.CanDoTUnit(v14, v96)) then
								if (((218 + 1705) < (695 + 1523)) and v22(v77.Rupture)) then
									return "Cast Rupture";
								end
							end
							break;
						end
					end
				end
				if (((4143 - (49 + 1921)) > (1269 - (223 + 667))) and v77.Garrote:IsCastable() and (v93 >= (53 - (51 + 1))) and (v117() <= (0 - 0)) and ((v14:PMultiplier(v77.Garrote) <= (1 - 0)) or ((v14:DebuffRemains(v77.Garrote) < v90) and (v87 >= (1128 - (146 + 979))))) and (v14:DebuffRemains(v77.Garrote) < (v90 * (1 + 1))) and (v87 >= (608 - (311 + 294))) and (v14:FilteredTimeToDie(">", 11 - 7, -v14:DebuffRemains(v77.Garrote)) or v14:TimeToDieIsNotValid())) then
					if (v22(v77.Garrote) or ((1098 + 1493) == (4852 - (496 + 947)))) then
						return "Garrote (Fallback)";
					end
				end
				v179 = 1360 - (1233 + 125);
			end
		end
	end
	local function v135()
		local v180 = 0 + 0;
		while true do
			if (((4050 + 464) > (632 + 2692)) and (v180 == (1648 - (963 + 682)))) then
				if (((v77.Ambush:IsCastable() or v77.AmbushOverride:IsCastable()) and (v13:StealthUp(true, true) or v13:BuffUp(v77.BlindsideBuff) or v13:BuffUp(v77.SepsisBuff)) and (v14:DebuffDown(v77.Kingsbane) or v14:DebuffDown(v77.Deathmark) or v13:BuffUp(v77.BlindsideBuff))) or ((174 + 34) >= (6332 - (504 + 1000)))) then
					if (v22(v77.Ambush) or ((1067 + 516) > (3249 + 318))) then
						return "Cast Ambush";
					end
				end
				if ((v77.Mutilate:IsCastable() and (v87 == (1 + 1)) and v14:DebuffDown(v77.DeadlyPoisonDebuff, true) and v14:DebuffDown(v77.AmplifyingPoisonDebuff, true)) or ((1935 - 622) == (679 + 115))) then
					local v233 = 0 + 0;
					local v234;
					while true do
						if (((3356 - (156 + 26)) > (1672 + 1230)) and (v233 == (0 - 0))) then
							v234 = v14:GUID();
							for v250, v251 in v32(v88) do
							end
							break;
						end
					end
				end
				v180 = 168 - (149 + 15);
			end
			if (((5080 - (890 + 70)) <= (4377 - (39 + 78))) and (v180 == (483 - (14 + 468)))) then
				if ((not v108 and v77.CausticSpatter:IsAvailable() and v14:DebuffUp(v77.Rupture) and (v14:DebuffRemains(v77.CausticSpatterDebuff) <= (4 - 2))) or ((2467 - 1584) > (2466 + 2312))) then
					local v235 = 0 + 0;
					while true do
						if ((v235 == (0 + 0)) or ((1635 + 1985) >= (1282 + 3609))) then
							if (((8150 - 3892) > (927 + 10)) and v77.Mutilate:IsCastable()) then
								if (v22(v77.Mutilate) or ((17109 - 12240) < (23 + 883))) then
									return "Cast Mutilate (Casutic)";
								end
							end
							if (((v77.Ambush:IsCastable() or v77.AmbushOverride:IsCastable()) and (v13:StealthUp(true, true) or v13:BuffUp(v77.BlindsideBuff))) or ((1276 - (12 + 39)) > (3934 + 294))) then
								if (((10301 - 6973) > (7970 - 5732)) and v22(v77.Ambush)) then
									return "Cast Ambush (Caustic)";
								end
							end
							break;
						end
					end
				end
				if (((1139 + 2700) > (740 + 665)) and v77.SerratedBoneSpike:IsReady()) then
					if (not v14:DebuffUp(v77.SerratedBoneSpikeDebuff) or ((3278 - 1985) <= (338 + 169))) then
						if (v22(v77.SerratedBoneSpike) or ((13995 - 11099) < (2515 - (1596 + 114)))) then
							return "Cast Serrated Bone Spike";
						end
					else
						local v245 = 0 - 0;
						while true do
							if (((3029 - (164 + 549)) == (3754 - (1059 + 379))) and (v245 == (0 - 0))) then
								if (v29 or ((1332 + 1238) == (259 + 1274))) then
									if (v75.CastTargetIf(v77.SerratedBoneSpike, v85, "min", v127, v128) or ((1275 - (145 + 247)) == (1198 + 262))) then
										return "Cast Serrated Bone (AoE)";
									end
								end
								if ((v117() < (0.8 + 0)) or ((13693 - 9074) <= (192 + 807))) then
									if ((v9.BossFightRemains() <= (5 + 0)) or ((v77.SerratedBoneSpike:MaxCharges() - v77.SerratedBoneSpike:ChargesFractional()) <= (0.25 - 0)) or ((4130 - (254 + 466)) > (4676 - (544 + 16)))) then
										if (v22(v77.SerratedBoneSpike) or ((2869 - 1966) >= (3687 - (294 + 334)))) then
											return "Cast Serrated Bone Spike (Dump Charge)";
										end
									elseif ((not v108 and v14:DebuffUp(v77.ShivDebuff)) or ((4229 - (236 + 17)) < (1232 + 1625))) then
										if (((3838 + 1092) > (8688 - 6381)) and v22(v77.SerratedBoneSpike)) then
											return "Cast Serrated Bone Spike (Shiv)";
										end
									end
								end
								break;
							end
						end
					end
				end
				v180 = 9 - 7;
			end
			if ((v180 == (2 + 0)) or ((3333 + 713) < (2085 - (413 + 381)))) then
				if ((v30 and v77.EchoingReprimand:IsReady()) or ((179 + 4062) == (7539 - 3994))) then
					if (v22(v77.EchoingReprimand) or ((10514 - 6466) > (6202 - (582 + 1388)))) then
						return "Cast Echoing Reprimand";
					end
				end
				if (v77.FanofKnives:IsCastable() or ((2981 - 1231) >= (2487 + 986))) then
					local v236 = 364 - (326 + 38);
					while true do
						if (((9365 - 6199) == (4519 - 1353)) and (v236 == (620 - (47 + 573)))) then
							if (((622 + 1141) < (15816 - 12092)) and v29 and (v87 >= (2 - 0)) and (v87 >= ((1666 - (1269 + 395)) + v23(v13:StealthUp(true, false)) + v23(v77.DragonTemperedBlades:IsAvailable())))) then
								if (((549 - (76 + 416)) <= (3166 - (319 + 124))) and v22(v77.FanofKnives)) then
									return "Cast Fan of Knives";
								end
							end
							if ((v29 and (v87 >= (4 - 2))) or ((3077 - (564 + 443)) == (1225 - 782))) then
								if (v22(v77.FanofKnives) or ((3163 - (337 + 121)) == (4081 - 2688))) then
									return "Fillers Fan of knives";
								end
							end
							break;
						end
					end
				end
				v180 = 9 - 6;
			end
			if ((v180 == (1911 - (1261 + 650))) or ((1947 + 2654) < (96 - 35))) then
				if ((v77.Envenom:IsReady() and (v92 >= (1821 - (772 + 1045))) and (v102 or (v14:DebuffStack(v77.AmplifyingPoisonDebuff) >= (3 + 17)) or (v92 > v76.CPMaxSpend()) or not v108)) or ((1534 - (102 + 42)) >= (6588 - (1524 + 320)))) then
					if (v22(v77.Envenom) or ((3273 - (1049 + 221)) > (3990 - (18 + 138)))) then
						return "Cast Envenom";
					end
				end
				if (not ((v93 > (2 - 1)) or v102 or not v108) or ((1258 - (67 + 1035)) > (4261 - (136 + 212)))) then
					return false;
				end
				v180 = 4 - 3;
			end
			if (((157 + 38) == (180 + 15)) and ((1608 - (240 + 1364)) == v180)) then
				if (((4187 - (1050 + 32)) >= (6412 - 4616)) and v77.Mutilate:IsCastable()) then
					if (((2591 + 1788) >= (3186 - (331 + 724))) and v22(v77.Mutilate)) then
						return "Cast Mutilate";
					end
				end
				return false;
			end
		end
	end
	local function v136()
		local v181 = 0 + 0;
		while true do
			if (((4488 - (269 + 375)) >= (2768 - (267 + 458))) and (v181 == (0 + 0))) then
				v74();
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v181 = 1 - 0;
			end
			if ((v181 == (820 - (667 + 151))) or ((4729 - (1410 + 87)) <= (4628 - (1504 + 393)))) then
				if (((13258 - 8353) == (12725 - 7820)) and v29) then
					v85 = v13:GetEnemiesInRange(826 - (461 + 335));
					v86 = v13:GetEnemiesInMeleeRange(v82);
					v87 = #v86;
					v88 = v13:GetEnemiesInMeleeRange(v81);
				else
					local v237 = 0 + 0;
					while true do
						if ((v237 == (1761 - (1730 + 31))) or ((5803 - (728 + 939)) >= (15622 - 11211))) then
							v85 = {};
							v86 = {};
							v237 = 1 - 0;
						end
						if ((v237 == (2 - 1)) or ((4026 - (138 + 930)) == (3671 + 346))) then
							v87 = 1 + 0;
							v88 = {};
							break;
						end
					end
				end
				v90, v91 = (2 + 0) * v13:SpellHaste(), (4 - 3) * v13:SpellHaste();
				v92 = v76.EffectiveComboPoints(v13:ComboPoints());
				v93 = v13:ComboPointsMax() - v92;
				v181 = 1769 - (459 + 1307);
			end
			if (((3098 - (474 + 1396)) >= (1419 - 606)) and (v181 == (3 + 0))) then
				v94 = (1 + 3 + (v92 * (11 - 7))) * (0.3 + 0);
				v95 = ((13 - 9) + (v92 * (8 - 6))) * (591.3 - (562 + 29));
				v96 = v77.Envenom:Damage() * v64;
				v97 = v77.Mutilate:Damage() * v65;
				v181 = 4 + 0;
			end
			if ((v181 == (1423 - (374 + 1045))) or ((2735 + 720) > (12576 - 8526))) then
				v101 = v48();
				v89 = v76.CrimsonVial();
				if (((881 - (448 + 190)) == (79 + 164)) and v89) then
					return v89;
				end
				v89 = v76.Feint();
				v181 = 3 + 2;
			end
			if ((v181 == (4 + 1)) or ((1041 - 770) > (4884 - 3312))) then
				if (((4233 - (1307 + 187)) < (13058 - 9765)) and v89) then
					return v89;
				end
				if ((not v13:AffectingCombat() and not v13:IsMounted() and v75.TargetIsValid()) or ((9229 - 5287) < (3476 - 2342))) then
					local v238 = 683 - (232 + 451);
					while true do
						if ((v238 == (0 + 0)) or ((2379 + 314) == (5537 - (510 + 54)))) then
							v89 = v76.Stealth(v77.Stealth2, nil);
							if (((4323 - 2177) == (2182 - (13 + 23))) and v89) then
								return "Stealth (OOC): " .. v89;
							end
							break;
						end
					end
				end
				v76.Poisons();
				if (not v13:AffectingCombat() or ((4374 - 2130) == (4632 - 1408))) then
					local v239 = 0 - 0;
					while true do
						if ((v239 == (1088 - (830 + 258))) or ((17299 - 12395) <= (1199 + 717))) then
							if (((77 + 13) <= (2506 - (860 + 581))) and not v13:BuffUp(v76.VanishBuffSpell())) then
								local v257 = 0 - 0;
								while true do
									if (((3812 + 990) == (5043 - (237 + 4))) and (v257 == (0 - 0))) then
										v89 = v76.Stealth(v76.StealthSpell());
										if (v89 or ((5768 - 3488) <= (968 - 457))) then
											return v89;
										end
										break;
									end
								end
							end
							if (v75.TargetIsValid() or ((1372 + 304) <= (266 + 197))) then
								if (((14606 - 10737) == (1661 + 2208)) and v30) then
									if (((630 + 528) <= (4039 - (85 + 1341))) and v28 and v77.MarkedforDeath:IsCastable() and (v13:ComboPointsDeficit() >= v76.CPMaxSpend()) and v75.TargetIsValid()) then
										if (v9.Press(v77.MarkedforDeath, v60) or ((4033 - 1669) <= (5645 - 3646))) then
											return "Cast Marked for Death (OOC)";
										end
									end
								end
								if (not v13:BuffUp(v77.SliceandDice) or ((5294 - (45 + 327)) < (365 - 171))) then
									if ((v77.SliceandDice:IsReady() and (v92 >= (504 - (444 + 58)))) or ((909 + 1182) < (6 + 25))) then
										if (v9.Press(v77.SliceandDice) or ((1188 + 1242) >= (14118 - 9246))) then
											return "Cast Slice and Dice";
										end
									end
								end
							end
							break;
						end
					end
				end
				v181 = 1738 - (64 + 1668);
			end
			if ((v181 == (1974 - (1227 + 746))) or ((14661 - 9891) < (3219 - 1484))) then
				v81 = (v77.AcrobaticStrikes:IsAvailable() and (502 - (415 + 79))) or (1 + 4);
				v82 = (v77.AcrobaticStrikes:IsAvailable() and (504 - (142 + 349))) or (5 + 5);
				v83 = v14:IsInMeleeRange(v81);
				v84 = v14:IsInMeleeRange(v82);
				v181 = 2 - 0;
			end
			if ((v181 == (3 + 3)) or ((3128 + 1311) <= (6399 - 4049))) then
				v76.MfDSniping(v77.MarkedforDeath);
				if (v75.TargetIsValid() or ((6343 - (1710 + 154)) < (4784 - (200 + 118)))) then
					local v240 = 0 + 0;
					local v241;
					local v242;
					while true do
						if (((4452 - 1905) > (1816 - 591)) and ((6 + 0) == v240)) then
							if (((4621 + 50) > (1436 + 1238)) and not v13:BuffUp(v77.SliceandDice)) then
								if ((v77.SliceandDice:IsReady() and (v13:ComboPoints() >= (1 + 1)) and v14:DebuffUp(v77.Rupture)) or (not v77.CutToTheChase:IsAvailable() and (v13:ComboPoints() >= (8 - 4)) and (v13:BuffRemains(v77.SliceandDice) < (((1251 - (363 + 887)) + v13:ComboPoints()) * (1.8 - 0)))) or ((17592 - 13896) < (514 + 2813))) then
									if (v22(v77.SliceandDice) or ((10627 - 6085) == (2030 + 940))) then
										return "Cast Slice and Dice";
									end
								end
							elseif (((1916 - (674 + 990)) <= (567 + 1410)) and v84 and v77.CutToTheChase:IsAvailable()) then
								if ((v77.Envenom:IsReady() and (v13:BuffRemains(v77.SliceandDice) < (3 + 2)) and (v13:ComboPoints() >= (6 - 2))) or ((2491 - (507 + 548)) == (4612 - (289 + 548)))) then
									if (v22(v77.Envenom) or ((3436 - (821 + 997)) < (1185 - (195 + 60)))) then
										return "Cast Envenom (CttC)";
									end
								end
							elseif (((1270 + 3453) > (5654 - (251 + 1250))) and v77.PoisonedKnife:IsCastable() and v14:IsInRange(87 - 57) and not v13:StealthUp(true, true) and (v87 == (0 + 0)) and (v13:EnergyTimeToMax() <= (v13:GCD() * (1033.5 - (809 + 223))))) then
								if (v22(v77.PoisonedKnife) or ((5331 - 1677) >= (13976 - 9322))) then
									return "Cast Poisoned Knife";
								end
							end
							v89 = v134();
							if (((3144 - 2193) <= (1102 + 394)) and v89) then
								return v89;
							end
							v240 = 4 + 3;
						end
						if ((v240 == (617 - (14 + 603))) or ((1865 - (118 + 11)) == (93 + 478))) then
							if ((not v13:IsCasting() and not v13:IsChanneling()) or ((747 + 149) > (13898 - 9129))) then
								local v258 = 949 - (551 + 398);
								while true do
									if ((v258 == (1 + 0)) or ((372 + 673) <= (829 + 191))) then
										v89 = v75.Interrupt(v77.Kick, 29 - 21, true, v19, v78.SilenceMouseover);
										if (v89 or ((2672 - 1512) <= (107 + 221))) then
											return v89;
										end
										v258 = 7 - 5;
									end
									if (((1052 + 2756) > (3013 - (40 + 49))) and ((0 - 0) == v258)) then
										v89 = v75.Interrupt(v77.Kick, 498 - (99 + 391), true);
										if (((3219 + 672) < (21623 - 16704)) and v89) then
											return v89;
										end
										v258 = 2 - 1;
									end
									if (((2 + 0) == v258) or ((5878 - 3644) <= (3106 - (1032 + 572)))) then
										v89 = v75.InterruptWithStun(v77.KidneyShot, 425 - (203 + 214));
										if (v89 or ((4329 - (568 + 1249)) < (338 + 94))) then
											return v89;
										end
										break;
									end
								end
							end
							v104 = v76.PoisonedBleeds();
							v105 = v13:EnergyRegen() + ((v104 * (14 - 8)) / ((7 - 5) * v13:SpellHaste()));
							v240 = 1307 - (913 + 393);
						end
						if ((v240 == (8 - 5)) or ((2610 - 762) == (1275 - (269 + 141)))) then
							if (v13:StealthUp(true, false) or (v118() > (0 - 0)) or (v117() > (1981 - (362 + 1619))) or ((6307 - (950 + 675)) <= (1751 + 2790))) then
								local v259 = 1179 - (216 + 963);
								while true do
									if ((v259 == (1287 - (485 + 802))) or ((3585 - (432 + 127)) >= (5119 - (1065 + 8)))) then
										v89 = v133();
										if (((1116 + 892) > (2239 - (635 + 966))) and v89) then
											return v89 .. " (Stealthed)";
										end
										break;
									end
								end
							end
							v89 = v131();
							if (((1277 + 498) <= (3275 - (5 + 37))) and v89) then
								return v89;
							end
							v240 = 9 - 5;
						end
						if ((v240 == (3 + 2)) or ((7190 - 2647) == (935 + 1062))) then
							if (v89 or ((6445 - 3343) < (2760 - 2032))) then
								return v89;
							end
							v242 = v129();
							if (((650 - 305) == (824 - 479)) and v242) then
								return v242;
							end
							v240 = 5 + 1;
						end
						if ((v240 == (531 - (318 + 211))) or ((13910 - 11083) < (1965 - (963 + 624)))) then
							v103 = v121();
							v109 = v122();
							v108 = v87 < (1 + 1);
							v240 = 849 - (518 + 328);
						end
						if ((v240 == (18 - 10)) or ((5555 - 2079) < (2914 - (301 + 16)))) then
							if (((9024 - 5945) < (13463 - 8669)) and v77.Mutilate:IsCastable() and (v13:ComboPoints() < (13 - 8))) then
								if (((4397 + 457) > (2535 + 1929)) and v22(v77.Mutilate)) then
									return "Cast Mutilate (Fallback)";
								end
							end
							if ((v77.Envenom:IsReady() and (v13:BuffRemains(v77.SliceandDice) < (10 - 5)) and (v13:ComboPoints() >= (3 + 1))) or ((468 + 4444) == (11947 - 8189))) then
								if (((41 + 85) <= (4501 - (829 + 190))) and v22(v77.Envenom)) then
									return "Cast Envenom (ppolling)";
								end
							end
							break;
						end
						if ((v240 == (3 - 2)) or ((3003 - 629) == (6046 - 1672))) then
							v106 = v13:EnergyDeficit() / v105;
							v107 = v105 > (86 - 51);
							v102 = v120();
							v240 = 1 + 1;
						end
						if (((515 + 1060) == (4780 - 3205)) and (v240 == (7 + 0))) then
							v89 = v135();
							if (v89 or ((2847 - (520 + 93)) == (1731 - (259 + 17)))) then
								return v89;
							end
							if (v77.Ambush:IsCastable() or (v77.AmbushOverride:IsCastable() and (v13:ComboPoints() < (1 + 3))) or ((384 + 683) > (6022 - 4243))) then
								if (((2752 - (396 + 195)) >= (2709 - 1775)) and v22(v77.Ambush)) then
									return "Ambush";
								end
							end
							v240 = 1769 - (440 + 1321);
						end
						if (((3441 - (1059 + 770)) == (7454 - 5842)) and (v240 == (549 - (424 + 121)))) then
							v241 = v75.HandleDPSPotion();
							if (((794 + 3558) >= (4180 - (641 + 706))) and v241) then
								return v241;
							end
							v89 = v132();
							v240 = 2 + 3;
						end
					end
				end
				break;
			end
		end
	end
	local function v137()
		local v182 = 440 - (249 + 191);
		while true do
			if ((v182 == (4 - 3)) or ((1439 + 1783) < (11843 - 8770))) then
				v77.Garrote:RegisterAuraTracking();
				v9.Print("Assassination Rogue by Epic. Supported by Gojira");
				break;
			end
			if (((1171 - (183 + 244)) <= (145 + 2797)) and (v182 == (730 - (434 + 296)))) then
				v77.Deathmark:RegisterAuraTracking();
				v77.Sepsis:RegisterAuraTracking();
				v182 = 2 - 1;
			end
		end
	end
	v9.SetAPL(771 - (169 + 343), v136, v137);
end;
return v0["Epix_Rogue_Assassination.lua"]();

