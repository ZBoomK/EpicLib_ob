local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((5439 - 2713) == (4168 - (63 + 236)))) then
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
	local v17 = v9.Item;
	local v18 = v9.Macro;
	local v19 = v9.Press;
	local v20 = v9.Commons.Everyone.num;
	local v21 = v9.Commons.Everyone.bool;
	local v22 = math.min;
	local v23 = math.abs;
	local v24 = math.max;
	local v25 = false;
	local v26 = false;
	local v27 = false;
	local v28 = v9.CastPooling;
	local v29 = pairs;
	local v30 = math.floor;
	local v31;
	local v32;
	local v33;
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
	local function v72()
		v31 = EpicSettings.Settings['UseRacials'];
		v33 = EpicSettings.Settings['UseHealingPotion'];
		v34 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v35 = EpicSettings.Settings['HealingPotionHP'] or (1826 - (1763 + 63));
		v36 = EpicSettings.Settings['UseHealthstone'];
		v37 = EpicSettings.Settings['HealthstoneHP'] or (1187 - (257 + 930));
		v38 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v39 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (325 - (45 + 280));
		v40 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v42 = EpicSettings.Settings['PoisonRefresh'];
		v43 = EpicSettings.Settings['PoisonRefreshCombat'];
		v44 = EpicSettings.Settings['RangedMultiDoT'];
		v45 = EpicSettings.Settings['UsePriorityRotation'];
		v50 = EpicSettings.Settings['STMfDAsDPSCD'];
		v51 = EpicSettings.Settings['KidneyShotInterrupt'];
		v52 = EpicSettings.Settings['RacialsGCD'];
		v53 = EpicSettings.Settings['RacialsOffGCD'];
		v54 = EpicSettings.Settings['VanishOffGCD'];
		v55 = EpicSettings.Settings['ShadowDanceOffGCD'];
		v56 = EpicSettings.Settings['ThistleTeaOffGCD'];
		v57 = EpicSettings.Settings['ColdBloodOffGCD'];
		v58 = EpicSettings.Settings['MarkedforDeathOffGCD'];
		v59 = EpicSettings.Settings['CrimsonVialHP'] or (1 + 0);
		v60 = EpicSettings.Settings['FeintHP'] or (1 + 0);
		v61 = EpicSettings.Settings['StealthOOC'];
		v62 = EpicSettings.Settings['EnvenomDMGOffset'] or (1 + 0);
		v63 = EpicSettings.Settings['MutilateDMGOffset'] or (1 + 0);
		v64 = EpicSettings.Settings['AlwaysSuggestGarrote'];
		v65 = EpicSettings.Settings['PotionTypeSelected'];
		v66 = EpicSettings.Settings['ExsanguinateGCD'];
		v67 = EpicSettings.Settings['KingsbaneGCD'];
		v68 = EpicSettings.Settings['ShivGCD'];
		v69 = EpicSettings.Settings['DeathmarkOffGCD'];
		v71 = EpicSettings.Settings['IndiscriminateCarnageOffGCD'];
		v70 = EpicSettings.Settings['KickOffGCD'];
	end
	local v73 = v9.Commons.Everyone;
	local v74 = v9.Commons.Rogue;
	local v75 = v15.Rogue.Assassination;
	local v76 = v18.Rogue.Assassination;
	local v77 = v17.Rogue.Assassination;
	local v78 = {v77.AlgetharPuzzleBox,v77.AshesoftheEmbersoul,v77.WitherbarksBranch};
	local v79, v80, v81, v82;
	local v83, v84, v85, v86;
	local v87;
	local v88, v89 = (1774 - (1733 + 39)) * v13:SpellHaste(), (2 - 1) * v13:SpellHaste();
	local v90, v91;
	local v92, v93, v94, v95, v96, v97, v98;
	local v99;
	local v100, v101, v102, v103, v104, v105, v106, v107;
	local v108 = 1034 - (125 + 909);
	local v109 = v13:GetEquipment();
	local v110 = (v109[1961 - (1096 + 852)] and v17(v109[6 + 7])) or v17(0 - 0);
	local v111 = (v109[14 + 0] and v17(v109[526 - (409 + 103)])) or v17(236 - (46 + 190));
	local function v112()
		if ((v110:HasStatAnyDps() and (not v111:HasStatAnyDps() or (v110:Cooldown() >= v111:Cooldown()))) or ((4471 - (51 + 44)) <= (418 + 1063))) then
			v108 = 1318 - (1114 + 203);
		elseif ((v111:HasStatAnyDps() and (not v110:HasStatAnyDps() or (v111:Cooldown() > v110:Cooldown()))) or ((4118 - (228 + 498)) >= (1028 + 3713))) then
			v108 = 2 + 0;
		else
			v108 = 663 - (174 + 489);
		end
	end
	v112();
	v9:RegisterForEvent(function()
		v109 = v13:GetEquipment();
		v110 = (v109[33 - 20] and v17(v109[1918 - (830 + 1075)])) or v17(524 - (303 + 221));
		v111 = (v109[1283 - (231 + 1038)] and v17(v109[12 + 2])) or v17(1162 - (171 + 991));
		v112();
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v113 = {{v75.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v75.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v90 > (1248 - (111 + 1137));
	end}};
	v75.Envenom:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v90 * (158.22 - (91 + 67)) * (2 - 1) * ((v14:DebuffUp(v75.ShivDebuff) and (1.3 + 0)) or (524 - (423 + 100))) * ((v75.DeeperStratagem:IsAvailable() and (1.05 + 0)) or (2 - 1)) * (1 + 0 + (v13:MasteryPct() / (871 - (326 + 445)))) * ((4 - 3) + (v13:VersatilityDmgPct() / (222 - 122)));
	end);
	v75.Mutilate:RegisterDamageFormula(function()
		return (v13:AttackPowerDamageMod() + v13:AttackPowerDamageMod(true)) * (0.485 - 0) * (712 - (530 + 181)) * ((882 - (614 + 267)) + (v13:VersatilityDmgPct() / (132 - (19 + 13))));
	end);
	local function v114()
		return v13:BuffRemains(v75.MasterAssassinBuff) == (16273 - 6274);
	end
	local function v115()
		local v161 = 0 - 0;
		while true do
			if (((9498 - 6173) >= (560 + 1594)) and (v161 == (0 - 0))) then
				if (v114() or ((2685 - 1390) >= (5045 - (1293 + 519)))) then
					return v13:GCDRemains() + (5 - 2);
				end
				return v13:BuffRemains(v75.MasterAssassinBuff);
			end
		end
	end
	local function v116()
		local v162 = 0 - 0;
		while true do
			if (((8369 - 3992) > (7080 - 5438)) and (v162 == (0 - 0))) then
				if (((2502 + 2221) > (277 + 1079)) and v13:BuffUp(v75.ImprovedGarroteAura)) then
					return v13:GCDRemains() + (6 - 3);
				end
				return v13:BuffRemains(v75.ImprovedGarroteBuff);
			end
		end
	end
	local function v117()
		local v163 = 0 + 0;
		while true do
			if ((v163 == (0 + 0)) or ((2585 + 1551) <= (4529 - (709 + 387)))) then
				if (((6103 - (673 + 1185)) <= (13430 - 8799)) and v13:BuffUp(v75.IndiscriminateCarnageAura)) then
					return v13:GCDRemains() + (32 - 22);
				end
				return v13:BuffRemains(v75.IndiscriminateCarnageBuff);
			end
		end
	end
	local function v45()
		local v164 = 0 - 0;
		while true do
			if (((3059 + 1217) >= (2925 + 989)) and (v164 == (0 - 0))) then
				if (((49 + 149) <= (8703 - 4338)) and (v85 < (3 - 1))) then
					return false;
				elseif (((6662 - (446 + 1434)) > (5959 - (1040 + 243))) and (v45 == "Always")) then
					return true;
				elseif (((14517 - 9653) > (4044 - (559 + 1288))) and (v45 == "On Bosses") and v14:IsInBossList()) then
					return true;
				elseif ((v45 == "Auto") or ((5631 - (609 + 1322)) == (2961 - (13 + 441)))) then
					if (((16718 - 12244) >= (717 - 443)) and (v13:InstanceDifficulty() == (79 - 63)) and (v14:NPCID() == (5175 + 133792))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v118()
		local v165 = 0 - 0;
		while true do
			if ((v165 == (0 + 0)) or ((830 + 1064) <= (4172 - 2766))) then
				if (((861 + 711) >= (2815 - 1284)) and (v14:DebuffUp(v75.Deathmark) or v14:DebuffUp(v75.Kingsbane) or v13:BuffUp(v75.ShadowDanceBuff) or v14:DebuffUp(v75.ShivDebuff) or (v75.ThistleTea:FullRechargeTime() < (14 + 6)) or (v13:EnergyPercentage() >= (45 + 35)) or (v13:HasTier(23 + 8, 4 + 0) and ((v13:BuffUp(v75.Envenom) and (v13:BuffRemains(v75.Envenom) <= (2 + 0))) or v9.BossFilteredFightRemains("<=", 523 - (153 + 280)))))) then
					return true;
				end
				return false;
			end
		end
	end
	local function v119()
		local v166 = 0 - 0;
		while true do
			if ((v166 == (0 + 0)) or ((1851 + 2836) < (2377 + 2165))) then
				if (((2987 + 304) > (1208 + 459)) and (v75.Deathmark:CooldownRemains() > v75.Sepsis:CooldownRemains()) and (v9.BossFightRemainsIsNotValid() or v9.BossFilteredFightRemains(">", v75.Deathmark:CooldownRemains()))) then
					return v75.Deathmark:CooldownRemains();
				end
				return v75.Sepsis:CooldownRemains();
			end
		end
	end
	local function v120()
		local v167 = 0 - 0;
		while true do
			if ((v167 == (0 + 0)) or ((1540 - (89 + 578)) == (1454 + 580))) then
				if (not v75.ScentOfBlood:IsAvailable() or ((5853 - 3037) < (1060 - (572 + 477)))) then
					return true;
				end
				return v13:BuffStack(v75.ScentOfBloodBuff) >= v22(3 + 17, v75.ScentOfBlood:TalentRank() * (2 + 0) * v85);
			end
		end
	end
	local function v121(v168, v169, v170)
		local v171 = 0 + 0;
		local v170;
		while true do
			if (((3785 - (84 + 2)) < (7755 - 3049)) and (v171 == (0 + 0))) then
				v170 = v170 or v169:PandemicThreshold();
				return v168:DebuffRefreshable(v169, v170);
			end
		end
	end
	local function v122(v172, v173, v174, v175)
		local v176, v177 = nil, v174;
		local v178 = v14:GUID();
		for v201, v202 in v29(v175) do
			if (((3488 - (497 + 345)) >= (23 + 853)) and (v202:GUID() ~= v178) and v73.UnitIsCycleValid(v202, v177, -v202:DebuffRemains(v172)) and v173(v202)) then
				v176, v177 = v202, v202:TimeToDie();
			end
		end
		if (((104 + 510) <= (4517 - (605 + 728))) and v176) then
			v19(v176, v172);
		elseif (((2231 + 895) == (6949 - 3823)) and v44) then
			local v215 = 0 + 0;
			while true do
				if (((3 - 2) == v215) or ((1972 + 215) >= (13725 - 8771))) then
					if (v176 or ((2928 + 949) == (4064 - (457 + 32)))) then
						v19(v176, v172);
					end
					break;
				end
				if (((300 + 407) > (2034 - (832 + 570))) and (v215 == (0 + 0))) then
					v176, v177 = nil, v174;
					for v233, v234 in v29(v84) do
						if (((v234:GUID() ~= v178) and v73.UnitIsCycleValid(v234, v177, -v234:DebuffRemains(v172)) and v173(v234)) or ((143 + 403) >= (9497 - 6813))) then
							v176, v177 = v234, v234:TimeToDie();
						end
					end
					v215 = 1 + 0;
				end
			end
		end
	end
	local function v123(v179, v180, v181)
		local v182 = 796 - (588 + 208);
		local v183;
		local v184;
		local v185;
		local v186;
		while true do
			if (((3948 - 2483) <= (6101 - (884 + 916))) and ((6 - 3) == v182)) then
				if (((989 + 715) > (2078 - (232 + 421))) and v44) then
					v186(v84);
				end
				if ((v184 and (v185 == v183) and v181(v14)) or ((2576 - (1569 + 320)) == (1039 + 3195))) then
					return v14;
				end
				v182 = 1 + 3;
			end
			if ((v182 == (13 - 9)) or ((3935 - (316 + 289)) < (3740 - 2311))) then
				if (((53 + 1094) >= (1788 - (666 + 787))) and v184 and v181(v184)) then
					return v184;
				end
				return nil;
			end
			if (((3860 - (360 + 65)) > (1960 + 137)) and (v182 == (255 - (79 + 175)))) then
				v184, v185 = nil, 0 - 0;
				v186 = nil;
				v182 = 2 + 0;
			end
			if ((v182 == (0 - 0)) or ((7260 - 3490) >= (4940 - (503 + 396)))) then
				v183 = v180(v14);
				if (((v179 == "first") and (v183 ~= (181 - (92 + 89)))) or ((7354 - 3563) <= (827 + 784))) then
					return v14;
				end
				v182 = 1 + 0;
			end
			if ((v182 == (7 - 5)) or ((627 + 3951) <= (4578 - 2570))) then
				function v186(v216)
					for v219, v220 in v29(v216) do
						local v221 = v180(v220);
						if (((982 + 143) <= (992 + 1084)) and not v184 and (v179 == "first")) then
							if ((v221 ~= (0 - 0)) or ((93 + 650) >= (6707 - 2308))) then
								v184, v185 = v220, v221;
							end
						elseif (((2399 - (485 + 759)) < (3870 - 2197)) and (v179 == "min")) then
							if (not v184 or (v221 < v185) or ((3513 - (442 + 747)) <= (1713 - (832 + 303)))) then
								v184, v185 = v220, v221;
							end
						elseif (((4713 - (88 + 858)) == (1149 + 2618)) and (v179 == "max")) then
							if (((3385 + 704) == (169 + 3920)) and (not v184 or (v221 > v185))) then
								v184, v185 = v220, v221;
							end
						end
						if (((5247 - (766 + 23)) >= (8264 - 6590)) and v184 and (v221 == v185) and (v220:TimeToDie() > v184:TimeToDie())) then
							v184, v185 = v220, v221;
						end
					end
				end
				v186(v86);
				v182 = 3 - 0;
			end
		end
	end
	local function v124(v187, v188, v189)
		local v190 = v14:TimeToDie();
		if (((2560 - 1588) <= (4812 - 3394)) and not v9.BossFightRemainsIsNotValid()) then
			v190 = v9.BossFightRemains();
		elseif ((v190 < v189) or ((6011 - (1036 + 37)) < (3377 + 1385))) then
			return false;
		end
		if ((v30((v190 - v189) / v187) > v30(((v190 - v189) - v188) / v187)) or ((4875 - 2371) > (3355 + 909))) then
			return true;
		end
		return false;
	end
	local function v125(v191)
		if (((3633 - (641 + 839)) == (3066 - (910 + 3))) and v191:DebuffUp(v75.SerratedBoneSpikeDebuff)) then
			return 2549297 - 1549297;
		end
		return v191:TimeToDie();
	end
	local function v126(v192)
		return not v192:DebuffUp(v75.SerratedBoneSpikeDebuff);
	end
	local function v127()
		local v193 = 1684 - (1466 + 218);
		while true do
			if ((v193 == (0 + 0)) or ((1655 - (556 + 592)) >= (922 + 1669))) then
				if (((5289 - (329 + 479)) == (5335 - (174 + 680))) and v75.BloodFury:IsCastable()) then
					if (v9.Press(v75.BloodFury, v53) or ((7999 - 5671) < (1435 - 742))) then
						return "Cast Blood Fury";
					end
				end
				if (((3091 + 1237) == (5067 - (396 + 343))) and v75.Berserking:IsCastable()) then
					if (((141 + 1447) >= (2809 - (29 + 1448))) and v9.Press(v75.Berserking, v53)) then
						return "Cast Berserking";
					end
				end
				v193 = 1390 - (135 + 1254);
			end
			if ((v193 == (7 - 5)) or ((19488 - 15314) > (2832 + 1416))) then
				return false;
			end
			if ((v193 == (1528 - (389 + 1138))) or ((5160 - (102 + 472)) <= (78 + 4))) then
				if (((2143 + 1720) == (3602 + 261)) and v75.Fireblood:IsCastable()) then
					if (v9.Press(v75.Fireblood, v53) or ((1827 - (320 + 1225)) <= (74 - 32))) then
						return "Cast Fireblood";
					end
				end
				if (((2821 + 1788) >= (2230 - (157 + 1307))) and v75.AncestralCall:IsCastable()) then
					if ((not v75.Kingsbane:IsAvailable() and v14:DebuffUp(v75.ShivDebuff)) or (v14:DebuffUp(v75.Kingsbane) and (v14:DebuffRemains(v75.Kingsbane) < (1867 - (821 + 1038)))) or ((2873 - 1721) == (273 + 2215))) then
						if (((6077 - 2655) > (1247 + 2103)) and v9.Press(v75.AncestralCall, v53)) then
							return "Cast Ancestral Call";
						end
					end
				end
				v193 = 4 - 2;
			end
		end
	end
	local function v128()
		if (((1903 - (834 + 192)) > (24 + 352)) and v75.ShadowDance:IsCastable() and not v75.Kingsbane:IsAvailable()) then
			if ((v75.ImprovedGarrote:IsAvailable() and v75.Garrote:CooldownUp() and ((v14:PMultiplier(v75.Garrote) <= (1 + 0)) or v121(v14, v75.Garrote)) and (v75.Deathmark:AnyDebuffUp() or (v75.Deathmark:CooldownRemains() < (1 + 11)) or (v75.Deathmark:CooldownRemains() > (92 - 32))) and (v91 >= math.min(v85, 308 - (300 + 4)))) or ((833 + 2285) <= (4845 - 2994))) then
				if ((v49 and (v13:EnergyPredicted() < (407 - (112 + 250)))) or ((66 + 99) >= (8748 - 5256))) then
					if (((2263 + 1686) < (2512 + 2344)) and v19(v75.PoolEnergy)) then
						return "Pool for Shadow Dance (Garrote)";
					end
				end
				if (v19(v75.ShadowDance, v55) or ((3198 + 1078) < (1496 + 1520))) then
					return "Cast Shadow Dance (Garrote)";
				end
			end
			if (((3485 + 1205) > (5539 - (1001 + 413))) and not v75.ImprovedGarrote:IsAvailable() and v75.MasterAssassin:IsAvailable() and not v121(v14, v75.Rupture) and (v14:DebuffRemains(v75.Garrote) > (6 - 3)) and (v14:DebuffUp(v75.Deathmark) or (v75.Deathmark:CooldownRemains() > (942 - (244 + 638)))) and (v14:DebuffUp(v75.ShivDebuff) or (v14:DebuffRemains(v75.Deathmark) < (697 - (627 + 66))) or v14:DebuffUp(v75.Sepsis)) and (v14:DebuffRemains(v75.Sepsis) < (8 - 5))) then
				if (v19(v75.ShadowDance, v55) or ((652 - (512 + 90)) >= (2802 - (1665 + 241)))) then
					return "Cast Shadow Dance (Master Assassin)";
				end
			end
		end
		if ((v75.Vanish:IsCastable() and not v13:IsTanking(v14)) or ((2431 - (373 + 344)) >= (1335 + 1623))) then
			local v203 = 0 + 0;
			while true do
				if ((v203 == (2 - 1)) or ((2522 - 1031) < (1743 - (35 + 1064)))) then
					if (((513 + 191) < (2111 - 1124)) and not v75.ImprovedGarrote:IsAvailable() and v75.MasterAssassin:IsAvailable() and not v121(v14, v75.Rupture) and (v14:DebuffRemains(v75.Garrote) > (1 + 2)) and v14:DebuffUp(v75.Deathmark) and (v14:DebuffUp(v75.ShivDebuff) or (v14:DebuffRemains(v75.Deathmark) < (1240 - (298 + 938))) or v14:DebuffUp(v75.Sepsis)) and (v14:DebuffRemains(v75.Sepsis) < (1262 - (233 + 1026)))) then
						if (((5384 - (636 + 1030)) > (975 + 931)) and v19(v75.Vanish, v54)) then
							return "Cast Vanish (Master Assassin)";
						end
					end
					break;
				end
				if ((v203 == (0 + 0)) or ((285 + 673) > (246 + 3389))) then
					if (((3722 - (55 + 166)) <= (871 + 3621)) and v75.ImprovedGarrote:IsAvailable() and not v75.MasterAssassin:IsAvailable() and v75.Garrote:CooldownUp() and ((v14:PMultiplier(v75.Garrote) <= (1 + 0)) or v121(v14, v75.Garrote))) then
						local v231 = 0 - 0;
						while true do
							if ((v231 == (297 - (36 + 261))) or ((6019 - 2577) < (3916 - (34 + 1334)))) then
								if (((1106 + 1769) >= (1138 + 326)) and not v75.IndiscriminateCarnage:IsAvailable() and (v75.Deathmark:AnyDebuffUp() or (v75.Deathmark:CooldownRemains() < (1287 - (1035 + 248)))) and (v91 >= v22(v85, 25 - (20 + 1)))) then
									if ((v49 and (v13:EnergyPredicted() < (24 + 21))) or ((5116 - (134 + 185)) >= (6026 - (549 + 584)))) then
										if (v19(v75.PoolEnergy) or ((1236 - (314 + 371)) > (7099 - 5031))) then
											return "Pool for Vanish (Garrote Deathmark)";
										end
									end
									if (((3082 - (478 + 490)) > (501 + 443)) and v19(v75.Vanish, v54)) then
										return "Cast Vanish (Garrote Deathmark)";
									end
								end
								if ((v75.IndiscriminateCarnage:IsAvailable() and (v85 > (1174 - (786 + 386)))) or ((7326 - 5064) >= (4475 - (1055 + 324)))) then
									if ((v49 and (v13:EnergyPredicted() < (1385 - (1093 + 247)))) or ((2004 + 251) >= (372 + 3165))) then
										if (v19(v75.PoolEnergy) or ((15233 - 11396) < (4431 - 3125))) then
											return "Pool for Vanish (Garrote Deathmark)";
										end
									end
									if (((8394 - 5444) == (7413 - 4463)) and v19(v75.Vanish, v54)) then
										return "Cast Vanish (Garrote Cleave)";
									end
								end
								break;
							end
						end
					end
					if ((v75.MasterAssassin:IsAvailable() and v75.Kingsbane:IsAvailable() and v14:DebuffUp(v75.Kingsbane) and (v14:DebuffRemains(v75.Kingsbane) <= (2 + 1)) and v14:DebuffUp(v75.Deathmark) and (v14:DebuffRemains(v75.Deathmark) <= (11 - 8))) or ((16278 - 11555) < (2487 + 811))) then
						if (((2905 - 1769) >= (842 - (364 + 324))) and v19(v75.Vanish, v54)) then
							return "Cast Vanish (Kingsbane)";
						end
					end
					v203 = 2 - 1;
				end
			end
		end
	end
	local function v129()
		v87 = v73.HandleTopTrinket(v78, v27, 95 - 55, nil);
		if (v87 or ((90 + 181) > (19867 - 15119))) then
			return v87;
		end
		v87 = v73.HandleBottomTrinket(v78, v27, 64 - 24, nil);
		if (((14395 - 9655) >= (4420 - (1249 + 19))) and v87) then
			return v87;
		end
	end
	local function v130()
		local v194 = 0 + 0;
		local v195;
		while true do
			if ((v194 == (3 - 2)) or ((3664 - (686 + 400)) >= (2660 + 730))) then
				if (((270 - (73 + 156)) <= (8 + 1653)) and v75.Deathmark:IsCastable() and (v195 or v9.BossFilteredFightRemains("<=", 831 - (721 + 90)))) then
					if (((7 + 594) < (11558 - 7998)) and v19(v75.Deathmark)) then
						return "Cast Deathmark";
					end
				end
				if (((705 - (224 + 246)) < (1112 - 425)) and v75.Shiv:IsReady() and not v14:DebuffUp(v75.ShivDebuff) and v14:DebuffUp(v75.Garrote) and v14:DebuffUp(v75.Rupture)) then
					if (((8375 - 3826) > (210 + 943)) and v9.BossFilteredFightRemains("<=", v75.Shiv:Charges() * (1 + 7))) then
						if (v19(v75.Shiv) or ((3433 + 1241) < (9288 - 4616))) then
							return "Cast Shiv (End of Fight)";
						end
					end
					if (((12206 - 8538) < (5074 - (203 + 310))) and v75.Kingsbane:IsAvailable() and v13:BuffUp(v75.Envenom)) then
						if ((not v75.LightweightShiv:IsAvailable() and ((v14:DebuffUp(v75.Kingsbane) and (v14:DebuffRemains(v75.Kingsbane) < (2001 - (1238 + 755)))) or (v75.Kingsbane:CooldownRemains() >= (2 + 22))) and (not v75.CrimsonTempest:IsAvailable() or v106 or v14:DebuffUp(v75.CrimsonTempest))) or ((1989 - (709 + 825)) == (6642 - 3037))) then
							if (v19(v75.Shiv) or ((3878 - 1215) == (4176 - (196 + 668)))) then
								return "Cast Shiv (Kingsbane)";
							end
						end
						if (((16886 - 12609) <= (9269 - 4794)) and v75.LightweightShiv:IsAvailable() and (v14:DebuffUp(v75.Kingsbane) or (v75.Kingsbane:CooldownRemains() <= (834 - (171 + 662))))) then
							if (v19(v75.Shiv) or ((963 - (4 + 89)) == (4167 - 2978))) then
								return "Cast Shiv (Kingsbane Lightweight)";
							end
						end
					end
					if (((566 + 987) <= (13760 - 10627)) and v75.ArterialPrecision:IsAvailable() and v75.Deathmark:AnyDebuffUp()) then
						if (v19(v75.Shi) or ((878 + 1359) >= (4997 - (35 + 1451)))) then
							return "Cast Shiv (Arterial Precision)";
						end
					end
					if ((not v75.Kingsbane:IsAvailable() and not v75.ArterialPrecision:IsAvailable()) or ((2777 - (28 + 1425)) > (5013 - (941 + 1052)))) then
						if (v75.Sepsis:IsAvailable() or ((2869 + 123) == (3395 - (822 + 692)))) then
							if (((4433 - 1327) > (719 + 807)) and (((v75.Shiv:ChargesFractional() > ((297.9 - (45 + 252)) + v20(v75.LightweightShiv:IsAvailable()))) and (v101 > (5 + 0))) or v14:DebuffUp(v75.Sepsis) or v14:DebuffUp(v75.Deathmark))) then
								if (((1041 + 1982) < (9418 - 5548)) and v19(v75.Shiv)) then
									return "Cast Shiv (Sepsis)";
								end
							end
						elseif (((576 - (114 + 319)) > (106 - 32)) and (not v75.CrimsonTempest:IsAvailable() or v106 or v14:DebuffUp(v75.CrimsonTempest))) then
							if (((22 - 4) < (1347 + 765)) and v19(v75.Shiv)) then
								return "Cast Shiv";
							end
						end
					end
				end
				if (((1633 - 536) <= (3410 - 1782)) and v75.ShadowDance:IsCastable() and v75.Kingsbane:IsAvailable() and v13:BuffUp(v75.Envenom) and ((v75.Deathmark:CooldownRemains() >= (2013 - (556 + 1407))) or v195)) then
					if (((5836 - (741 + 465)) == (5095 - (170 + 295))) and v19(v75.ShadowDance)) then
						return "Cast Shadow Dance (Kingsbane Sync)";
					end
				end
				if (((1866 + 1674) > (2465 + 218)) and v75.Kingsbane:IsReady() and (v14:DebuffUp(v75.ShivDebuff) or (v75.Shiv:CooldownRemains() < (14 - 8))) and v13:BuffUp(v75.Envenom) and ((v75.Deathmark:CooldownRemains() >= (42 + 8)) or v14:DebuffUp(v75.Deathmark))) then
					if (((3075 + 1719) >= (1855 + 1420)) and v19(v75.Kingsbane)) then
						return "Cast Kingsbane";
					end
				end
				v194 = 1232 - (957 + 273);
			end
			if (((397 + 1087) == (595 + 889)) and (v194 == (7 - 5))) then
				if (((3773 - 2341) < (10858 - 7303)) and v75.ThistleTea:IsCastable() and not v13:BuffUp(v75.ThistleTea) and (((v13:EnergyDeficit() >= ((495 - 395) + v103)) and (not v75.Kingsbane:IsAvailable() or (v75.ThistleTea:Charges() >= (1782 - (389 + 1391))))) or (v14:DebuffUp(v75.Kingsbane) and (v14:DebuffRemains(v75.Kingsbane) < (4 + 2))) or (not v75.Kingsbane:IsAvailable() and v75.Deathmark:AnyDebuffUp()) or v9.BossFilteredFightRemains("<", v75.ThistleTea:Charges() * (1 + 5)))) then
					if (v9.Cast(v75.ThistleTea) or ((2424 - 1359) > (4529 - (783 + 168)))) then
						return "Cast Thistle Tea";
					end
				end
				if ((v75.Deathmark:AnyDebuffUp() and (not v87 or v53)) or ((16092 - 11297) < (1384 + 23))) then
					if (((2164 - (309 + 2)) < (14780 - 9967)) and v87) then
						v127();
					else
						v87 = v127();
					end
				end
				if ((not v13:StealthUp(true, true) and (v116() <= (1212 - (1090 + 122))) and (v115() <= (0 + 0))) or ((9474 - 6653) < (1664 + 767))) then
					if (v87 or ((3992 - (628 + 490)) < (392 + 1789))) then
						v128();
					else
						v87 = v128();
					end
				end
				if ((v75.ColdBlood:IsReady() and v13:DebuffDown(v75.ColdBlood) and (v90 >= (9 - 5))) or ((12288 - 9599) <= (1117 - (431 + 343)))) then
					if (v9.Press(v75.ColdBlood) or ((3774 - 1905) == (5811 - 3802))) then
						return "Cast Cold Blood";
					end
				end
				v194 = 3 + 0;
			end
			if ((v194 == (0 + 0)) or ((5241 - (556 + 1139)) < (2337 - (6 + 9)))) then
				if ((v75.Sepsis:IsReady() and (v14:DebuffRemains(v75.Rupture) > (4 + 16)) and ((not v75.ImprovedGarrote:IsAvailable() and v14:DebuffUp(v75.Garrote)) or (v75.ImprovedGarrote:IsAvailable() and v75.Garrote:CooldownUp() and (v14:PMultiplier(v75.Garrote) <= (1 + 0)))) and (v14:FilteredTimeToDie(">", 179 - (28 + 141)) or v9.BossFilteredFightRemains("<=", 4 + 6))) or ((2569 - 487) == (3381 + 1392))) then
					if (((4561 - (486 + 831)) > (2745 - 1690)) and v19(v75.Sepsis, nil, true)) then
						return "Cast Sepsis";
					end
				end
				v87 = v129();
				if (v87 or ((11663 - 8350) <= (336 + 1442))) then
					return v87;
				end
				v195 = not v13:StealthUp(true, false) and v14:DebuffUp(v75.Rupture) and v13:BuffUp(v75.Envenom) and not v75.Deathmark:AnyDebuffUp() and (not v75.MasterAssassin:IsAvailable() or v14:DebuffUp(v75.Garrote)) and (not v75.Kingsbane:IsAvailable() or (v75.Kingsbane:CooldownRemains() <= (6 - 4)));
				v194 = 1264 - (668 + 595);
			end
			if (((3 + 0) == v194) or ((287 + 1134) >= (5737 - 3633))) then
				return v87;
			end
		end
	end
	local function v131()
		local v196 = 290 - (23 + 267);
		while true do
			if (((3756 - (1129 + 815)) <= (3636 - (371 + 16))) and (v196 == (1752 - (1326 + 424)))) then
				if (((3073 - 1450) <= (7151 - 5194)) and (v90 >= (122 - (88 + 30))) and (v14:PMultiplier(v75.Rupture) <= (772 - (720 + 51))) and (v13:BuffUp(v75.ShadowDanceBuff) or v14:DebuffUp(v75.Deathmark))) then
					if (((9814 - 5402) == (6188 - (421 + 1355))) and v19(v75.Rupture, nil, nil, not v81)) then
						return "Cast Rupture (Nightstalker)";
					end
				end
				break;
			end
			if (((2887 - 1137) >= (414 + 428)) and (v196 == (1084 - (286 + 797)))) then
				if (((15982 - 11610) > (3064 - 1214)) and v26 and v75.CrimsonTempest:IsReady() and v75.Nightstalker:IsAvailable() and (v85 >= (442 - (397 + 42))) and (v90 >= (2 + 2)) and not v75.Deathmark:IsReady()) then
					for v228, v229 in v29(v84) do
						if (((1032 - (24 + 776)) < (1264 - 443)) and v121(v229, v75.CrimsonTempest, v93) and v229:FilteredTimeToDie(">", 791 - (222 + 563), -v229:DebuffRemains(v75.CrimsonTempest))) then
							if (((1141 - 623) < (650 + 252)) and v19(v75.CrimsonTempest)) then
								return "Cast Crimson Tempest (Stealth)";
							end
						end
					end
				end
				if (((3184 - (23 + 167)) > (2656 - (690 + 1108))) and v75.Garrote:IsCastable() and (v116() > (0 + 0))) then
					local v222 = 0 + 0;
					local v223;
					local v224;
					while true do
						if (((851 - (40 + 808)) == v222) or ((619 + 3136) <= (3498 - 2583))) then
							if (((3772 + 174) > (1981 + 1762)) and (v91 >= (1 + 0 + ((573 - (47 + 524)) * v20(v75.ShroudedSuffocation:IsAvailable()))))) then
								local v237 = 0 + 0;
								while true do
									if ((v237 == (0 - 0)) or ((1996 - 661) >= (7539 - 4233))) then
										if (((6570 - (1165 + 561)) > (67 + 2186)) and v13:BuffDown(v75.ShadowDanceBuff) and ((v14:PMultiplier(v75.Garrote) <= (3 - 2)) or (v14:DebuffUp(v75.Deathmark) and (v115() < (2 + 1))))) then
											if (((931 - (341 + 138)) == (123 + 329)) and v19(v75.Garrote, nil, nil, not v81)) then
												return "Cast Garrote (Improved Garrote Low CP)";
											end
										end
										if ((v14:PMultiplier(v75.Garrote) <= (1 - 0)) or (v14:DebuffRemains(v75.Garrote) < (338 - (89 + 237))) or ((14659 - 10102) < (4393 - 2306))) then
											if (((4755 - (581 + 300)) == (5094 - (855 + 365))) and v19(v75.Garrote, nil, nil, not v81)) then
												return "Cast Garrote (Improved Garrote Low CP 2)";
											end
										end
										break;
									end
								end
							end
							break;
						end
						if ((v222 == (4 - 2)) or ((633 + 1305) > (6170 - (1030 + 205)))) then
							if (v26 or ((3995 + 260) < (3185 + 238))) then
								local v238 = v123("min", v223, v224);
								if (((1740 - (156 + 130)) <= (5659 - 3168)) and v238 and (v238:GUID() ~= v14:GUID())) then
									v19(v238, v75.Garrote);
								end
							end
							if (v224(v14) or ((7005 - 2848) <= (5740 - 2937))) then
								if (((1279 + 3574) >= (1739 + 1243)) and v19(v75.Garrote, nil, nil, not v81)) then
									return "Cast Garrote (Improved Garrote)";
								end
							end
							v222 = 72 - (10 + 59);
						end
						if (((1170 + 2964) > (16532 - 13175)) and (v222 == (1164 - (671 + 492)))) then
							v224 = nil;
							function v224(v235)
								return ((v235:PMultiplier(v75.Garrote) <= (1 + 0)) or (v235:DebuffRemains(v75.Garrote) < ((1227 - (369 + 846)) / v74.ExsanguinatedRate(v235, v75.Garrote))) or ((v117() > (0 + 0)) and (v75.Garrote:AuraActiveCount() < v85))) and not v106 and (v235:FilteredTimeToDie(">", 2 + 0, -v235:DebuffRemains(v75.Garrote)) or v235:TimeToDieIsNotValid()) and v74.CanDoTUnit(v235, v95);
							end
							v222 = 1947 - (1036 + 909);
						end
						if (((0 + 0) == v222) or ((5736 - 2319) < (2737 - (11 + 192)))) then
							v223 = nil;
							function v223(v236)
								return v236:DebuffRemains(v75.Garrote);
							end
							v222 = 1 + 0;
						end
					end
				end
				v196 = 177 - (135 + 40);
			end
			if ((v196 == (0 - 0)) or ((1641 + 1081) <= (361 - 197))) then
				if ((v75.Kingsbane:IsAvailable() and v13:BuffUp(v75.Envenom)) or ((3609 - 1201) < (2285 - (50 + 126)))) then
					local v225 = 0 - 0;
					while true do
						if ((v225 == (0 + 0)) or ((1446 - (1233 + 180)) == (2424 - (522 + 447)))) then
							if ((v75.Shiv:IsReady() and (v14:DebuffUp(v75.Kingsbane) or v75.Kingsbane:CooldownUp()) and v14:DebuffDown(v75.ShivDebuff)) or ((1864 - (107 + 1314)) >= (1864 + 2151))) then
								if (((10305 - 6923) > (71 + 95)) and v19(v75.Shiv)) then
									return "Cast Shiv (Stealth Kingsbane)";
								end
							end
							if ((v75.Kingsbane:IsReady() and (v13:BuffRemains(v75.ShadowDanceBuff) >= (3 - 1))) or ((1107 - 827) == (4969 - (716 + 1194)))) then
								if (((33 + 1848) > (139 + 1154)) and v19(v75.Kingsbane, v67)) then
									return "Cast Kingsbane (Dance)";
								end
							end
							break;
						end
					end
				end
				if (((2860 - (74 + 429)) == (4546 - 2189)) and (v90 >= (2 + 2))) then
					if (((281 - 158) == (88 + 35)) and v14:DebuffUp(v75.Kingsbane) and (v13:BuffRemains(v75.Envenom) <= (5 - 3))) then
						if (v19(v75.Envenom, nil, nil, not v81) or ((2610 - 1554) >= (3825 - (279 + 154)))) then
							return "Cast Envenom (Stealth Kingsbane)";
						end
					end
					if ((v106 and v114() and v13:BuffDown(v75.ShadowDanceBuff)) or ((1859 - (454 + 324)) < (846 + 229))) then
						if (v19(v75.Envenom, nil, nil, not v81) or ((1066 - (12 + 5)) >= (2390 + 2042))) then
							return "Cast Envenom (Master Assassin)";
						end
					end
				end
				v196 = 2 - 1;
			end
		end
	end
	local function v132()
		if ((v26 and v75.CrimsonTempest:IsReady() and (v85 >= (1 + 1)) and (v90 >= (1097 - (277 + 816))) and (v103 > (106 - 81)) and not v75.Deathmark:IsReady()) or ((5951 - (1058 + 125)) <= (159 + 687))) then
			for v210, v211 in v29(v84) do
				if ((v121(v211, v75.CrimsonTempest, v93) and (v211:PMultiplier(v75.CrimsonTempest) <= (976 - (815 + 160))) and v211:FilteredTimeToDie(">", 25 - 19, -v211:DebuffRemains(v75.CrimsonTempest))) or ((7971 - 4613) <= (339 + 1081))) then
					if (v19(v75.CrimsonTempest) or ((10929 - 7190) <= (4903 - (41 + 1857)))) then
						return "Cast Crimson Tempest (AoE High Energy)";
					end
				end
			end
		end
		if ((v75.Garrote:IsCastable() and (v91 >= (1894 - (1222 + 671)))) or ((4287 - 2628) >= (3067 - 933))) then
			local function v204(v212)
				return v121(v212, v75.Garrote) and (v212:PMultiplier(v75.Garrote) <= (1183 - (229 + 953)));
			end
			if ((v204(v14) and v74.CanDoTUnit(v14, v95) and (v14:FilteredTimeToDie(">", 1786 - (1111 + 663), -v14:DebuffRemains(v75.Garrote)) or v14:TimeToDieIsNotValid())) or ((4839 - (874 + 705)) < (330 + 2025))) then
				if (v28(v75.Garrote, nil, not v81) or ((457 + 212) == (8777 - 4554))) then
					return "Pool for Garrote (ST)";
				end
			end
			if ((v26 and not v105 and (v85 >= (1 + 1))) or ((2371 - (642 + 37)) < (135 + 453))) then
				v122(v75.Garrote, v204, 2 + 10, v86);
			end
		end
		if ((v75.Rupture:IsReady() and (v90 >= (9 - 5))) or ((5251 - (233 + 221)) < (8442 - 4791))) then
			local v205 = 0 + 0;
			local v206;
			while true do
				if ((v205 == (1542 - (718 + 823))) or ((2629 + 1548) > (5655 - (266 + 539)))) then
					function v206(v230)
						return v121(v230, v75.Rupture, v92) and (v230:PMultiplier(v75.Rupture) <= (2 - 1)) and (v230:FilteredTimeToDie(">", v96, -v230:DebuffRemains(v75.Rupture)) or v230:TimeToDieIsNotValid());
					end
					if ((v206(v14) and v74.CanDoTUnit(v14, v94)) or ((1625 - (636 + 589)) > (2637 - 1526))) then
						if (((6292 - 3241) > (797 + 208)) and v19(v75.Rupture, nil, nil, not v81)) then
							return "Cast Rupture";
						end
					end
					v205 = 1 + 1;
				end
				if (((4708 - (657 + 358)) <= (11602 - 7220)) and (v205 == (4 - 2))) then
					if ((v26 and (not v105 or not v107)) or ((4469 - (1151 + 36)) > (3960 + 140))) then
						v122(v75.Rupture, v206, v96, v86);
					end
					break;
				end
				if ((v205 == (0 + 0)) or ((10691 - 7111) < (4676 - (1552 + 280)))) then
					v96 = (838 - (64 + 770)) + (v20(v75.DashingScoundrel:IsAvailable()) * (4 + 1)) + (v20(v75.Doomblade:IsAvailable()) * (11 - 6)) + (v20(v105) * (2 + 4));
					v206 = nil;
					v205 = 1244 - (157 + 1086);
				end
			end
		end
		if (((177 - 88) < (19665 - 15175)) and v75.Garrote:IsCastable() and (v91 >= (1 - 0)) and (v115() <= (0 - 0)) and ((v14:PMultiplier(v75.Garrote) <= (820 - (599 + 220))) or ((v14:DebuffRemains(v75.Garrote) < v88) and (v85 >= (5 - 2)))) and (v14:DebuffRemains(v75.Garrote) < (v88 * (1933 - (1813 + 118)))) and (v85 >= (3 + 0)) and (v14:FilteredTimeToDie(">", 1221 - (841 + 376), -v14:DebuffRemains(v75.Garrote)) or v14:TimeToDieIsNotValid())) then
			if (v19(v75.Garrote, nil, nil, not v81) or ((6981 - 1998) < (421 + 1387))) then
				return "Garrote (Fallback)";
			end
		end
		return false;
	end
	local function v133()
		if (((10451 - 6622) > (4628 - (464 + 395))) and v75.Envenom:IsReady() and (v90 >= (10 - 6)) and (v100 or (v14:DebuffStack(v75.AmplifyingPoisonDebuff) >= (10 + 10)) or (v90 > v74.CPMaxSpend()) or not v106)) then
			if (((2322 - (467 + 370)) <= (6001 - 3097)) and v19(v75.Envenom, nil, nil, not v81)) then
				return "Cast Envenom";
			end
		end
		if (((3134 + 1135) == (14634 - 10365)) and not ((v91 > (1 + 0)) or v100 or not v106)) then
			return false;
		end
		if (((900 - 513) <= (3302 - (150 + 370))) and not v106 and v75.CausticSpatter:IsAvailable() and v14:DebuffUp(v75.Rupture) and (v14:DebuffRemains(v75.CausticSpatterDebuff) <= (1284 - (74 + 1208)))) then
			if (v75.Mutilate:IsCastable() or ((4670 - 2771) <= (4348 - 3431))) then
				if (v19(v75.Mutilate, nil, nil, not v81) or ((3069 + 1243) <= (1266 - (14 + 376)))) then
					return "Cast Mutilate (Casutic)";
				end
			end
			if (((3871 - 1639) <= (1680 + 916)) and (v75.Ambush:IsCastable() or v75.AmbushOverride:IsCastable()) and (v13:StealthUp(true, true) or v13:BuffUp(v75.BlindsideBuff))) then
				if (((1841 + 254) < (3516 + 170)) and v19(v75.Ambush, nil, nil, not v81)) then
					return "Cast Ambush (Caustic)";
				end
			end
		end
		if (v75.SerratedBoneSpike:IsReady() or ((4673 - 3078) >= (3366 + 1108))) then
			if (not v14:DebuffUp(v75.SerratedBoneSpikeDebuff) or ((4697 - (23 + 55)) < (6829 - 3947))) then
				if (v19(v75.SerratedBoneSpike, nil, not v82) or ((197 + 97) >= (4339 + 492))) then
					return "Cast Serrated Bone Spike";
				end
			else
				local v217 = 0 - 0;
				while true do
					if (((639 + 1390) <= (3985 - (652 + 249))) and (v217 == (0 - 0))) then
						if (v26 or ((3905 - (708 + 1160)) == (6568 - 4148))) then
							if (((8127 - 3669) > (3931 - (10 + 17))) and v73.CastTargetIf(v75.SerratedBoneSpike, v83, "min", v125, v126)) then
								return "Cast Serrated Bone (AoE)";
							end
						end
						if (((98 + 338) >= (1855 - (1400 + 332))) and (v115() < (0.8 - 0))) then
							if (((2408 - (242 + 1666)) < (778 + 1038)) and ((v9.BossFightRemains() <= (2 + 3)) or ((v75.SerratedBoneSpike:MaxCharges() - v75.SerratedBoneSpike:ChargesFractional()) <= (0.25 + 0)))) then
								if (((4514 - (850 + 90)) == (6259 - 2685)) and v19(v75.SerratedBoneSpike, nil, true, not v82)) then
									return "Cast Serrated Bone Spike (Dump Charge)";
								end
							elseif (((1611 - (360 + 1030)) < (346 + 44)) and not v106 and v14:DebuffUp(v75.ShivDebuff)) then
								if (v19(v75.SerratedBoneSpike, nil, true, not v82) or ((6245 - 4032) <= (1954 - 533))) then
									return "Cast Serrated Bone Spike (Shiv)";
								end
							end
						end
						break;
					end
				end
			end
		end
		if (((4719 - (909 + 752)) < (6083 - (109 + 1114))) and v27 and v75.EchoingReprimand:IsReady()) then
			if (v19(v75.EchoingReprimand, nil, not v81) or ((2372 - 1076) >= (1731 + 2715))) then
				return "Cast Echoing Reprimand";
			end
		end
		if (v75.FanofKnives:IsCastable() or ((1635 - (6 + 236)) > (2829 + 1660))) then
			if ((v26 and (v85 >= (1 + 0)) and not v99 and (v85 >= ((4 - 2) + v20(v13:StealthUp(true, false)) + v20(v75.DragonTemperedBlades:IsAvailable())))) or ((7726 - 3302) < (1160 - (1076 + 57)))) then
				if (v28(v75.FanofKnives) or ((329 + 1668) > (4504 - (579 + 110)))) then
					return "Cast Fan of Knives";
				end
			end
			if (((274 + 3191) > (1692 + 221)) and v26 and v13:BuffUp(v75.DeadlyPoison) and (v85 >= (2 + 1))) then
				for v226, v227 in v29(v84) do
					if (((1140 - (174 + 233)) < (5080 - 3261)) and not v227:DebuffUp(v75.DeadlyPoisonDebuff, true) and (not v99 or v227:DebuffUp(v75.Garrote) or v227:DebuffUp(v75.Rupture))) then
						if (v28(v75.FanofKnives) or ((7713 - 3318) == (2115 + 2640))) then
							return "Cast Fan of Knives (DP Refresh)";
						end
					end
				end
			end
		end
		if (((v75.Ambush:IsCastable() or v75.AmbushOverride:IsCastable()) and (v13:StealthUp(true, true) or v13:BuffUp(v75.BlindsideBuff) or v13:BuffUp(v75.SepsisBuff)) and (v14:DebuffDown(v75.Kingsbane) or v14:DebuffDown(v75.Deathmark) or v13:BuffUp(v75.BlindsideBuff))) or ((4967 - (663 + 511)) < (2114 + 255))) then
			if (v28(v75.Ambush, nil, not v81) or ((887 + 3197) == (816 - 551))) then
				return "Cast Ambush";
			end
		end
		if (((2640 + 1718) == (10259 - 5901)) and v75.Mutilate:IsCastable() and (v85 == (4 - 2)) and v14:DebuffDown(v75.DeadlyPoisonDebuff, true) and v14:DebuffDown(v75.AmplifyingPoisonDebuff, true)) then
			local v207 = v14:GUID();
			for v213, v214 in v29(v86) do
				if (((v214:GUID() ~= v207) and (v214:DebuffUp(v75.Garrote) or v214:DebuffUp(v75.Rupture)) and not v214:DebuffUp(v75.DeadlyPoisonDebuff, true) and not v214:DebuffUp(v75.AmplifyingPoisonDebuff, true)) or ((1498 + 1640) < (1932 - 939))) then
					v19(v214, v75.Mutilate);
					break;
				end
			end
		end
		if (((2374 + 956) > (213 + 2110)) and v75.Mutilate:IsCastable()) then
			if (v28(v75.Mutilate, nil, not v81) or ((4348 - (478 + 244)) == (4506 - (440 + 77)))) then
				return "Cast Mutilate";
			end
		end
		return false;
	end
	local function v134()
		v72();
		v25 = EpicSettings.Toggles['ooc'];
		v26 = EpicSettings.Toggles['aoe'];
		v27 = EpicSettings.Toggles['cds'];
		v79 = (v75.AcrobaticStrikes:IsAvailable() and (4 + 4)) or (18 - 13);
		v80 = (v75.AcrobaticStrikes:IsAvailable() and (1569 - (655 + 901))) or (2 + 8);
		v81 = v14:IsInMeleeRange(v79);
		v82 = v14:IsInMeleeRange(v80);
		if (v26 or ((702 + 214) == (1804 + 867))) then
			local v208 = 0 - 0;
			while true do
				if (((1717 - (695 + 750)) == (928 - 656)) and ((1 - 0) == v208)) then
					v85 = #v84;
					v86 = v13:GetEnemiesInMeleeRange(v79);
					break;
				end
				if (((17088 - 12839) <= (5190 - (285 + 66))) and (v208 == (0 - 0))) then
					v83 = v13:GetEnemiesInRange(1340 - (682 + 628));
					v84 = v13:GetEnemiesInMeleeRange(v80);
					v208 = 1 + 0;
				end
			end
		else
			v83 = {};
			v84 = {};
			v85 = 300 - (176 + 123);
			v86 = {};
		end
		v88, v89 = (1 + 1) * v13:SpellHaste(), (1 + 0) * v13:SpellHaste();
		v90 = v74.EffectiveComboPoints(v13:ComboPoints());
		v91 = v13:ComboPointsMax() - v90;
		v92 = ((273 - (239 + 30)) + (v90 * (2 + 2))) * (0.3 + 0);
		v93 = ((6 - 2) + (v90 * (5 - 3))) * (315.3 - (306 + 9));
		v94 = v75.Envenom:Damage() * v62;
		v95 = v75.Mutilate:Damage() * v63;
		v99 = v45();
		v87 = v74.CrimsonVial();
		if (((9690 - 6913) < (557 + 2643)) and v87) then
			return v87;
		end
		v87 = v74.Feint();
		if (((59 + 36) < (942 + 1015)) and v87) then
			return v87;
		end
		if (((2361 - 1535) < (3092 - (1140 + 235))) and not v13:AffectingCombat() and not v13:IsMounted() and v73.TargetIsValid()) then
			v87 = v74.Stealth(v75.Stealth2, nil);
			if (((908 + 518) >= (1014 + 91)) and v87) then
				return "Stealth (OOC): " .. v87;
			end
		end
		v74.Poisons();
		if (((707 + 2047) <= (3431 - (33 + 19))) and not v13:AffectingCombat()) then
			if (not v13:BuffUp(v74.VanishBuffSpell()) or ((1418 + 2509) == (4235 - 2822))) then
				local v218 = 0 + 0;
				while true do
					if ((v218 == (0 - 0)) or ((1083 + 71) <= (1477 - (586 + 103)))) then
						v87 = v74.Stealth(v74.StealthSpell());
						if (v87 or ((150 + 1493) > (10402 - 7023))) then
							return v87;
						end
						break;
					end
				end
			end
			if (v73.TargetIsValid() or ((4291 - (1309 + 179)) > (8211 - 3662))) then
				if (v27 or ((96 + 124) >= (8115 - 5093))) then
					if (((2132 + 690) == (5995 - 3173)) and v25 and v75.MarkedforDeath:IsCastable() and (v13:ComboPointsDeficit() >= v74.CPMaxSpend()) and v73.TargetIsValid()) then
						if (v9.Press(v75.MarkedforDeath, v58) or ((2114 - 1053) == (2466 - (295 + 314)))) then
							return "Cast Marked for Death (OOC)";
						end
					end
				end
				if (((6779 - 4019) > (3326 - (1300 + 662))) and not v13:BuffUp(v75.SliceandDice)) then
					if ((v75.SliceandDice:IsReady() and (v90 >= (6 - 4))) or ((6657 - (1178 + 577)) <= (1867 + 1728))) then
						if (v9.Press(v75.SliceandDice) or ((11387 - 7535) == (1698 - (851 + 554)))) then
							return "Cast Slice and Dice";
						end
					end
				end
			end
		end
		v74.MfDSniping(v75.MarkedforDeath);
		if (v73.TargetIsValid() or ((1379 + 180) == (12724 - 8136))) then
			local v209 = 0 - 0;
			while true do
				if ((v209 == (306 - (115 + 187))) or ((3434 + 1050) == (746 + 42))) then
					if (((18000 - 13432) >= (5068 - (160 + 1001))) and v27) then
						local v232 = 0 + 0;
						while true do
							if (((860 + 386) < (7103 - 3633)) and (v232 == (358 - (237 + 121)))) then
								if (((4965 - (525 + 372)) >= (1842 - 870)) and v75.ArcaneTorrent:IsCastable() and v81 and (v13:EnergyDeficit() > (49 - 34))) then
									if (((635 - (96 + 46)) < (4670 - (643 + 134))) and v19(v75.ArcaneTorrent, v31)) then
										return "Cast Arcane Torrent";
									end
								end
								if ((v75.ArcanePulse:IsCastable() and v81) or ((532 + 941) >= (7989 - 4657))) then
									if (v19(v75.ArcanePulse, v31) or ((15040 - 10989) <= (1110 + 47))) then
										return "Cast Arcane Pulse";
									end
								end
								v232 = 1 - 0;
							end
							if (((1234 - 630) < (3600 - (316 + 403))) and (v232 == (1 + 0))) then
								if ((v75.LightsJudgment:IsCastable() and v81) or ((2474 - 1574) == (1221 + 2156))) then
									if (((11229 - 6770) > (419 + 172)) and v19(v75.LightsJudgment, v31)) then
										return "Cast Lights Judgment";
									end
								end
								if (((1096 + 2302) >= (8298 - 5903)) and v75.BagofTricks:IsCastable() and v81) then
									if (v19(v75.BagofTricks, v31) or ((10425 - 8242) >= (5866 - 3042))) then
										return "Cast Bag of Tricks";
									end
								end
								break;
							end
						end
					end
					if (((111 + 1825) == (3811 - 1875)) and (v75.Ambush:IsCastable() or v75.AmbushOverride:IsCastable()) and v82) then
						if (v19(v75.Ambush) or ((237 + 4595) < (12689 - 8376))) then
							return "Fill Ambush";
						end
					end
					if (((4105 - (12 + 5)) > (15046 - 11172)) and v75.Mutilate:IsCastable() and v82) then
						if (((9242 - 4910) == (9208 - 4876)) and v19(v75.Mutilate)) then
							return "Fill Mutilate";
						end
					end
					break;
				end
				if (((9916 - 5917) >= (589 + 2311)) and (v209 == (1975 - (1656 + 317)))) then
					if (v13:StealthUp(true, false) or (v116() > (0 + 0)) or (v115() > (0 + 0)) or ((6714 - 4189) > (20001 - 15937))) then
						v87 = v131();
						if (((4725 - (5 + 349)) == (20761 - 16390)) and v87) then
							return v87 .. " (Stealthed)";
						end
					end
					v87 = v130();
					if (v87 or ((1537 - (266 + 1005)) > (3286 + 1700))) then
						return v87;
					end
					if (((6793 - 4802) >= (1217 - 292)) and not v13:BuffUp(v75.SliceandDice)) then
						if (((2151 - (561 + 1135)) < (2674 - 621)) and ((v75.SliceandDice:IsReady() and (v13:ComboPoints() >= (6 - 4)) and v14:DebuffUp(v75.Rupture)) or (not v75.CutToTheChase:IsAvailable() and (v13:ComboPoints() >= (1070 - (507 + 559))) and (v13:BuffRemains(v75.SliceandDice) < (((2 - 1) + v13:ComboPoints()) * (3.8 - 2)))))) then
							if (v19(v75.SliceandDice) or ((1214 - (212 + 176)) == (5756 - (250 + 655)))) then
								return "Cast Slice and Dice";
							end
						end
					elseif (((498 - 315) == (319 - 136)) and v82 and v75.CutToTheChase:IsAvailable()) then
						if (((1812 - 653) <= (3744 - (1869 + 87))) and v75.Envenom:IsReady() and (v13:BuffRemains(v75.SliceandDice) < (17 - 12)) and (v13:ComboPoints() >= (1905 - (484 + 1417)))) then
							if (v19(v75.Envenom, nil, nil, not v81) or ((7516 - 4009) > (7236 - 2918))) then
								return "Cast Envenom (CttC)";
							end
						end
					elseif ((v75.PoisonedKnife:IsCastable() and v14:IsInRange(803 - (48 + 725)) and not v13:StealthUp(true, true) and (v85 == (0 - 0)) and (v13:EnergyTimeToMax() <= (v13:GCD() * (2.5 - 1)))) or ((1788 + 1287) <= (7923 - 4958))) then
						if (((383 + 982) <= (587 + 1424)) and v19(v75.PoisonedKnife)) then
							return "Cast Poisoned Knife";
						end
					end
					v209 = 856 - (152 + 701);
				end
				if ((v209 == (1314 - (430 + 881))) or ((1064 + 1712) > (4470 - (557 + 338)))) then
					v87 = v132();
					if (v87 or ((755 + 1799) == (13537 - 8733))) then
						return v87;
					end
					v87 = v133();
					if (((9024 - 6447) == (6846 - 4269)) and v87) then
						return v87;
					end
					v209 = 8 - 4;
				end
				if ((v209 == (801 - (499 + 302))) or ((872 - (39 + 827)) >= (5214 - 3325))) then
					v102 = v74.PoisonedBleeds();
					v103 = v13:EnergyRegen() + ((v102 * (13 - 7)) / ((7 - 5) * v13:SpellHaste()));
					v104 = v13:EnergyDeficit() / v103;
					v105 = v103 > (53 - 18);
					v209 = 1 + 0;
				end
				if (((1480 - 974) <= (303 + 1589)) and (v209 == (1 - 0))) then
					v100 = v118();
					v101 = v119();
					v107 = v120();
					v106 = v85 < (106 - (103 + 1));
					v209 = 556 - (475 + 79);
				end
			end
		end
	end
	local function v135()
		local v200 = 0 - 0;
		while true do
			if ((v200 == (0 - 0)) or ((260 + 1748) > (1953 + 265))) then
				v75.Deathmark:RegisterAuraTracking();
				v75.Sepsis:RegisterAuraTracking();
				v200 = 1504 - (1395 + 108);
			end
			if (((1102 - 723) <= (5351 - (7 + 1197))) and (v200 == (1 + 0))) then
				v75.Garrote:RegisterAuraTracking();
				v9.Print("Assassination Rogue by Epic. Supported by Gojira");
				break;
			end
		end
	end
	v9.SetAPL(91 + 168, v134, v135);
end;
return v0["Epix_Rogue_Assassination.lua"]();

