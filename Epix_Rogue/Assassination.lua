local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((51 + 625) >= (78 + 1564))) then
			v6 = v0[v4];
			if (((5733 - (978 + 619)) > (3751 - (243 + 1111))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (159 - (91 + 67))) or ((12899 - 8565) == (1060 + 3185))) then
			return v6(...);
		end
	end
end
v0["Epix_Rogue_Assassination.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Utils;
	local v13 = v10.Unit;
	local v14 = v13.Player;
	local v15 = v13.Target;
	local v16 = v10.Spell;
	local v17 = v10.MultiSpell;
	local v18 = v10.Cast;
	local v19 = v10.CastCycle;
	local v20 = v13.MouseOver;
	local v21 = v10.Item;
	local v22 = v10.Macro;
	local v23 = v10.Press;
	local v24 = v10.Commons.Everyone.num;
	local v25 = v10.Commons.Everyone.bool;
	local v26 = math.min;
	local v27 = math.abs;
	local v28 = math.max;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = v10.Press;
	local v33 = pairs;
	local v34 = math.floor;
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
	local v74;
	local function v75()
		v35 = EpicSettings.Settings['UseRacials'];
		v37 = EpicSettings.Settings['UseHealingPotion'];
		v38 = EpicSettings.Settings['HealingPotionName'] or (523 - (423 + 100));
		v39 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v40 = EpicSettings.Settings['UseHealthstone'];
		v41 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v42 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
		v43 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (771 - (326 + 445));
		v44 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v46 = EpicSettings.Settings['PoisonRefresh'];
		v47 = EpicSettings.Settings['PoisonRefreshCombat'];
		v48 = EpicSettings.Settings['RangedMultiDoT'];
		v49 = EpicSettings.Settings['UsePriorityRotation'];
		v53 = EpicSettings.Settings['STMfDAsDPSCD'];
		v54 = EpicSettings.Settings['KidneyShotInterrupt'];
		v55 = EpicSettings.Settings['RacialsGCD'];
		v56 = EpicSettings.Settings['RacialsOffGCD'];
		v57 = EpicSettings.Settings['VanishOffGCD'];
		v58 = EpicSettings.Settings['ShadowDanceOffGCD'];
		v59 = EpicSettings.Settings['ThistleTeaOffGCD'];
		v60 = EpicSettings.Settings['ColdBloodOffGCD'];
		v61 = EpicSettings.Settings['MarkedforDeathOffGCD'];
		v62 = EpicSettings.Settings['CrimsonVialHP'] or (2 - 1);
		v63 = EpicSettings.Settings['FeintHP'] or (2 - 1);
		v64 = EpicSettings.Settings['StealthOOC'];
		v65 = EpicSettings.Settings['EnvenomDMGOffset'] or (712 - (530 + 181));
		v66 = EpicSettings.Settings['MutilateDMGOffset'] or (882 - (614 + 267));
		v67 = EpicSettings.Settings['AlwaysSuggestGarrote'];
		v68 = EpicSettings.Settings['PotionTypeSelected'];
		v69 = EpicSettings.Settings['ExsanguinateGCD'];
		v70 = EpicSettings.Settings['KingsbaneGCD'];
		v71 = EpicSettings.Settings['ShivGCD'];
		v72 = EpicSettings.Settings['DeathmarkOffGCD'];
		v74 = EpicSettings.Settings['IndiscriminateCarnageOffGCD'];
		v73 = EpicSettings.Settings['KickOffGCD'];
	end
	local v76 = v10.Commons.Everyone;
	local v77 = v10.Commons.Rogue;
	local v78 = v16.Rogue.Assassination;
	local v79 = v22.Rogue.Assassination;
	local v80 = v21.Rogue.Assassination;
	local v81 = {v80.AlgetharPuzzleBox,v80.AshesoftheEmbersoul,v80.WitherbarksBranch};
	local v82, v83, v84, v85;
	local v86, v87, v88, v89;
	local v90;
	local v91, v92 = (5 - 3) * v14:SpellHaste(), (1 + 0) * v14:SpellHaste();
	local v93, v94;
	local v95, v96, v97, v98, v99, v100, v101;
	local v102;
	local v103, v104, v105, v106, v107, v108, v109, v110;
	local v111 = 0 - 0;
	local v112 = v14:GetEquipment();
	local v113 = (v112[26 - 13] and v21(v112[1825 - (1293 + 519)])) or v21(0 - 0);
	local v114 = (v112[36 - 22] and v21(v112[26 - 12])) or v21(0 - 0);
	local function v115()
		if ((v113:HasStatAnyDps() and (not v114:HasStatAnyDps() or (v113:Cooldown() >= v114:Cooldown()))) or ((10072 - 5796) <= (1606 + 1425))) then
			v111 = 1 + 0;
		elseif ((v114:HasStatAnyDps() and (not v113:HasStatAnyDps() or (v114:Cooldown() > v113:Cooldown()))) or ((11110 - 6328) <= (278 + 921))) then
			v111 = 1 + 1;
		else
			v111 = 0 + 0;
		end
	end
	v115();
	v10:RegisterForEvent(function()
		local v164 = 1096 - (709 + 387);
		while true do
			if (((1859 - (673 + 1185)) == v164) or ((14106 - 9242) < (6107 - 4205))) then
				v114 = (v112[22 - 8] and v21(v112[11 + 3])) or v21(0 + 0);
				v115();
				break;
			end
			if (((6532 - 1693) >= (909 + 2791)) and (v164 == (0 - 0))) then
				v112 = v14:GetEquipment();
				v113 = (v112[24 - 11] and v21(v112[1893 - (446 + 1434)])) or v21(1283 - (1040 + 243));
				v164 = 2 - 1;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v116 = {{v78.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v78.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v93 > (0 + 0);
	end}};
	v78.Envenom:RegisterDamageFormula(function()
		return v14:AttackPowerDamageMod() * v93 * (0.22 + 0) * (2 - 1) * ((v15:DebuffUp(v78.ShivDebuff) and (1.3 + 0)) or (1 - 0)) * ((v78.DeeperStratagem:IsAvailable() and (1.05 + 0)) or (1 + 0)) * (1 + 0 + (v14:MasteryPct() / (84 + 16))) * (1 + 0 + (v14:VersatilityDmgPct() / (533 - (153 + 280))));
	end);
	v78.Mutilate:RegisterDamageFormula(function()
		return (v14:AttackPowerDamageMod() + v14:AttackPowerDamageMod(true)) * (0.485 - 0) * (1 + 0) * (1 + 0 + (v14:VersatilityDmgPct() / (53 + 47)));
	end);
	local function v117()
		return v14:BuffRemains(v78.MasterAssassinBuff) == (9074 + 925);
	end
	local function v118()
		if (v117() or ((779 + 296) > (2920 - 1002))) then
			return v14:GCDRemains() + 2 + 1;
		end
		return v14:BuffRemains(v78.MasterAssassinBuff);
	end
	local function v119()
		if (((1063 - (89 + 578)) <= (2718 + 1086)) and v14:BuffUp(v78.ImprovedGarroteAura)) then
			return v14:GCDRemains() + (5 - 2);
		end
		return v14:BuffRemains(v78.ImprovedGarroteBuff);
	end
	local function v120()
		if (v14:BuffUp(v78.IndiscriminateCarnageAura) or ((5218 - (572 + 477)) == (295 + 1892))) then
			return v14:GCDRemains() + 7 + 3;
		end
		return v14:BuffRemains(v78.IndiscriminateCarnageBuff);
	end
	local function v49()
		local v165 = 0 + 0;
		while true do
			if (((1492 - (84 + 2)) == (2316 - 910)) and (v165 == (0 + 0))) then
				if (((2373 - (497 + 345)) < (110 + 4161)) and (v88 < (1 + 1))) then
					return false;
				elseif (((1968 - (605 + 728)) == (454 + 181)) and (v49 == "Always")) then
					return true;
				elseif (((7498 - 4125) <= (163 + 3393)) and (v49 == "On Bosses") and v15:IsInBossList()) then
					return true;
				elseif ((v49 == "Auto") or ((12167 - 8876) < (2957 + 323))) then
					if (((12151 - 7765) >= (660 + 213)) and (v14:InstanceDifficulty() == (505 - (457 + 32))) and (v15:NPCID() == (58961 + 80006))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v121()
		if (((2323 - (832 + 570)) <= (1039 + 63)) and (v15:DebuffUp(v78.Deathmark) or v15:DebuffUp(v78.Kingsbane) or v14:BuffUp(v78.ShadowDanceBuff) or v15:DebuffUp(v78.ShivDebuff) or (v78.ThistleTea:FullRechargeTime() < (6 + 14)) or (v14:EnergyPercentage() >= (283 - 203)) or (v14:HasTier(15 + 16, 800 - (588 + 208)) and ((v14:BuffUp(v78.Envenom) and (v14:BuffRemains(v78.Envenom) <= (5 - 3))) or v10.BossFilteredFightRemains("<=", 1890 - (884 + 916)))))) then
			return true;
		end
		return false;
	end
	local function v122()
		if (((9852 - 5146) >= (559 + 404)) and (v78.Deathmark:CooldownRemains() > v78.Sepsis:CooldownRemains()) and (v10.BossFightRemainsIsNotValid() or v10.BossFilteredFightRemains(">", v78.Deathmark:CooldownRemains()))) then
			return v78.Deathmark:CooldownRemains();
		end
		return v78.Sepsis:CooldownRemains();
	end
	local function v123()
		local v166 = 653 - (232 + 421);
		while true do
			if ((v166 == (1889 - (1569 + 320))) or ((236 + 724) <= (167 + 709))) then
				if (not v78.ScentOfBlood:IsAvailable() or ((6961 - 4895) == (1537 - (316 + 289)))) then
					return true;
				end
				return v14:BuffStack(v78.ScentOfBloodBuff) >= v26(52 - 32, v78.ScentOfBlood:TalentRank() * (1 + 1) * v88);
			end
		end
	end
	local function v124(v167, v168, v169)
		local v169 = v169 or v168:PandemicThreshold();
		return v167:DebuffRefreshable(v168, v169);
	end
	local function v125(v170, v171, v172, v173)
		local v174 = 1453 - (666 + 787);
		local v175;
		local v176;
		local v177;
		while true do
			if (((5250 - (360 + 65)) < (4527 + 316)) and (v174 == (255 - (79 + 175)))) then
				for v217, v218 in v33(v173) do
					if (((v218:GUID() ~= v177) and v76.UnitIsCycleValid(v218, v176, -v218:DebuffRemains(v170)) and v171(v218)) or ((6113 - 2236) >= (3541 + 996))) then
						v175, v176 = v218, v218:TimeToDie();
					end
				end
				if (v175 or ((13226 - 8911) < (3323 - 1597))) then
					CastLeftNameplate(v175, v170);
				elseif (v48 or ((4578 - (503 + 396)) < (806 - (92 + 89)))) then
					v175, v176 = nil, v172;
					for v244, v245 in v33(v87) do
						if (((v245:GUID() ~= v177) and v76.UnitIsCycleValid(v245, v176, -v245:DebuffRemains(v170)) and v171(v245)) or ((8971 - 4346) < (325 + 307))) then
							v175, v176 = v245, v245:TimeToDie();
						end
					end
					if (v175 or ((50 + 33) > (6970 - 5190))) then
						CastLeftNameplate(v175, v170);
					end
				end
				break;
			end
			if (((75 + 471) <= (2455 - 1378)) and ((0 + 0) == v174)) then
				v175, v176 = nil, v172;
				v177 = v15:GUID();
				v174 = 1 + 0;
			end
		end
	end
	local function v126(v178, v179, v180)
		local v181 = v179(v15);
		if (((v178 == "first") and (v181 ~= (0 - 0))) or ((125 + 871) > (6558 - 2257))) then
			return v15;
		end
		local v182, v183 = nil, 1244 - (485 + 759);
		local function v184(v200)
			for v202, v203 in v33(v200) do
				local v204 = v179(v203);
				if (((9417 - 5347) > (1876 - (442 + 747))) and not v182 and (v178 == "first")) then
					if ((v204 ~= (1135 - (832 + 303))) or ((1602 - (88 + 858)) >= (1015 + 2315))) then
						v182, v183 = v203, v204;
					end
				elseif ((v178 == "min") or ((2063 + 429) <= (14 + 321))) then
					if (((5111 - (766 + 23)) >= (12647 - 10085)) and (not v182 or (v204 < v183))) then
						v182, v183 = v203, v204;
					end
				elseif ((v178 == "max") or ((4974 - 1337) >= (9932 - 6162))) then
					if (not v182 or (v204 > v183) or ((8074 - 5695) > (5651 - (1036 + 37)))) then
						v182, v183 = v203, v204;
					end
				end
				if ((v182 and (v204 == v183) and (v203:TimeToDie() > v182:TimeToDie())) or ((343 + 140) > (1446 - 703))) then
					v182, v183 = v203, v204;
				end
			end
		end
		v184(v89);
		if (((1931 + 523) > (2058 - (641 + 839))) and v48) then
			v184(v87);
		end
		if (((1843 - (910 + 3)) < (11364 - 6906)) and v182 and (v183 == v181) and v180(v15)) then
			return v15;
		end
		if (((2346 - (1466 + 218)) <= (447 + 525)) and v182 and v180(v182)) then
			return v182;
		end
		return nil;
	end
	local function v127(v185, v186, v187)
		local v188 = v15:TimeToDie();
		if (((5518 - (556 + 592)) == (1554 + 2816)) and not v10.BossFightRemainsIsNotValid()) then
			v188 = v10.BossFightRemains();
		elseif ((v188 < v187) or ((5570 - (329 + 479)) <= (1715 - (174 + 680)))) then
			return false;
		end
		if ((v34((v188 - v187) / v185) > v34(((v188 - v187) - v186) / v185)) or ((4851 - 3439) == (8838 - 4574))) then
			return true;
		end
		return false;
	end
	local function v128(v189)
		local v190 = 0 + 0;
		while true do
			if ((v190 == (739 - (396 + 343))) or ((281 + 2887) < (3630 - (29 + 1448)))) then
				if (v189:DebuffUp(v78.SerratedBoneSpikeDebuff) or ((6365 - (135 + 1254)) < (5017 - 3685))) then
					return 4669124 - 3669124;
				end
				return v189:TimeToDie();
			end
		end
	end
	local function v129(v191)
		return not v191:DebuffUp(v78.SerratedBoneSpikeDebuff);
	end
	local function v130()
		local v192 = 0 + 0;
		while true do
			if (((6155 - (389 + 1138)) == (5202 - (102 + 472))) and ((1 + 0) == v192)) then
				if (v78.Fireblood:IsCastable() or ((30 + 24) == (369 + 26))) then
					if (((1627 - (320 + 1225)) == (145 - 63)) and v10.Cast(v78.Fireblood, v35)) then
						return "Cast Fireblood";
					end
				end
				if (v78.AncestralCall:IsCastable() or ((356 + 225) < (1746 - (157 + 1307)))) then
					if ((not v78.Kingsbane:IsAvailable() and v15:DebuffUp(v78.ShivDebuff)) or (v15:DebuffUp(v78.Kingsbane) and (v15:DebuffRemains(v78.Kingsbane) < (1867 - (821 + 1038)))) or ((11499 - 6890) < (273 + 2222))) then
						if (((2045 - 893) == (429 + 723)) and v10.Cast(v78.AncestralCall, v35)) then
							return "Cast Ancestral Call";
						end
					end
				end
				v192 = 4 - 2;
			end
			if (((2922 - (834 + 192)) <= (218 + 3204)) and (v192 == (1 + 2))) then
				if (v78.LightsJudgment:IsCastable() or ((22 + 968) > (2509 - 889))) then
					if (v10.Cast(v78.LightsJudgment, v35) or ((1181 - (300 + 4)) > (1254 + 3441))) then
						return "Cast Lights Judgment";
					end
				end
				if (((7044 - 4353) >= (2213 - (112 + 250))) and v78.BagofTricks:IsCastable()) then
					if (v10.Cast(v78.BagofTricks, v35) or ((1190 + 1795) >= (12165 - 7309))) then
						return "Cast Bag of Tricks";
					end
				end
				v192 = 3 + 1;
			end
			if (((2212 + 2064) >= (894 + 301)) and ((1 + 1) == v192)) then
				if (((2401 + 831) <= (6104 - (1001 + 413))) and v78.ArcaneTorrent:IsCastable() and (v14:EnergyDeficit() > (33 - 18))) then
					if (v10.Cast(v78.ArcaneTorrent, v35) or ((1778 - (244 + 638)) >= (3839 - (627 + 66)))) then
						return "Cast Arcane Torrent";
					end
				end
				if (((9120 - 6059) >= (3560 - (512 + 90))) and v78.ArcanePulse:IsCastable()) then
					if (((5093 - (1665 + 241)) >= (1361 - (373 + 344))) and v10.Cast(v78.ArcanePulse, v35)) then
						return "Cast Arcane Pulse";
					end
				end
				v192 = 2 + 1;
			end
			if (((171 + 473) <= (1856 - 1152)) and (v192 == (0 - 0))) then
				if (((2057 - (35 + 1064)) > (690 + 257)) and v78.BloodFury:IsCastable()) then
					if (((9610 - 5118) >= (11 + 2643)) and v10.Cast(v78.BloodFury, v35)) then
						return "Cast Blood Fury";
					end
				end
				if (((4678 - (298 + 938)) >= (2762 - (233 + 1026))) and v78.Berserking:IsCastable()) then
					if (v10.Cast(v78.Berserking, v35) or ((4836 - (636 + 1030)) <= (749 + 715))) then
						return "Cast Berserking";
					end
				end
				v192 = 1 + 0;
			end
			if ((v192 == (2 + 2)) or ((325 + 4472) == (4609 - (55 + 166)))) then
				return false;
			end
		end
	end
	local function v131()
		if (((107 + 444) <= (69 + 612)) and v78.ShadowDance:IsCastable() and not v78.Kingsbane:IsAvailable()) then
			local v205 = 0 - 0;
			while true do
				if (((3574 - (36 + 261)) > (711 - 304)) and ((1368 - (34 + 1334)) == v205)) then
					if (((1805 + 2890) >= (1100 + 315)) and v78.ImprovedGarrote:IsAvailable() and v78.Garrote:CooldownUp() and ((v15:PMultiplier(v78.Garrote) <= (1284 - (1035 + 248))) or v124(v15, v78.Garrote)) and (v78.Deathmark:AnyDebuffUp() or (v78.Deathmark:CooldownRemains() < (33 - (20 + 1))) or (v78.Deathmark:CooldownRemains() > (32 + 28))) and (v94 >= math.min(v88, 323 - (134 + 185)))) then
						if ((v14:EnergyPredicted() < (1178 - (549 + 584))) or ((3897 - (314 + 371)) <= (3240 - 2296))) then
							if (v23(v78.PoolEnergy) or ((4064 - (478 + 490)) <= (953 + 845))) then
								return "Pool for Shadow Dance (Garrote)";
							end
						end
						if (((4709 - (786 + 386)) == (11456 - 7919)) and v23(v78.ShadowDance, v58)) then
							return "Cast Shadow Dance (Garrote)";
						end
					end
					if (((5216 - (1055 + 324)) >= (2910 - (1093 + 247))) and not v78.ImprovedGarrote:IsAvailable() and v78.MasterAssassin:IsAvailable() and not v124(v15, v78.Rupture) and (v15:DebuffRemains(v78.Garrote) > (3 + 0)) and (v15:DebuffUp(v78.Deathmark) or (v78.Deathmark:CooldownRemains() > (7 + 53))) and (v15:DebuffUp(v78.ShivDebuff) or (v15:DebuffRemains(v78.Deathmark) < (15 - 11)) or v15:DebuffUp(v78.Sepsis)) and (v15:DebuffRemains(v78.Sepsis) < (9 - 6))) then
						if (v23(v78.ShadowDance, v58) or ((8394 - 5444) == (9579 - 5767))) then
							return "Cast Shadow Dance (Master Assassin)";
						end
					end
					break;
				end
			end
		end
		if (((1681 + 3042) >= (8929 - 6611)) and v78.Vanish:IsCastable() and not v14:IsTanking(v15)) then
			if ((v78.ImprovedGarrote:IsAvailable() and not v78.MasterAssassin:IsAvailable() and v78.Garrote:CooldownUp() and ((v15:PMultiplier(v78.Garrote) <= (3 - 2)) or v124(v15, v78.Garrote))) or ((1529 + 498) > (7293 - 4441))) then
				local v219 = 688 - (364 + 324);
				while true do
					if ((v219 == (0 - 0)) or ((2725 - 1589) > (1431 + 2886))) then
						if (((19867 - 15119) == (7603 - 2855)) and not v78.IndiscriminateCarnage:IsAvailable() and (v78.Deathmark:AnyDebuffUp() or (v78.Deathmark:CooldownRemains() < (11 - 7))) and (v94 >= v26(v88, 1272 - (1249 + 19)))) then
							local v246 = 0 + 0;
							while true do
								if (((14542 - 10806) <= (5826 - (686 + 400))) and (v246 == (0 + 0))) then
									if ((v14:EnergyPredicted() < (274 - (73 + 156))) or ((17 + 3373) <= (3871 - (721 + 90)))) then
										if (v23(v78.PoolEnergy) or ((12 + 987) > (8743 - 6050))) then
											return "Pool for Vanish (Garrote Deathmark)";
										end
									end
									if (((933 - (224 + 246)) < (973 - 372)) and v23(v78.Vanish, v57)) then
										return "Cast Vanish (Garrote Deathmark)";
									end
									break;
								end
							end
						end
						if ((v78.IndiscriminateCarnage:IsAvailable() and (v88 > (3 - 1))) or ((396 + 1787) < (17 + 670))) then
							if (((3342 + 1207) == (9043 - 4494)) and (v14:EnergyPredicted() < (149 - 104))) then
								if (((5185 - (203 + 310)) == (6665 - (1238 + 755))) and v23(v78.PoolEnergy)) then
									return "Pool for Vanish (Garrote Deathmark)";
								end
							end
							if (v23(v78.Vanish, v57) or ((257 + 3411) < (1929 - (709 + 825)))) then
								return "Cast Vanish (Garrote Cleave)";
							end
						end
						break;
					end
				end
			end
			if ((v78.MasterAssassin:IsAvailable() and v78.Kingsbane:IsAvailable() and v15:DebuffUp(v78.Kingsbane) and (v15:DebuffRemains(v78.Kingsbane) <= (4 - 1)) and v15:DebuffUp(v78.Deathmark) and (v15:DebuffRemains(v78.Deathmark) <= (3 - 0))) or ((5030 - (196 + 668)) == (1796 - 1341))) then
				if (v23(v78.Vanish, v57) or ((9215 - 4766) == (3496 - (171 + 662)))) then
					return "Cast Vanish (Kingsbane)";
				end
			end
			if ((not v78.ImprovedGarrote:IsAvailable() and v78.MasterAssassin:IsAvailable() and not v124(v15, v78.Rupture) and (v15:DebuffRemains(v78.Garrote) > (96 - (4 + 89))) and v15:DebuffUp(v78.Deathmark) and (v15:DebuffUp(v78.ShivDebuff) or (v15:DebuffRemains(v78.Deathmark) < (13 - 9)) or v15:DebuffUp(v78.Sepsis)) and (v15:DebuffRemains(v78.Sepsis) < (2 + 1))) or ((18785 - 14508) < (1173 + 1816))) then
				if (v23(v78.Vanish, v57) or ((2356 - (35 + 1451)) >= (5602 - (28 + 1425)))) then
					return "Cast Vanish (Master Assassin)";
				end
			end
		end
	end
	local function v132()
		local v193 = 1993 - (941 + 1052);
		while true do
			if (((2121 + 91) < (4697 - (822 + 692))) and (v193 == (0 - 0))) then
				if (((2189 + 2457) > (3289 - (45 + 252))) and v113:IsReady()) then
					local v221 = 0 + 0;
					local v222;
					while true do
						if (((494 + 940) < (7559 - 4453)) and (v221 == (433 - (114 + 319)))) then
							v222 = v76.HandleTopTrinket(v81, v31, 11 - 3, nil);
							if (((1006 - 220) < (1928 + 1095)) and v222) then
								return v222;
							end
							break;
						end
					end
				end
				if (v114:IsReady() or ((3637 - 1195) < (154 - 80))) then
					local v223 = v76.HandleBottomTrinket(v81, v31, 1971 - (556 + 1407), nil);
					if (((5741 - (741 + 465)) == (5000 - (170 + 295))) and v223) then
						return v223;
					end
				end
				break;
			end
		end
	end
	local function v133()
		if ((v78.Sepsis:IsReady() and (v15:DebuffRemains(v78.Rupture) > (11 + 9)) and ((not v78.ImprovedGarrote:IsAvailable() and v15:DebuffUp(v78.Garrote)) or (v78.ImprovedGarrote:IsAvailable() and v78.Garrote:CooldownUp() and (v15:PMultiplier(v78.Garrote) <= (1 + 0)))) and (v15:FilteredTimeToDie(">", 24 - 14) or v10.BossFilteredFightRemains("<=", 9 + 1))) or ((1930 + 1079) <= (1192 + 913))) then
			if (((3060 - (957 + 273)) < (982 + 2687)) and v23(v78.Sepsis, nil, true)) then
				return "Cast Sepsis";
			end
		end
		local v194 = v76.HandleDPSPotion();
		if (v194 or ((573 + 857) >= (13763 - 10151))) then
			return v194;
		end
		local v195 = not v14:StealthUp(true, false) and v15:DebuffUp(v78.Rupture) and v14:BuffUp(v78.Envenom) and not v78.Deathmark:AnyDebuffUp() and (not v78.MasterAssassin:IsAvailable() or v15:DebuffUp(v78.Garrote)) and (not v78.Kingsbane:IsAvailable() or (v78.Kingsbane:CooldownRemains() <= (5 - 3)));
		if (((8195 - 5512) >= (12181 - 9721)) and v78.Deathmark:IsCastable() and (v195 or v10.BossFilteredFightRemains("<=", 1800 - (389 + 1391)))) then
			if (v23(v78.Deathmark) or ((1132 + 672) >= (341 + 2934))) then
				return "Cast Deathmark";
			end
		end
		if ((v78.Shiv:IsReady() and not v15:DebuffUp(v78.ShivDebuff) and v15:DebuffUp(v78.Garrote) and v15:DebuffUp(v78.Rupture)) or ((3225 - 1808) > (4580 - (783 + 168)))) then
			local v206 = 0 - 0;
			while true do
				if (((4717 + 78) > (713 - (309 + 2))) and (v206 == (2 - 1))) then
					if (((6025 - (1090 + 122)) > (1156 + 2409)) and v78.ArterialPrecision:IsAvailable() and v78.Deathmark:AnyDebuffUp()) then
						if (((13138 - 9226) == (2678 + 1234)) and v23(v78.Shi)) then
							return "Cast Shiv (Arterial Precision)";
						end
					end
					if (((3939 - (628 + 490)) <= (866 + 3958)) and not v78.Kingsbane:IsAvailable() and not v78.ArterialPrecision:IsAvailable()) then
						if (((4303 - 2565) <= (10031 - 7836)) and v78.Sepsis:IsAvailable()) then
							if (((815 - (431 + 343)) <= (6095 - 3077)) and (((v78.Shiv:ChargesFractional() > ((0.9 - 0) + v24(v78.LightweightShiv:IsAvailable()))) and (v104 > (4 + 1))) or v15:DebuffUp(v78.Sepsis) or v15:DebuffUp(v78.Deathmark))) then
								if (((275 + 1870) <= (5799 - (556 + 1139))) and v23(v78.Shiv)) then
									return "Cast Shiv (Sepsis)";
								end
							end
						elseif (((2704 - (6 + 9)) < (888 + 3957)) and (not v78.CrimsonTempest:IsAvailable() or v109 or v15:DebuffUp(v78.CrimsonTempest))) then
							if (v23(v78.Shiv) or ((1190 + 1132) > (2791 - (28 + 141)))) then
								return "Cast Shiv";
							end
						end
					end
					break;
				end
				if ((v206 == (0 + 0)) or ((5595 - 1061) == (1475 + 607))) then
					if (v10.BossFilteredFightRemains("<=", v78.Shiv:Charges() * (1325 - (486 + 831))) or ((4088 - 2517) > (6572 - 4705))) then
						if (v23(v78.Shiv) or ((502 + 2152) >= (9473 - 6477))) then
							return "Cast Shiv (End of Fight)";
						end
					end
					if (((5241 - (668 + 595)) > (1894 + 210)) and v78.Kingsbane:IsAvailable() and v14:BuffUp(v78.Envenom)) then
						local v239 = 0 + 0;
						while true do
							if (((8167 - 5172) > (1831 - (23 + 267))) and (v239 == (1944 - (1129 + 815)))) then
								if (((3636 - (371 + 16)) > (2703 - (1326 + 424))) and not v78.LightweightShiv:IsAvailable() and ((v15:DebuffUp(v78.Kingsbane) and (v15:DebuffRemains(v78.Kingsbane) < (14 - 6))) or (v78.Kingsbane:CooldownRemains() >= (87 - 63))) and (not v78.CrimsonTempest:IsAvailable() or v109 or v15:DebuffUp(v78.CrimsonTempest))) then
									if (v23(v78.Shiv) or ((3391 - (88 + 30)) > (5344 - (720 + 51)))) then
										return "Cast Shiv (Kingsbane)";
									end
								end
								if ((v78.LightweightShiv:IsAvailable() and (v15:DebuffUp(v78.Kingsbane) or (v78.Kingsbane:CooldownRemains() <= (2 - 1)))) or ((4927 - (421 + 1355)) < (2117 - 833))) then
									if (v23(v78.Shiv) or ((909 + 941) == (2612 - (286 + 797)))) then
										return "Cast Shiv (Kingsbane Lightweight)";
									end
								end
								break;
							end
						end
					end
					v206 = 3 - 2;
				end
			end
		end
		if (((1359 - 538) < (2562 - (397 + 42))) and v78.ShadowDance:IsCastable() and v78.Kingsbane:IsAvailable() and v14:BuffUp(v78.Envenom) and ((v78.Deathmark:CooldownRemains() >= (16 + 34)) or v195)) then
			if (((1702 - (24 + 776)) < (3581 - 1256)) and v23(v78.ShadowDance)) then
				return "Cast Shadow Dance (Kingsbane Sync)";
			end
		end
		if (((1643 - (222 + 563)) <= (6525 - 3563)) and v78.Kingsbane:IsReady() and (v15:DebuffUp(v78.ShivDebuff) or (v78.Shiv:CooldownRemains() < (5 + 1))) and v14:BuffUp(v78.Envenom) and ((v78.Deathmark:CooldownRemains() >= (240 - (23 + 167))) or v15:DebuffUp(v78.Deathmark))) then
			if (v23(v78.Kingsbane) or ((5744 - (690 + 1108)) < (465 + 823))) then
				return "Cast Kingsbane";
			end
		end
		if ((v78.ThistleTea:IsCastable() and not v14:BuffUp(v78.ThistleTea) and (((v14:EnergyDeficit() >= (83 + 17 + v106)) and (not v78.Kingsbane:IsAvailable() or (v78.ThistleTea:Charges() >= (850 - (40 + 808))))) or (v15:DebuffUp(v78.Kingsbane) and (v15:DebuffRemains(v78.Kingsbane) < (1 + 5))) or (not v78.Kingsbane:IsAvailable() and v78.Deathmark:AnyDebuffUp()) or v10.BossFilteredFightRemains("<", v78.ThistleTea:Charges() * (22 - 16)))) or ((3099 + 143) == (300 + 267))) then
			if (v10.Cast(v78.ThistleTea) or ((465 + 382) >= (1834 - (47 + 524)))) then
				return "Cast Thistle Tea";
			end
		end
		if ((not v14:StealthUp(true, true) and (v119() <= (0 + 0)) and (v118() <= (0 - 0))) or ((3368 - 1115) == (4221 - 2370))) then
			local v207 = 1726 - (1165 + 561);
			local v208;
			while true do
				if ((v207 == (0 + 0)) or ((6463 - 4376) > (906 + 1466))) then
					v208 = v131();
					if (v208 or ((4924 - (341 + 138)) < (1121 + 3028))) then
						return v208;
					end
					break;
				end
			end
		end
		if ((v78.ColdBlood:IsReady() and v14:DebuffDown(v78.ColdBlood) and (v93 >= (7 - 3))) or ((2144 - (89 + 237)) == (273 - 188))) then
			if (((1326 - 696) < (3008 - (581 + 300))) and v10.Press(v78.ColdBlood)) then
				return "Cast Cold Blood";
			end
		end
		return false;
	end
	local function v134()
		local v196 = 1220 - (855 + 365);
		while true do
			if ((v196 == (4 - 2)) or ((633 + 1305) == (3749 - (1030 + 205)))) then
				if (((3995 + 260) >= (52 + 3)) and (v93 >= (290 - (156 + 130))) and (v15:PMultiplier(v78.Rupture) <= (2 - 1)) and (v14:BuffUp(v78.ShadowDanceBuff) or v15:DebuffUp(v78.Deathmark))) then
					if (((5054 - 2055) > (2367 - 1211)) and v18(v78.Rupture)) then
						return "Cast Rupture (Nightstalker)";
					end
				end
				break;
			end
			if (((620 + 1730) > (674 + 481)) and (v196 == (69 - (10 + 59)))) then
				if (((1140 + 2889) <= (23899 - 19046)) and v78.Kingsbane:IsAvailable() and v14:BuffUp(v78.Envenom)) then
					local v224 = 1163 - (671 + 492);
					while true do
						if ((v224 == (0 + 0)) or ((1731 - (369 + 846)) > (910 + 2524))) then
							if (((3453 + 593) >= (4978 - (1036 + 909))) and v78.Shiv:IsReady() and (v15:DebuffUp(v78.Kingsbane) or v78.Kingsbane:CooldownUp()) and v15:DebuffDown(v78.ShivDebuff)) then
								if (v23(v78.Shiv) or ((2162 + 557) <= (2428 - 981))) then
									return "Cast Shiv (Stealth Kingsbane)";
								end
							end
							if ((v78.Kingsbane:IsReady() and (v14:BuffRemains(v78.ShadowDanceBuff) >= (205 - (11 + 192)))) or ((2090 + 2044) < (4101 - (135 + 40)))) then
								if (v23(v78.Kingsbane, v70) or ((397 - 233) >= (1679 + 1106))) then
									return "Cast Kingsbane (Dance)";
								end
							end
							break;
						end
					end
				end
				if ((v93 >= (8 - 4)) or ((787 - 262) == (2285 - (50 + 126)))) then
					local v225 = 0 - 0;
					while true do
						if (((8 + 25) == (1446 - (1233 + 180))) and (v225 == (969 - (522 + 447)))) then
							if (((4475 - (107 + 1314)) <= (1864 + 2151)) and v15:DebuffUp(v78.Kingsbane) and (v14:BuffRemains(v78.Envenom) <= (5 - 3))) then
								if (((795 + 1076) < (6715 - 3333)) and v23(v78.Envenom)) then
									return "Cast Envenom (Stealth Kingsbane)";
								end
							end
							if (((5115 - 3822) <= (4076 - (716 + 1194))) and v109 and v117() and v14:BuffDown(v78.ShadowDanceBuff)) then
								if (v23(v78.Envenom) or ((45 + 2534) < (14 + 109))) then
									return "Cast Envenom (Master Assassin)";
								end
							end
							break;
						end
					end
				end
				v196 = 504 - (74 + 429);
			end
			if ((v196 == (1 - 0)) or ((420 + 426) >= (5420 - 3052))) then
				if ((v30 and v78.CrimsonTempest:IsReady() and v78.Nightstalker:IsAvailable() and (v88 >= (3 + 0)) and (v93 >= (12 - 8)) and not v78.Deathmark:IsReady()) or ((9919 - 5907) <= (3791 - (279 + 154)))) then
					if (((2272 - (454 + 324)) <= (2365 + 640)) and v23(v78.CrimsonTempest)) then
						return "Cast Crimson Tempest (Stealth)";
					end
				end
				if ((v78.Garrote:IsCastable() and (v119() > (17 - (12 + 5)))) or ((1678 + 1433) == (5437 - 3303))) then
					local function v226(v236)
						return v236:DebuffRemains(v78.Garrote);
					end
					local function v227(v237)
						return ((v237:PMultiplier(v78.Garrote) <= (1 + 0)) or (v237:DebuffRemains(v78.Garrote) < ((1105 - (277 + 816)) / v77.ExsanguinatedRate(v237, v78.Garrote))) or ((v120() > (0 - 0)) and (v78.Garrote:AuraActiveCount() < v88))) and not v109 and (v237:FilteredTimeToDie(">", 1185 - (1058 + 125), -v237:DebuffRemains(v78.Garrote)) or v237:TimeToDieIsNotValid()) and v77.CanDoTUnit(v237, v98);
					end
					if (((442 + 1913) == (3330 - (815 + 160))) and v30) then
						local v240 = v126("min", v226, v227);
						if ((v240 and (v240:GUID() == v20:GUID())) or ((2522 - 1934) <= (1025 - 593))) then
							v23(v79.GarroteMouseOver);
						end
					end
					if (((1145 + 3652) >= (11385 - 7490)) and v227(v15)) then
						if (((5475 - (41 + 1857)) == (5470 - (1222 + 671))) and v18(v78.Garrote)) then
							return "Cast Garrote (Improved Garrote)";
						end
					end
					if (((9805 - 6011) > (5307 - 1614)) and (v94 >= ((1183 - (229 + 953)) + ((1776 - (1111 + 663)) * v24(v78.ShroudedSuffocation:IsAvailable()))))) then
						if ((v14:BuffDown(v78.ShadowDanceBuff) and ((v15:PMultiplier(v78.Garrote) <= (1580 - (874 + 705))) or (v15:DebuffUp(v78.Deathmark) and (v118() < (1 + 2))))) or ((870 + 405) == (8522 - 4422))) then
							if (v18(v78.Garrote) or ((45 + 1546) >= (4259 - (642 + 37)))) then
								return "Cast Garrote (Improved Garrote Low CP)";
							end
						end
						if (((225 + 758) <= (290 + 1518)) and ((v15:PMultiplier(v78.Garrote) <= (2 - 1)) or (v15:DebuffRemains(v78.Garrote) < (466 - (233 + 221))))) then
							if (v18(v78.Garrote) or ((4971 - 2821) <= (1054 + 143))) then
								return "Cast Garrote (Improved Garrote Low CP 2)";
							end
						end
					end
				end
				v196 = 1543 - (718 + 823);
			end
		end
	end
	local function v135()
		local v197 = 0 + 0;
		while true do
			if (((4574 - (266 + 539)) >= (3320 - 2147)) and ((1226 - (636 + 589)) == v197)) then
				if (((3525 - 2040) == (3062 - 1577)) and v78.Rupture:IsReady() and (v93 >= (4 + 0))) then
					v99 = 2 + 2 + (v24(v78.DashingScoundrel:IsAvailable()) * (1020 - (657 + 358))) + (v24(v78.Doomblade:IsAvailable()) * (13 - 8)) + (v24(v108) * (13 - 7));
					local function v228(v238)
						return v124(v238, v78.Rupture, v95) and (v238:PMultiplier(v78.Rupture) <= (1188 - (1151 + 36))) and (v238:FilteredTimeToDie(">", v99, -v238:DebuffRemains(v78.Rupture)) or v238:TimeToDieIsNotValid());
					end
					if ((v228(v15) and v77.CanDoTUnit(v15, v97)) or ((3202 + 113) <= (732 + 2050))) then
						if (v23(v78.Rupture) or ((2616 - 1740) >= (4796 - (1552 + 280)))) then
							return "Cast Rupture";
						end
					end
				end
				if ((v78.Garrote:IsCastable() and (v94 >= (835 - (64 + 770))) and (v118() <= (0 + 0)) and ((v15:PMultiplier(v78.Garrote) <= (2 - 1)) or ((v15:DebuffRemains(v78.Garrote) < v91) and (v88 >= (1 + 2)))) and (v15:DebuffRemains(v78.Garrote) < (v91 * (1245 - (157 + 1086)))) and (v88 >= (5 - 2)) and (v15:FilteredTimeToDie(">", 17 - 13, -v15:DebuffRemains(v78.Garrote)) or v15:TimeToDieIsNotValid())) or ((3423 - 1191) > (3408 - 911))) then
					if (v23(v78.Garrote) or ((2929 - (599 + 220)) <= (660 - 328))) then
						return "Garrote (Fallback)";
					end
				end
				v197 = 1933 - (1813 + 118);
			end
			if (((2695 + 991) > (4389 - (841 + 376))) and ((0 - 0) == v197)) then
				if ((v30 and v78.CrimsonTempest:IsReady() and (v88 >= (1 + 1)) and (v93 >= (10 - 6)) and (v106 > (884 - (464 + 395))) and not v78.Deathmark:IsReady()) or ((11481 - 7007) < (394 + 426))) then
					if (((5116 - (467 + 370)) >= (5955 - 3073)) and v23(v78.CrimsonTempest)) then
						return "Cast Crimson Tempest (AoE High Energy)";
					end
				end
				if ((v78.Garrote:IsCastable() and (v94 >= (1 + 0))) or ((6955 - 4926) >= (550 + 2971))) then
					local v229 = 0 - 0;
					local v230;
					while true do
						if ((v229 == (520 - (150 + 370))) or ((3319 - (74 + 1208)) >= (11417 - 6775))) then
							v230 = nil;
							function v230(v247)
								return v124(v247, v78.Garrote) and (v247:PMultiplier(v78.Garrote) <= (4 - 3));
							end
							v229 = 1 + 0;
						end
						if (((2110 - (14 + 376)) < (7731 - 3273)) and (v229 == (1 + 0))) then
							if ((v230(v15) and v77.CanDoTUnit(v15, v98) and (v15:FilteredTimeToDie(">", 11 + 1, -v15:DebuffRemains(v78.Garrote)) or v15:TimeToDieIsNotValid())) or ((416 + 20) > (8851 - 5830))) then
								if (((537 + 176) <= (925 - (23 + 55))) and v32(v78.Garrote)) then
									return "Pool for Garrote (ST)";
								end
							end
							break;
						end
					end
				end
				v197 = 2 - 1;
			end
			if (((1438 + 716) <= (3620 + 411)) and (v197 == (2 - 0))) then
				return false;
			end
		end
	end
	local function v136()
		if (((1452 + 3163) == (5516 - (652 + 249))) and v78.Envenom:IsReady() and (v93 >= (10 - 6)) and (v103 or (v15:DebuffStack(v78.AmplifyingPoisonDebuff) >= (1888 - (708 + 1160))) or (v93 > v77.CPMaxSpend()) or not v109)) then
			if (v23(v78.Envenom) or ((10287 - 6497) == (911 - 411))) then
				return "Cast Envenom";
			end
		end
		if (((116 - (10 + 17)) < (50 + 171)) and not ((v94 > (1733 - (1400 + 332))) or v103 or not v109)) then
			return false;
		end
		if (((3939 - 1885) >= (3329 - (242 + 1666))) and not v109 and v78.CausticSpatter:IsAvailable() and v15:DebuffUp(v78.Rupture) and (v15:DebuffRemains(v78.CausticSpatterDebuff) <= (1 + 1))) then
			local v209 = 0 + 0;
			while true do
				if (((590 + 102) < (3998 - (850 + 90))) and (v209 == (0 - 0))) then
					if (v78.Mutilate:IsCastable() or ((4644 - (360 + 1030)) == (1465 + 190))) then
						if (v23(v78.Mutilate) or ((3657 - 2361) == (6755 - 1845))) then
							return "Cast Mutilate (Casutic)";
						end
					end
					if (((5029 - (909 + 752)) == (4591 - (109 + 1114))) and (v78.Ambush:IsCastable() or v78.AmbushOverride:IsCastable()) and (v14:StealthUp(true, true) or v14:BuffUp(v78.BlindsideBuff))) then
						if (((4838 - 2195) < (1486 + 2329)) and v23(v78.Ambush)) then
							return "Cast Ambush (Caustic)";
						end
					end
					break;
				end
			end
		end
		if (((2155 - (6 + 236)) > (311 + 182)) and v78.SerratedBoneSpike:IsReady()) then
			if (((3828 + 927) > (8084 - 4656)) and not v15:DebuffUp(v78.SerratedBoneSpikeDebuff)) then
				if (((2412 - 1031) <= (3502 - (1076 + 57))) and v23(v78.SerratedBoneSpike)) then
					return "Cast Serrated Bone Spike";
				end
			else
				local v220 = 0 + 0;
				while true do
					if ((v220 == (689 - (579 + 110))) or ((383 + 4460) == (3611 + 473))) then
						if (((2478 + 2191) > (770 - (174 + 233))) and v30) then
							if (v76.CastTargetIf(v78.SerratedBoneSpike, v86, "min", v128, v129) or ((5242 - 3365) >= (5507 - 2369))) then
								return "Cast Serrated Bone (AoE)";
							end
						end
						if (((2109 + 2633) >= (4800 - (663 + 511))) and (v118() < (0.8 + 0))) then
							if ((v10.BossFightRemains() <= (2 + 3)) or ((v78.SerratedBoneSpike:MaxCharges() - v78.SerratedBoneSpike:ChargesFractional()) <= (0.25 - 0)) or ((2750 + 1790) == (2156 - 1240))) then
								if (v23(v78.SerratedBoneSpike) or ((2798 - 1642) > (2074 + 2271))) then
									return "Cast Serrated Bone Spike (Dump Charge)";
								end
							elseif (((4353 - 2116) < (3029 + 1220)) and not v109 and v15:DebuffUp(v78.ShivDebuff)) then
								if (v23(v78.SerratedBoneSpike) or ((246 + 2437) < (745 - (478 + 244)))) then
									return "Cast Serrated Bone Spike (Shiv)";
								end
							end
						end
						break;
					end
				end
			end
		end
		if (((1214 - (440 + 77)) <= (376 + 450)) and v31 and v78.EchoingReprimand:IsReady()) then
			if (((4044 - 2939) <= (2732 - (655 + 901))) and v23(v78.EchoingReprimand)) then
				return "Cast Echoing Reprimand";
			end
		end
		if (((627 + 2752) <= (2919 + 893)) and v78.FanofKnives:IsCastable()) then
			local v210 = 0 + 0;
			while true do
				if ((v210 == (0 - 0)) or ((2233 - (695 + 750)) >= (5517 - 3901))) then
					if (((2861 - 1007) <= (13589 - 10210)) and v30 and (v88 >= (353 - (285 + 66))) and (v88 >= ((4 - 2) + v24(v14:StealthUp(true, false)) + v24(v78.DragonTemperedBlades:IsAvailable())))) then
						if (((5859 - (682 + 628)) == (734 + 3815)) and v23(v78.FanofKnives)) then
							return "Cast Fan of Knives";
						end
					end
					if ((v30 and (v88 >= (301 - (176 + 123)))) or ((1265 + 1757) >= (2194 + 830))) then
						if (((5089 - (239 + 30)) > (598 + 1600)) and v23(v78.FanofKnives)) then
							return "Fillers Fan of knives";
						end
					end
					break;
				end
			end
		end
		if (((v78.Ambush:IsCastable() or v78.AmbushOverride:IsCastable()) and (v14:StealthUp(true, true) or v14:BuffUp(v78.BlindsideBuff) or v14:BuffUp(v78.SepsisBuff)) and (v15:DebuffDown(v78.Kingsbane) or v15:DebuffDown(v78.Deathmark) or v14:BuffUp(v78.BlindsideBuff))) or ((1020 + 41) >= (8656 - 3765))) then
			if (((4255 - 2891) <= (4788 - (306 + 9))) and v23(v78.Ambush)) then
				return "Cast Ambush";
			end
		end
		if ((v78.Mutilate:IsCastable() and (v88 == (6 - 4)) and v15:DebuffDown(v78.DeadlyPoisonDebuff, true) and v15:DebuffDown(v78.AmplifyingPoisonDebuff, true)) or ((626 + 2969) <= (2 + 1))) then
			local v211 = v15:GUID();
			for v212, v213 in v33(v89) do
			end
		end
		if (v78.Mutilate:IsCastable() or ((2249 + 2423) == (11014 - 7162))) then
			if (((2934 - (1140 + 235)) == (993 + 566)) and v23(v78.Mutilate)) then
				return "Cast Mutilate";
			end
		end
		return false;
	end
	local function v137()
		local v198 = 0 + 0;
		while true do
			if ((v198 == (2 + 5)) or ((1804 - (33 + 19)) <= (285 + 503))) then
				if ((not v14:AffectingCombat() and not v14:IsMounted() and v76.TargetIsValid()) or ((11710 - 7803) == (78 + 99))) then
					local v231 = 0 - 0;
					while true do
						if (((3254 + 216) > (1244 - (586 + 103))) and (v231 == (0 + 0))) then
							v90 = v77.Stealth(v78.Stealth2, nil);
							if (v90 or ((2992 - 2020) == (2133 - (1309 + 179)))) then
								return "Stealth (OOC): " .. v90;
							end
							break;
						end
					end
				end
				v77.Poisons();
				if (((5743 - 2561) >= (921 + 1194)) and not v14:AffectingCombat()) then
					if (((10454 - 6561) < (3346 + 1083)) and not v14:BuffUp(v77.VanishBuffSpell())) then
						local v241 = 0 - 0;
						while true do
							if ((v241 == (0 - 0)) or ((3476 - (295 + 314)) < (4679 - 2774))) then
								v90 = v77.Stealth(v77.StealthSpell());
								if (v90 or ((3758 - (1300 + 662)) >= (12720 - 8669))) then
									return v90;
								end
								break;
							end
						end
					end
					if (((3374 - (1178 + 577)) <= (1951 + 1805)) and v76.TargetIsValid()) then
						local v242 = 0 - 0;
						while true do
							if (((2009 - (851 + 554)) == (535 + 69)) and (v242 == (0 - 0))) then
								if (v31 or ((9738 - 5254) == (1202 - (115 + 187)))) then
									if ((v29 and v78.MarkedforDeath:IsCastable() and (v14:ComboPointsDeficit() >= v77.CPMaxSpend()) and v76.TargetIsValid()) or ((3415 + 1044) <= (1054 + 59))) then
										if (((14312 - 10680) > (4559 - (160 + 1001))) and v10.Press(v78.MarkedforDeath, v61)) then
											return "Cast Marked for Death (OOC)";
										end
									end
								end
								if (((3572 + 510) <= (3393 + 1524)) and not v14:BuffUp(v78.SliceandDice)) then
									if (((9891 - 5059) >= (1744 - (237 + 121))) and v78.SliceandDice:IsReady() and (v93 >= (899 - (525 + 372)))) then
										if (((259 - 122) == (449 - 312)) and v10.Press(v78.SliceandDice)) then
											return "Cast Slice and Dice";
										end
									end
								end
								break;
							end
						end
					end
				end
				v198 = 150 - (96 + 46);
			end
			if ((v198 == (785 - (643 + 134))) or ((567 + 1003) >= (10386 - 6054))) then
				v77.MfDSniping(v78.MarkedforDeath);
				if (v76.TargetIsValid() or ((15088 - 11024) <= (1745 + 74))) then
					v105 = v77.PoisonedBleeds();
					v106 = v14:EnergyRegen() + ((v105 * (11 - 5)) / ((3 - 1) * v14:SpellHaste()));
					v107 = v14:EnergyDeficit() / v106;
					v108 = v106 > (754 - (316 + 403));
					v103 = v121();
					v104 = v122();
					v110 = v123();
					v109 = v88 < (2 + 0);
					if (v14:StealthUp(true, false) or (v119() > (0 - 0)) or (v118() > (0 + 0)) or ((12556 - 7570) < (1116 + 458))) then
						local v243 = 0 + 0;
						while true do
							if (((15335 - 10909) > (821 - 649)) and (v243 == (0 - 0))) then
								v90 = v134();
								if (((34 + 552) > (895 - 440)) and v90) then
									return v90 .. " (Stealthed)";
								end
								break;
							end
						end
					end
					v90 = v132();
					if (((41 + 785) == (2430 - 1604)) and v90) then
						return v90;
					end
					local v232 = v76.HandleDPSPotion();
					if (v232 or ((4036 - (12 + 5)) > (17248 - 12807))) then
						return v232;
					end
					v90 = v133();
					if (((4303 - 2286) < (9057 - 4796)) and v90) then
						return v90;
					end
					local v233 = v130();
					if (((11694 - 6978) > (17 + 63)) and v233) then
						return v233;
					end
					if (not v14:BuffUp(v78.SliceandDice) or ((5480 - (1656 + 317)) == (2916 + 356))) then
						if ((v78.SliceandDice:IsReady() and (v14:ComboPoints() >= (2 + 0)) and v15:DebuffUp(v78.Rupture)) or (not v78.CutToTheChase:IsAvailable() and (v14:ComboPoints() >= (10 - 6)) and (v14:BuffRemains(v78.SliceandDice) < (((4 - 3) + v14:ComboPoints()) * (355.8 - (5 + 349))))) or ((4160 - 3284) >= (4346 - (266 + 1005)))) then
							if (((2868 + 1484) > (8714 - 6160)) and v23(v78.SliceandDice)) then
								return "Cast Slice and Dice";
							end
						end
					elseif ((v85 and v78.CutToTheChase:IsAvailable()) or ((5800 - 1394) < (5739 - (561 + 1135)))) then
						if ((v78.Envenom:IsReady() and (v14:BuffRemains(v78.SliceandDice) < (6 - 1)) and (v14:ComboPoints() >= (12 - 8))) or ((2955 - (507 + 559)) >= (8488 - 5105))) then
							if (((5851 - 3959) <= (3122 - (212 + 176))) and v23(v78.Envenom)) then
								return "Cast Envenom (CttC)";
							end
						end
					elseif (((2828 - (250 + 655)) < (6048 - 3830)) and v78.PoisonedKnife:IsCastable() and v15:IsInRange(52 - 22) and not v14:StealthUp(true, true) and (v88 == (0 - 0)) and (v14:EnergyTimeToMax() <= (v14:GCD() * (1957.5 - (1869 + 87))))) then
						if (((7536 - 5363) > (2280 - (484 + 1417))) and v23(v78.PoisonedKnife)) then
							return "Cast Poisoned Knife";
						end
					end
					v90 = v135();
					if (v90 or ((5553 - 2962) == (5712 - 2303))) then
						return v90;
					end
					v90 = v136();
					if (((5287 - (48 + 725)) > (5429 - 2105)) and v90) then
						return v90;
					end
					if (v78.Mutilate:IsCastable() or v78.Ambush:IsCastable() or v78.AmbushOverride:IsCastable() or ((557 - 349) >= (2806 + 2022))) then
						if (v23(v78.PoolEnergy) or ((4230 - 2647) > (999 + 2568))) then
							return "Normal Pooling";
						end
					end
				end
				break;
			end
			if ((v198 == (1 + 0)) or ((2166 - (152 + 701)) == (2105 - (430 + 881)))) then
				v31 = EpicSettings.Toggles['cds'];
				v82 = (v78.AcrobaticStrikes:IsAvailable() and (4 + 4)) or (900 - (557 + 338));
				v83 = (v78.AcrobaticStrikes:IsAvailable() and (4 + 9)) or (28 - 18);
				v198 = 6 - 4;
			end
			if (((8432 - 5258) > (6253 - 3351)) and (v198 == (807 - (499 + 302)))) then
				if (((4986 - (39 + 827)) <= (11759 - 7499)) and v90) then
					return v90;
				end
				v90 = v77.Feint();
				if (v90 or ((1971 - 1088) > (18977 - 14199))) then
					return v90;
				end
				v198 = 10 - 3;
			end
			if (((1 + 3) == v198) or ((10595 - 6975) >= (783 + 4108))) then
				v95 = ((5 - 1) + (v93 * (108 - (103 + 1)))) * (554.3 - (475 + 79));
				v96 = ((8 - 4) + (v93 * (6 - 4))) * (0.3 + 0);
				v97 = v78.Envenom:Damage() * v65;
				v198 = 5 + 0;
			end
			if (((5761 - (1395 + 108)) > (2726 - 1789)) and ((1207 - (7 + 1197)) == v198)) then
				v91, v92 = (1 + 1) * v14:SpellHaste(), (1 + 0) * v14:SpellHaste();
				v93 = v77.EffectiveComboPoints(v14:ComboPoints());
				v94 = v14:ComboPointsMax() - v93;
				v198 = 323 - (27 + 292);
			end
			if ((v198 == (5 - 3)) or ((6208 - 1339) < (3799 - 2893))) then
				v84 = v15:IsInMeleeRange(v82);
				v85 = v15:IsInMeleeRange(v83);
				if (v30 or ((2415 - 1190) > (8051 - 3823))) then
					local v234 = 139 - (43 + 96);
					while true do
						if (((13575 - 10247) > (5059 - 2821)) and (v234 == (1 + 0))) then
							v88 = #v87;
							v89 = v14:GetEnemiesInMeleeRange(v82);
							break;
						end
						if (((1084 + 2755) > (2776 - 1371)) and (v234 == (0 + 0))) then
							v86 = v14:GetEnemiesInRange(56 - 26);
							v87 = v14:GetEnemiesInMeleeRange(v83);
							v234 = 1 + 0;
						end
					end
				else
					local v235 = 0 + 0;
					while true do
						if ((v235 == (1752 - (1414 + 337))) or ((3233 - (1642 + 298)) <= (1321 - 814))) then
							v88 = 2 - 1;
							v89 = {};
							break;
						end
						if ((v235 == (0 - 0)) or ((954 + 1942) < (627 + 178))) then
							v86 = {};
							v87 = {};
							v235 = 973 - (357 + 615);
						end
					end
				end
				v198 = 3 + 0;
			end
			if (((5682 - 3366) == (1985 + 331)) and (v198 == (10 - 5))) then
				v98 = v78.Mutilate:Damage() * v66;
				v102 = v49();
				v90 = v77.CrimsonVial();
				v198 = 5 + 1;
			end
			if ((v198 == (0 + 0)) or ((1616 + 954) == (2834 - (384 + 917)))) then
				v75();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v198 = 698 - (128 + 569);
			end
		end
	end
	local function v138()
		local v199 = 1543 - (1407 + 136);
		while true do
			if ((v199 == (1887 - (687 + 1200))) or ((2593 - (556 + 1154)) == (5136 - 3676))) then
				v78.Deathmark:RegisterAuraTracking();
				v78.Sepsis:RegisterAuraTracking();
				v199 = 96 - (9 + 86);
			end
			if ((v199 == (422 - (275 + 146))) or ((752 + 3867) <= (1063 - (29 + 35)))) then
				v78.Garrote:RegisterAuraTracking();
				v10.Print("Assassination Rogue by Epic. Supported by Gojira");
				break;
			end
		end
	end
	v10.SetAPL(1147 - 888, v137, v138);
end;
return v0["Epix_Rogue_Assassination.lua"]();

