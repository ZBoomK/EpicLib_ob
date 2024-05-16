local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1982 + 921) > (18148 - 13194))) then
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
	local v23 = v9.CastLeftNameplate;
	local v24 = v9.Commons.Everyone.num;
	local v25 = v9.Commons.Everyone.bool;
	local v26 = math.min;
	local v27 = math.abs;
	local v28 = math.max;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = v9.Press;
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
	local v75;
	local v76;
	local function v77()
		v35 = EpicSettings.Settings['UseRacials'];
		v37 = EpicSettings.Settings['UseHealingPotion'];
		v38 = EpicSettings.Settings['HealingPotionName'];
		v39 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v40 = EpicSettings.Settings['UseHealthstone'];
		v41 = EpicSettings.Settings['HealthstoneHP'] or (1619 - (1427 + 192));
		v42 = EpicSettings.Settings['InterruptWithStun'];
		v43 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v44 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
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
		v63 = EpicSettings.Settings['FeintHP'] or (1 + 0);
		v64 = EpicSettings.Settings['StealthOOC'];
		v65 = EpicSettings.Settings['EnvenomDMGOffset'] or (1 + 0);
		v66 = EpicSettings.Settings['MutilateDMGOffset'] or (327 - (192 + 134));
		v67 = EpicSettings.Settings['AlwaysSuggestGarrote'];
		v68 = EpicSettings.Settings['PotionTypeSelected'];
		v69 = EpicSettings.Settings['ExsanguinateGCD'];
		v70 = EpicSettings.Settings['KingsbaneGCD'];
		v71 = EpicSettings.Settings['ShivGCD'];
		v72 = EpicSettings.Settings['DeathmarkOffGCD'];
		v74 = EpicSettings.Settings['IndiscriminateCarnageOffGCD'];
		v73 = EpicSettings.Settings['KickOffGCD'];
		v75 = EpicSettings.Settings['EvasionHP'] or (1276 - (316 + 960));
		v76 = EpicSettings.Settings['BlindInterrupt'];
	end
	local v78 = v9.Commons.Everyone;
	local v79 = v9.Commons.Rogue;
	local v80 = v15.Rogue.Assassination;
	local v81 = v21.Rogue.Assassination;
	local v82 = v20.Rogue.Assassination;
	local v83 = {v82.AlgetharPuzzleBox,v82.AshesoftheEmbersoul,v82.WitherbarksBranch};
	local v84, v85, v86, v87;
	local v88, v89, v90, v91;
	local v92;
	local v93, v94 = (7 - 5) * v13:SpellHaste(), (552 - (83 + 468)) * v13:SpellHaste();
	local v95, v96;
	local v97, v98, v99, v100, v101, v102, v103;
	local v104;
	local v105, v106, v107, v108, v109, v110, v111, v112;
	local v113 = 1806 - (1202 + 604);
	local v114 = v13:GetEquipment();
	local v115 = (v114[60 - 47] and v20(v114[20 - 7])) or v20(0 - 0);
	local v116 = (v114[339 - (45 + 280)] and v20(v114[14 + 0])) or v20(0 + 0);
	local function v117()
		if (((1127 + 1957) > (23 + 17)) and v115:HasStatAnyDps() and (not v116:HasStatAnyDps() or (v115:Cooldown() >= v116:Cooldown()))) then
			v113 = 1 + 0;
		elseif (((6317 - 2905) > (2730 - (340 + 1571))) and v116:HasStatAnyDps() and (not v115:HasStatAnyDps() or (v116:Cooldown() > v115:Cooldown()))) then
			v113 = 1 + 1;
		else
			v113 = 1772 - (1733 + 39);
		end
	end
	v117();
	v9:RegisterForEvent(function()
		local v170 = 0 - 0;
		while true do
			if (((4196 - (125 + 909)) <= (5389 - (1096 + 852))) and (v170 == (0 + 0))) then
				v114 = v13:GetEquipment();
				v115 = (v114[17 - 4] and v20(v114[13 + 0])) or v20(512 - (409 + 103));
				v170 = 237 - (46 + 190);
			end
			if (((4801 - (51 + 44)) > (1250 + 3179)) and (v170 == (1318 - (1114 + 203)))) then
				v116 = (v114[740 - (228 + 498)] and v20(v114[4 + 10])) or v20(0 + 0);
				v117();
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v118 = {{v80.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v80.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v95 > (0 - 0);
	end}};
	v80.Envenom:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v95 * (0.22 - 0) * (1 + 0) * ((v14:DebuffUp(v80.ShivDebuff) and (3.3 - 2)) or (2 - 1)) * ((v80.DeeperStratagem:IsAvailable() and (1.05 - 0)) or (3 - 2)) * ((1249 - (111 + 1137)) + (v13:MasteryPct() / (258 - (91 + 67)))) * ((2 - 1) + (v13:VersatilityDmgPct() / (25 + 75)));
	end);
	v80.Mutilate:RegisterDamageFormula(function()
		return (v13:AttackPowerDamageMod() + v13:AttackPowerDamageMod(true)) * (523.485 - (423 + 100)) * (1 + 0) * ((2 - 1) + (v13:VersatilityDmgPct() / (53 + 47)));
	end);
	local function v119()
		return v13:BuffRemains(v80.MasterAssassinBuff) == (10770 - (326 + 445));
	end
	local function v120()
		local v171 = 0 - 0;
		while true do
			if (((6358 - 3504) < (9558 - 5463)) and (v171 == (711 - (530 + 181)))) then
				if (v119() or ((1939 - (614 + 267)) >= (1234 - (19 + 13)))) then
					return v13:GCDRemains() + (4 - 1);
				end
				return v13:BuffRemains(v80.MasterAssassinBuff);
			end
		end
	end
	local function v121()
		if (((8647 - 4936) > (9583 - 6228)) and v13:BuffUp(v80.ImprovedGarroteAura)) then
			return v13:GCDRemains() + 1 + 2;
		end
		return v13:BuffRemains(v80.ImprovedGarroteBuff);
	end
	local function v122()
		local v172 = 0 - 0;
		while true do
			if ((v172 == (0 - 0)) or ((2718 - (1293 + 519)) >= (4547 - 2318))) then
				if (((3362 - 2074) > (2392 - 1141)) and v13:BuffUp(v80.IndiscriminateCarnageAura)) then
					return v13:GCDRemains() + (43 - 33);
				end
				return v13:BuffRemains(v80.IndiscriminateCarnageBuff);
			end
		end
	end
	local function v49()
		local v173 = 0 - 0;
		while true do
			if ((v173 == (0 + 0)) or ((921 + 3592) < (7787 - 4435))) then
				if ((v90 < (1 + 1)) or ((687 + 1378) >= (1998 + 1198))) then
					return false;
				elseif ((v49 == "Always") or ((5472 - (709 + 387)) <= (3339 - (673 + 1185)))) then
					return true;
				elseif (((v49 == "On Bosses") and v14:IsInBossList()) or ((9836 - 6444) >= (15224 - 10483))) then
					return true;
				elseif (((5470 - 2145) >= (1541 + 613)) and (v49 == "Auto")) then
					if (((v13:InstanceDifficulty() == (12 + 4)) and (v14:NPCID() == (187627 - 48660))) or ((319 + 976) >= (6446 - 3213))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v123()
		local v174 = 0 - 0;
		while true do
			if (((6257 - (446 + 1434)) > (2925 - (1040 + 243))) and (v174 == (0 - 0))) then
				if (((6570 - (559 + 1288)) > (3287 - (609 + 1322))) and (v14:DebuffUp(v80.Deathmark) or v14:DebuffUp(v80.Kingsbane) or v13:BuffUp(v80.ShadowDanceBuff) or v14:DebuffUp(v80.ShivDebuff) or (v80.ThistleTea:FullRechargeTime() < (474 - (13 + 441))) or (v13:EnergyPercentage() >= (298 - 218)) or (v13:HasTier(81 - 50, 19 - 15) and ((v13:BuffUp(v80.Envenom) and (v13:BuffRemains(v80.Envenom) <= (1 + 1))) or v9.BossFilteredFightRemains("<=", 326 - 236))))) then
					return true;
				end
				return false;
			end
		end
	end
	local function v124()
		if (((v80.Deathmark:CooldownRemains() > v80.Sepsis:CooldownRemains()) and (v9.BossFightRemainsIsNotValid() or v9.BossFilteredFightRemains(">", v80.Deathmark:CooldownRemains()))) or ((1470 + 2666) <= (1505 + 1928))) then
			return v80.Deathmark:CooldownRemains();
		end
		return v80.Sepsis:CooldownRemains();
	end
	local function v125()
		if (((12597 - 8352) <= (2535 + 2096)) and not v80.ScentOfBlood:IsAvailable()) then
			return true;
		end
		return v13:BuffStack(v80.ScentOfBloodBuff) >= v26(36 - 16, v80.ScentOfBlood:TalentRank() * (2 + 0) * v90);
	end
	local function v126(v175, v176, v177)
		local v177 = v177 or v176:PandemicThreshold();
		return v175:DebuffRefreshable(v176, v177);
	end
	local function v127(v178, v179, v180, v181)
		local v182, v183 = nil, v180;
		local v184 = v14:GUID();
		for v208, v209 in v33(v181) do
			if (((2379 + 1897) >= (2813 + 1101)) and (v209:GUID() ~= v184) and v78.UnitIsCycleValid(v209, v183, -v209:DebuffRemains(v178)) and v179(v209)) then
				v182, v183 = v209, v209:TimeToDie();
			end
		end
		if (((167 + 31) <= (4271 + 94)) and v182) then
			v23(v182, v178);
		elseif (((5215 - (153 + 280)) > (13502 - 8826)) and v48) then
			local v234 = 0 + 0;
			while true do
				if (((1921 + 2943) > (1150 + 1047)) and (v234 == (0 + 0))) then
					v182, v183 = nil, v180;
					for v248, v249 in v33(v89) do
						if (((v249:GUID() ~= v184) and v78.UnitIsCycleValid(v249, v183, -v249:DebuffRemains(v178)) and v179(v249)) or ((2682 + 1018) == (3816 - 1309))) then
							v182, v183 = v249, v249:TimeToDie();
						end
					end
					v234 = 1 + 0;
				end
				if (((5141 - (89 + 578)) >= (196 + 78)) and (v234 == (1 - 0))) then
					if (v182 or ((2943 - (572 + 477)) <= (190 + 1216))) then
						v23(v182, v178);
					end
					break;
				end
			end
		end
	end
	local function v128(v185, v186, v187)
		local v188 = v186(v14);
		if (((944 + 628) >= (183 + 1348)) and (v185 == "first") and (v188 ~= (86 - (84 + 2)))) then
			return v14;
		end
		local v189, v190 = nil, 0 - 0;
		local function v191(v210)
			for v211, v212 in v33(v210) do
				local v213 = v186(v212);
				if ((not v189 and (v185 == "first")) or ((3377 + 1310) < (5384 - (497 + 345)))) then
					if (((85 + 3206) > (282 + 1385)) and (v213 ~= (1333 - (605 + 728)))) then
						v189, v190 = v212, v213;
					end
				elseif ((v185 == "min") or ((623 + 250) == (4521 - 2487))) then
					if (not v189 or (v213 < v190) or ((130 + 2686) < (40 - 29))) then
						v189, v190 = v212, v213;
					end
				elseif (((3335 + 364) < (13038 - 8332)) and (v185 == "max")) then
					if (((1998 + 648) >= (1365 - (457 + 32))) and (not v189 or (v213 > v190))) then
						v189, v190 = v212, v213;
					end
				end
				if (((261 + 353) <= (4586 - (832 + 570))) and v189 and (v213 == v190) and (v212:TimeToDie() > v189:TimeToDie())) then
					v189, v190 = v212, v213;
				end
			end
		end
		v191(v91);
		if (((2945 + 181) == (816 + 2310)) and v48) then
			v191(v89);
		end
		if ((v189 and (v190 == v188) and v187(v14)) or ((7739 - 5552) >= (2387 + 2567))) then
			return v14;
		end
		if ((v189 and v187(v189)) or ((4673 - (588 + 208)) == (9635 - 6060))) then
			return v189;
		end
		return nil;
	end
	local function v129(v192, v193, v194)
		local v195 = 1800 - (884 + 916);
		local v196;
		while true do
			if (((1479 - 772) > (367 + 265)) and ((653 - (232 + 421)) == v195)) then
				v196 = v14:TimeToDie();
				if (not v9.BossFightRemainsIsNotValid() or ((2435 - (1569 + 320)) >= (659 + 2025))) then
					v196 = v9.BossFightRemains();
				elseif (((279 + 1186) <= (14493 - 10192)) and (v196 < v194)) then
					return false;
				end
				v195 = 606 - (316 + 289);
			end
			if (((4460 - 2756) > (66 + 1359)) and (v195 == (1454 - (666 + 787)))) then
				if ((v34((v196 - v194) / v192) > v34(((v196 - v194) - v193) / v192)) or ((1112 - (360 + 65)) == (3957 + 277))) then
					return true;
				end
				return false;
			end
		end
	end
	local function v130(v197)
		if (v197:DebuffUp(v80.SerratedBoneSpikeDebuff) or ((3584 - (79 + 175)) < (2252 - 823))) then
			return 780345 + 219655;
		end
		return v197:TimeToDie();
	end
	local function v131(v198)
		return not v198:DebuffUp(v80.SerratedBoneSpikeDebuff);
	end
	local function v132()
		if (((3515 - 2368) >= (645 - 310)) and v80.BloodFury:IsCastable()) then
			if (((4334 - (503 + 396)) > (2278 - (92 + 89))) and v9.Cast(v80.BloodFury, v35)) then
				return "Cast Blood Fury";
			end
		end
		if (v80.Berserking:IsCastable() or ((7313 - 3543) >= (2073 + 1968))) then
			if (v9.Cast(v80.Berserking, v35) or ((2244 + 1547) <= (6308 - 4697))) then
				return "Cast Berserking";
			end
		end
		if (v80.Fireblood:IsCastable() or ((627 + 3951) <= (4578 - 2570))) then
			if (((982 + 143) <= (992 + 1084)) and v9.Cast(v80.Fireblood, v35)) then
				return "Cast Fireblood";
			end
		end
		if (v80.AncestralCall:IsCastable() or ((2262 - 1519) >= (550 + 3849))) then
			if (((1761 - 606) < (2917 - (485 + 759))) and ((not v80.Kingsbane:IsAvailable() and v14:DebuffUp(v80.ShivDebuff)) or (v14:DebuffUp(v80.Kingsbane) and (v14:DebuffRemains(v80.Kingsbane) < (18 - 10))))) then
				if (v9.Cast(v80.AncestralCall, v35) or ((3513 - (442 + 747)) <= (1713 - (832 + 303)))) then
					return "Cast Ancestral Call";
				end
			end
		end
		if (((4713 - (88 + 858)) == (1149 + 2618)) and v80.ArcaneTorrent:IsCastable() and (v13:EnergyDeficit() > (13 + 2))) then
			if (((169 + 3920) == (4878 - (766 + 23))) and v9.Cast(v80.ArcaneTorrent, v35)) then
				return "Cast Arcane Torrent";
			end
		end
		if (((22007 - 17549) >= (2289 - 615)) and v80.ArcanePulse:IsCastable()) then
			if (((2560 - 1588) <= (4812 - 3394)) and v9.Cast(v80.ArcanePulse, v35)) then
				return "Cast Arcane Pulse";
			end
		end
		if (v80.LightsJudgment:IsCastable() or ((6011 - (1036 + 37)) < (3377 + 1385))) then
			if (v9.Cast(v80.LightsJudgment, v35) or ((4875 - 2371) > (3355 + 909))) then
				return "Cast Lights Judgment";
			end
		end
		if (((3633 - (641 + 839)) == (3066 - (910 + 3))) and v80.BagofTricks:IsCastable()) then
			if (v9.Cast(v80.BagofTricks, v35) or ((1292 - 785) >= (4275 - (1466 + 218)))) then
				return "Cast Bag of Tricks";
			end
		end
		return false;
	end
	local function v133()
		if (((2060 + 2421) == (5629 - (556 + 592))) and v80.ShadowDance:IsCastable() and not v80.Kingsbane:IsAvailable()) then
			local v214 = 0 + 0;
			while true do
				if ((v214 == (808 - (329 + 479))) or ((3182 - (174 + 680)) < (2381 - 1688))) then
					if (((8970 - 4642) == (3091 + 1237)) and v80.ImprovedGarrote:IsAvailable() and v80.Garrote:CooldownUp() and ((v14:PMultiplier(v80.Garrote) <= (740 - (396 + 343))) or v126(v14, v80.Garrote)) and (v80.Deathmark:AnyDebuffUp() or (v80.Deathmark:CooldownRemains() < (2 + 10)) or (v80.Deathmark:CooldownRemains() > (1537 - (29 + 1448)))) and (v96 >= math.min(v90, 1393 - (135 + 1254)))) then
						local v247 = 0 - 0;
						while true do
							if (((7414 - 5826) >= (888 + 444)) and ((1527 - (389 + 1138)) == v247)) then
								if ((v13:EnergyPredicted() < (619 - (102 + 472))) or ((3939 + 235) > (2356 + 1892))) then
									if (v22(v80.PoolEnergy) or ((4277 + 309) <= (1627 - (320 + 1225)))) then
										return "Pool for Shadow Dance (Garrote)";
									end
								end
								if (((6876 - 3013) == (2364 + 1499)) and v22(v80.ShadowDance, v58)) then
									return "Cast Shadow Dance (Garrote)";
								end
								break;
							end
						end
					end
					if ((not v80.ImprovedGarrote:IsAvailable() and v80.MasterAssassin:IsAvailable() and not v126(v14, v80.Rupture) and (v14:DebuffRemains(v80.Garrote) > (1467 - (157 + 1307))) and (v14:DebuffUp(v80.Deathmark) or (v80.Deathmark:CooldownRemains() > (1919 - (821 + 1038)))) and (v14:DebuffUp(v80.ShivDebuff) or (v14:DebuffRemains(v80.Deathmark) < (9 - 5)) or v14:DebuffUp(v80.Sepsis)) and (v14:DebuffRemains(v80.Sepsis) < (1 + 2))) or ((500 - 218) <= (16 + 26))) then
						if (((11423 - 6814) >= (1792 - (834 + 192))) and v22(v80.ShadowDance, v58)) then
							return "Cast Shadow Dance (Master Assassin)";
						end
					end
					break;
				end
			end
		end
		if ((v80.Vanish:IsCastable() and not v13:IsTanking(v14)) or ((74 + 1078) == (639 + 1849))) then
			if (((74 + 3348) > (5189 - 1839)) and v80.ImprovedGarrote:IsAvailable() and not v80.MasterAssassin:IsAvailable() and v80.Garrote:CooldownUp() and ((v14:PMultiplier(v80.Garrote) <= (305 - (300 + 4))) or v126(v14, v80.Garrote))) then
				local v235 = 0 + 0;
				while true do
					if (((2295 - 1418) > (738 - (112 + 250))) and (v235 == (0 + 0))) then
						if ((not v80.IndiscriminateCarnage:IsAvailable() and (v80.Deathmark:AnyDebuffUp() or (v80.Deathmark:CooldownRemains() < (9 - 5))) and (v96 >= v26(v90, 3 + 1))) or ((1613 + 1505) <= (1385 + 466))) then
							if ((v13:EnergyPredicted() < (23 + 22)) or ((123 + 42) >= (4906 - (1001 + 413)))) then
								if (((8805 - 4856) < (5738 - (244 + 638))) and v22(v80.PoolEnergy)) then
									return "Pool for Vanish (Garrote Deathmark)";
								end
							end
							if (v22(v80.Vanish, v57) or ((4969 - (627 + 66)) < (8986 - 5970))) then
								return "Cast Vanish (Garrote Deathmark)";
							end
						end
						if (((5292 - (512 + 90)) > (6031 - (1665 + 241))) and v80.IndiscriminateCarnage:IsAvailable() and (v90 > (719 - (373 + 344)))) then
							local v252 = 0 + 0;
							while true do
								if (((0 + 0) == v252) or ((131 - 81) >= (1515 - 619))) then
									if ((v13:EnergyPredicted() < (1144 - (35 + 1064))) or ((1248 + 466) >= (6328 - 3370))) then
										if (v22(v80.PoolEnergy) or ((6 + 1485) < (1880 - (298 + 938)))) then
											return "Pool for Vanish (Garrote Deathmark)";
										end
									end
									if (((1963 - (233 + 1026)) < (2653 - (636 + 1030))) and v22(v80.Vanish, v57)) then
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
			if (((1901 + 1817) > (1862 + 44)) and v80.MasterAssassin:IsAvailable() and v80.Kingsbane:IsAvailable() and v14:DebuffUp(v80.Kingsbane) and (v14:DebuffRemains(v80.Kingsbane) <= (1 + 2)) and v14:DebuffUp(v80.Deathmark) and (v14:DebuffRemains(v80.Deathmark) <= (1 + 2))) then
				if (v22(v80.Vanish, v57) or ((1179 - (55 + 166)) > (705 + 2930))) then
					return "Cast Vanish (Kingsbane)";
				end
			end
			if (((353 + 3148) <= (17155 - 12663)) and not v80.ImprovedGarrote:IsAvailable() and v80.MasterAssassin:IsAvailable() and not v126(v14, v80.Rupture) and (v14:DebuffRemains(v80.Garrote) > (300 - (36 + 261))) and v14:DebuffUp(v80.Deathmark) and (v14:DebuffUp(v80.ShivDebuff) or (v14:DebuffRemains(v80.Deathmark) < (6 - 2)) or v14:DebuffUp(v80.Sepsis)) and (v14:DebuffRemains(v80.Sepsis) < (1371 - (34 + 1334)))) then
				if (v22(v80.Vanish, v57) or ((1324 + 2118) < (1980 + 568))) then
					return "Cast Vanish (Master Assassin)";
				end
			end
		end
	end
	local function v134()
		if (((4158 - (1035 + 248)) >= (1485 - (20 + 1))) and v115:IsReady()) then
			local v215 = v78.HandleTopTrinket(v83, v31, 5 + 3, nil);
			if (v215 or ((5116 - (134 + 185)) >= (6026 - (549 + 584)))) then
				return v215;
			end
		end
		if (v116:IsReady() or ((1236 - (314 + 371)) > (7099 - 5031))) then
			local v216 = v78.HandleBottomTrinket(v83, v31, 976 - (478 + 490), nil);
			if (((1120 + 994) > (2116 - (786 + 386))) and v216) then
				return v216;
			end
		end
	end
	local function v135()
		local v199 = 0 - 0;
		local v200;
		local v201;
		local v202;
		while true do
			if ((v199 == (1380 - (1055 + 324))) or ((3602 - (1093 + 247)) >= (2752 + 344))) then
				v201 = v134();
				if (v201 or ((238 + 2017) >= (14042 - 10505))) then
					return v201;
				end
				v202 = not v13:StealthUp(true, false) and v14:DebuffUp(v80.Rupture) and v13:BuffUp(v80.Envenom) and not v80.Deathmark:AnyDebuffUp() and (not v80.MasterAssassin:IsAvailable() or v14:DebuffUp(v80.Garrote)) and (not v80.Kingsbane:IsAvailable() or (v80.Kingsbane:CooldownRemains() <= (6 - 4)));
				v199 = 5 - 3;
			end
			if ((v199 == (0 - 0)) or ((1365 + 2472) < (5031 - 3725))) then
				if (((10168 - 7218) == (2225 + 725)) and v80.Sepsis:IsReady() and (v14:DebuffRemains(v80.Rupture) > (51 - 31)) and ((not v80.ImprovedGarrote:IsAvailable() and v14:DebuffUp(v80.Garrote)) or (v80.ImprovedGarrote:IsAvailable() and v80.Garrote:CooldownUp() and (v14:PMultiplier(v80.Garrote) <= (689 - (364 + 324))))) and (v14:FilteredTimeToDie(">", 27 - 17) or v9.BossFilteredFightRemains("<=", 23 - 13))) then
					if (v22(v80.Sepsis, nil, true) or ((1566 + 3157) < (13799 - 10501))) then
						return "Cast Sepsis";
					end
				end
				v200 = v78.HandleDPSPotion();
				if (((1819 - 683) >= (467 - 313)) and v200) then
					return v200;
				end
				v199 = 1269 - (1249 + 19);
			end
			if ((v199 == (3 + 0)) or ((1054 - 783) > (5834 - (686 + 400)))) then
				if (((3720 + 1020) >= (3381 - (73 + 156))) and v80.Kingsbane:IsReady() and (v14:DebuffUp(v80.ShivDebuff) or (v80.Shiv:CooldownRemains() < (1 + 5))) and v13:BuffUp(v80.Envenom) and ((v80.Deathmark:CooldownRemains() >= (861 - (721 + 90))) or v14:DebuffUp(v80.Deathmark))) then
					if (v22(v80.Kingsbane) or ((29 + 2549) >= (11006 - 7616))) then
						return "Cast Kingsbane";
					end
				end
				if (((511 - (224 + 246)) <= (2690 - 1029)) and v80.ThistleTea:IsCastable() and not v13:BuffUp(v80.ThistleTea) and (((v13:EnergyDeficit() >= ((184 - 84) + v108)) and (not v80.Kingsbane:IsAvailable() or (v80.ThistleTea:Charges() >= (1 + 1)))) or (v14:DebuffUp(v80.Kingsbane) and (v14:DebuffRemains(v80.Kingsbane) < (1 + 5))) or (not v80.Kingsbane:IsAvailable() and v80.Deathmark:AnyDebuffUp()) or v9.BossFilteredFightRemains("<", v80.ThistleTea:Charges() * (5 + 1)))) then
					if (((1194 - 593) < (11847 - 8287)) and v9.Cast(v80.ThistleTea)) then
						return "Cast Thistle Tea";
					end
				end
				if (((748 - (203 + 310)) < (2680 - (1238 + 755))) and v80.Deathmark:AnyDebuffUp() and (not v201 or v35)) then
					if (((318 + 4231) > (2687 - (709 + 825))) and v201) then
						v132();
					else
						v201 = v132();
					end
				end
				v199 = 7 - 3;
			end
			if ((v199 == (2 - 0)) or ((5538 - (196 + 668)) < (18446 - 13774))) then
				if (((7597 - 3929) < (5394 - (171 + 662))) and v80.Deathmark:IsCastable() and (v202 or v9.BossFilteredFightRemains("<=", 113 - (4 + 89)))) then
					if (v22(v80.Deathmark, v72) or ((1594 - 1139) == (1313 + 2292))) then
						return "Cast Deathmark";
					end
				end
				if ((v80.Shiv:IsReady() and not v14:DebuffUp(v80.ShivDebuff) and v14:DebuffUp(v80.Garrote) and v14:DebuffUp(v80.Rupture)) or ((11696 - 9033) == (1299 + 2013))) then
					if (((5763 - (35 + 1451)) <= (5928 - (28 + 1425))) and v9.BossFilteredFightRemains("<=", v80.Shiv:Charges() * (2001 - (941 + 1052)))) then
						if (v22(v80.Shiv) or ((835 + 35) == (2703 - (822 + 692)))) then
							return "Cast Shiv (End of Fight)";
						end
					end
					if (((2216 - 663) <= (1476 + 1657)) and v80.Kingsbane:IsAvailable() and v13:BuffUp(v80.Envenom)) then
						if ((not v80.LightweightShiv:IsAvailable() and ((v14:DebuffUp(v80.Kingsbane) and (v14:DebuffRemains(v80.Kingsbane) < (305 - (45 + 252)))) or (v80.Kingsbane:CooldownRemains() >= (24 + 0))) and (not v80.CrimsonTempest:IsAvailable() or v111 or v14:DebuffUp(v80.CrimsonTempest))) or ((770 + 1467) >= (8544 - 5033))) then
							if (v22(v80.Shiv) or ((1757 - (114 + 319)) > (4336 - 1316))) then
								return "Cast Shiv (Kingsbane)";
							end
						end
						if ((v80.LightweightShiv:IsAvailable() and (v14:DebuffUp(v80.Kingsbane) or (v80.Kingsbane:CooldownRemains() <= (1 - 0)))) or ((1908 + 1084) == (2802 - 921))) then
							if (((6507 - 3401) > (3489 - (556 + 1407))) and v22(v80.Shiv)) then
								return "Cast Shiv (Kingsbane Lightweight)";
							end
						end
					end
					if (((4229 - (741 + 465)) < (4335 - (170 + 295))) and v80.ArterialPrecision:IsAvailable() and v80.Deathmark:AnyDebuffUp()) then
						if (((76 + 67) > (68 + 6)) and v22(v80.Shiv)) then
							return "Cast Shiv (Arterial Precision)";
						end
					end
					if (((44 - 26) < (1751 + 361)) and not v80.Kingsbane:IsAvailable() and not v80.ArterialPrecision:IsAvailable()) then
						if (((704 + 393) <= (922 + 706)) and v80.Sepsis:IsAvailable()) then
							if (((5860 - (957 + 273)) == (1239 + 3391)) and (((v80.Shiv:ChargesFractional() > (0.9 + 0 + v24(v80.LightweightShiv:IsAvailable()))) and (v106 > (19 - 14))) or v14:DebuffUp(v80.Sepsis) or v14:DebuffUp(v80.Deathmark))) then
								if (((9328 - 5788) > (8195 - 5512)) and v22(v80.Shiv)) then
									return "Cast Shiv (Sepsis)";
								end
							end
						elseif (((23738 - 18944) >= (5055 - (389 + 1391))) and (not v80.CrimsonTempest:IsAvailable() or v111 or v14:DebuffUp(v80.CrimsonTempest))) then
							if (((932 + 552) == (155 + 1329)) and v22(v80.Shiv)) then
								return "Cast Shiv";
							end
						end
					end
				end
				if (((3259 - 1827) < (4506 - (783 + 168))) and v80.ShadowDance:IsCastable() and v80.Kingsbane:IsAvailable() and v13:BuffUp(v80.Envenom) and ((v80.Deathmark:CooldownRemains() >= (167 - 117)) or v202)) then
					if (v22(v80.ShadowDance) or ((1048 + 17) > (3889 - (309 + 2)))) then
						return "Cast Shadow Dance (Kingsbane Sync)";
					end
				end
				v199 = 9 - 6;
			end
			if ((v199 == (1216 - (1090 + 122))) or ((1555 + 3240) < (4725 - 3318))) then
				if (((1269 + 584) < (5931 - (628 + 490))) and not v13:StealthUp(true, true) and (v121() <= (0 + 0)) and (v120() <= (0 - 0))) then
					if (v201 or ((12891 - 10070) < (3205 - (431 + 343)))) then
						v133();
					else
						v201 = v133();
					end
				end
				if ((v80.ColdBlood:IsReady() and v13:DebuffDown(v80.ColdBlood) and (v95 >= (7 - 3)) and (v60 or not v201)) or ((8314 - 5440) < (1724 + 457))) then
					if (v17(v80.ColdBlood, v60) or ((344 + 2345) <= (2038 - (556 + 1139)))) then
						return "Cast Cold Blood";
					end
				end
				return v201;
			end
		end
	end
	local function v136()
		if ((v80.Kingsbane:IsAvailable() and v13:BuffUp(v80.Envenom)) or ((1884 - (6 + 9)) == (368 + 1641))) then
			local v217 = 0 + 0;
			while true do
				if ((v217 == (169 - (28 + 141))) or ((1374 + 2172) < (2865 - 543))) then
					if ((v80.Shiv:IsReady() and (v14:DebuffUp(v80.Kingsbane) or v80.Kingsbane:CooldownUp()) and v14:DebuffDown(v80.ShivDebuff)) or ((1475 + 607) == (6090 - (486 + 831)))) then
						if (((8441 - 5197) > (3714 - 2659)) and v22(v80.Shiv)) then
							return "Cast Shiv (Stealth Kingsbane)";
						end
					end
					if ((v80.Kingsbane:IsReady() and (v13:BuffRemains(v80.ShadowDanceBuff) >= (1 + 1))) or ((10475 - 7162) <= (3041 - (668 + 595)))) then
						if (v22(v80.Kingsbane, v70) or ((1279 + 142) >= (425 + 1679))) then
							return "Cast Kingsbane (Dance)";
						end
					end
					break;
				end
			end
		end
		if (((4941 - 3129) <= (3539 - (23 + 267))) and (v95 >= (1948 - (1129 + 815)))) then
			local v218 = 387 - (371 + 16);
			while true do
				if (((3373 - (1326 + 424)) <= (3706 - 1749)) and (v218 == (0 - 0))) then
					if (((4530 - (88 + 30)) == (5183 - (720 + 51))) and v14:DebuffUp(v80.Kingsbane) and (v13:BuffRemains(v80.Envenom) <= (4 - 2))) then
						if (((3526 - (421 + 1355)) >= (1388 - 546)) and v17(v80.Envenom, nil, nil, not v86)) then
							return "Cast Envenom (Stealth Kingsbane)";
						end
					end
					if (((2148 + 2224) > (2933 - (286 + 797))) and v111 and v119() and v13:BuffDown(v80.ShadowDanceBuff)) then
						if (((848 - 616) < (1359 - 538)) and v17(v80.Envenom, nil, nil, not v86)) then
							return "Cast Envenom (Master Assassin)";
						end
					end
					break;
				end
			end
		end
		if (((957 - (397 + 42)) < (282 + 620)) and v30 and v80.CrimsonTempest:IsReady() and v80.Nightstalker:IsAvailable() and (v90 >= (803 - (24 + 776))) and (v95 >= (5 - 1)) and not v80.Deathmark:IsReady()) then
			for v230, v231 in v33(v89) do
				if (((3779 - (222 + 563)) > (1890 - 1032)) and v126(v231, v80.CrimsonTempest, v98) and v231:FilteredTimeToDie(">", 5 + 1, -v231:DebuffRemains(v80.CrimsonTempest))) then
					if (v17(v80.CrimsonTempest) or ((3945 - (23 + 167)) <= (2713 - (690 + 1108)))) then
						return "Cast Crimson Tempest (Stealth)";
					end
				end
			end
		end
		if (((1424 + 2522) > (3088 + 655)) and v80.Garrote:IsCastable() and (v121() > (848 - (40 + 808)))) then
			local function v219(v232)
				return v232:DebuffRemains(v80.Garrote);
			end
			local function v220(v233)
				return ((v233:PMultiplier(v80.Garrote) <= (1 + 0)) or (v233:DebuffRemains(v80.Garrote) < ((45 - 33) / v79.ExsanguinatedRate(v233, v80.Garrote))) or ((v122() > (0 + 0)) and (v80.Garrote:AuraActiveCount() < v90))) and not v111 and (v233:FilteredTimeToDie(">", 2 + 0, -v233:DebuffRemains(v80.Garrote)) or v233:TimeToDieIsNotValid()) and v79.CanDoTUnit(v233, v100);
			end
			if (v30 or ((733 + 602) >= (3877 - (47 + 524)))) then
				local v236 = v128("min", v219, v220);
				if (((3144 + 1700) > (6158 - 3905)) and v236 and (v236:GUID() == v19:GUID())) then
					v22(v81.GarroteMouseOver);
				end
			end
			if (((675 - 223) == (1030 - 578)) and v220(v14)) then
				if (v17(v80.Garrote) or ((6283 - (1165 + 561)) < (62 + 2025))) then
					return "Cast Garrote (Improved Garrote)";
				end
			end
			if (((11998 - 8124) == (1479 + 2395)) and (v96 >= ((480 - (341 + 138)) + ((1 + 1) * v24(v80.ShroudedSuffocation:IsAvailable()))))) then
				local v237 = 0 - 0;
				while true do
					if ((v237 == (326 - (89 + 237))) or ((6234 - 4296) > (10389 - 5454))) then
						if ((v13:BuffDown(v80.ShadowDanceBuff) and ((v14:PMultiplier(v80.Garrote) <= (882 - (581 + 300))) or (v14:DebuffUp(v80.Deathmark) and (v120() < (1223 - (855 + 365)))))) or ((10106 - 5851) < (1118 + 2305))) then
							if (((2689 - (1030 + 205)) <= (2339 + 152)) and v17(v80.Garrote)) then
								return "Cast Garrote (Improved Garrote Low CP)";
							end
						end
						if ((v14:PMultiplier(v80.Garrote) <= (1 + 0)) or (v14:DebuffRemains(v80.Garrote) < (298 - (156 + 130))) or ((9445 - 5288) <= (4724 - 1921))) then
							if (((9939 - 5086) >= (786 + 2196)) and v17(v80.Garrote)) then
								return "Cast Garrote (Improved Garrote Low CP 2)";
							end
						end
						break;
					end
				end
			end
		end
		if (((2411 + 1723) > (3426 - (10 + 59))) and (v95 >= (2 + 2)) and (v14:PMultiplier(v80.Rupture) <= (4 - 3)) and (v13:BuffUp(v80.ShadowDanceBuff) or v14:DebuffUp(v80.Deathmark))) then
			if (v17(v80.Rupture) or ((4580 - (671 + 492)) < (2018 + 516))) then
				return "Cast Rupture (Nightstalker)";
			end
		end
	end
	local function v137()
		local v203 = 1215 - (369 + 846);
		while true do
			if ((v203 == (0 + 0)) or ((2323 + 399) <= (2109 - (1036 + 909)))) then
				if ((v30 and v80.CrimsonTempest:IsReady() and (v90 >= (2 + 0)) and (v95 >= (6 - 2)) and (v108 > (228 - (11 + 192))) and not v80.Deathmark:IsReady()) or ((1217 + 1191) < (2284 - (135 + 40)))) then
					for v241, v242 in v33(v89) do
						if ((v126(v242, v80.CrimsonTempest, v98) and (v242:PMultiplier(v80.CrimsonTempest) <= (2 - 1)) and v242:FilteredTimeToDie(">", 4 + 2, -v242:DebuffRemains(v80.CrimsonTempest))) or ((72 - 39) == (2181 - 726))) then
							if (v17(v80.CrimsonTempest) or ((619 - (50 + 126)) >= (11179 - 7164))) then
								return "Cast Crimson Tempest (AoE High Energy)";
							end
						end
					end
				end
				if (((749 + 2633) > (1579 - (1233 + 180))) and v80.Garrote:IsCastable() and (v96 >= (970 - (522 + 447)))) then
					local function v239(v243)
						return v126(v243, v80.Garrote) and (v243:PMultiplier(v80.Garrote) <= (1422 - (107 + 1314)));
					end
					if ((v239(v14) and v79.CanDoTUnit(v14, v100) and (v14:FilteredTimeToDie(">", 6 + 6, -v14:DebuffRemains(v80.Garrote)) or v14:TimeToDieIsNotValid())) or ((853 - 573) == (1300 + 1759))) then
						if (((3735 - 1854) > (5115 - 3822)) and v32(v80.Garrote)) then
							return "Pool for Garrote (ST)";
						end
					end
				end
				v203 = 1911 - (716 + 1194);
			end
			if (((41 + 2316) == (253 + 2104)) and (v203 == (504 - (74 + 429)))) then
				if (((236 - 113) == (61 + 62)) and v80.Rupture:IsReady() and (v95 >= (8 - 4))) then
					v101 = 3 + 1 + (v24(v80.DashingScoundrel:IsAvailable()) * (15 - 10)) + (v24(v80.Doomblade:IsAvailable()) * (12 - 7)) + (v24(v110) * (439 - (279 + 154)));
					local function v240(v244)
						return v126(v244, v80.Rupture, v97) and (v244:PMultiplier(v80.Rupture) <= (779 - (454 + 324))) and (v244:FilteredTimeToDie(">", v101, -v244:DebuffRemains(v80.Rupture)) or v244:TimeToDieIsNotValid());
					end
					if ((v240(v14) and v79.CanDoTUnit(v14, v99)) or ((831 + 225) >= (3409 - (12 + 5)))) then
						if (v22(v80.Rupture) or ((583 + 498) < (2738 - 1663))) then
							return "Cast Rupture";
						end
					end
				end
				if ((v80.Garrote:IsCastable() and (v96 >= (1 + 0)) and (v120() <= (1093 - (277 + 816))) and ((v14:PMultiplier(v80.Garrote) <= (4 - 3)) or ((v14:DebuffRemains(v80.Garrote) < v93) and (v90 >= (1186 - (1058 + 125))))) and (v14:DebuffRemains(v80.Garrote) < (v93 * (1 + 1))) and (v90 >= (978 - (815 + 160))) and (v14:FilteredTimeToDie(">", 17 - 13, -v14:DebuffRemains(v80.Garrote)) or v14:TimeToDieIsNotValid())) or ((2489 - 1440) >= (1058 + 3374))) then
					if (v22(v80.Garrote) or ((13937 - 9169) <= (2744 - (41 + 1857)))) then
						return "Garrote (Fallback)";
					end
				end
				v203 = 1895 - (1222 + 671);
			end
			if ((v203 == (5 - 3)) or ((4826 - 1468) <= (2602 - (229 + 953)))) then
				return false;
			end
		end
	end
	local function v138()
		if ((v80.Envenom:IsReady() and (v95 >= (1778 - (1111 + 663))) and (v105 or (v14:DebuffStack(v80.AmplifyingPoisonDebuff) >= (1599 - (874 + 705))) or (v95 > v79.CPMaxSpend()) or not v111)) or ((524 + 3215) <= (2051 + 954))) then
			if (v22(v80.Envenom) or ((3447 - 1788) >= (61 + 2073))) then
				return "Cast Envenom";
			end
		end
		if (not ((v96 > (680 - (642 + 37))) or v105 or not v111) or ((744 + 2516) < (377 + 1978))) then
			return false;
		end
		if ((not v111 and v80.CausticSpatter:IsAvailable() and v14:DebuffUp(v80.Rupture) and (v14:DebuffRemains(v80.CausticSpatterDebuff) <= (4 - 2))) or ((1123 - (233 + 221)) == (9765 - 5542))) then
			if (v80.Mutilate:IsCastable() or ((1490 + 202) < (2129 - (718 + 823)))) then
				if (v22(v80.Mutilate) or ((3019 + 1778) < (4456 - (266 + 539)))) then
					return "Cast Mutilate (Casutic)";
				end
			end
			if (((v80.Ambush:IsCastable() or v80.AmbushOverride:IsCastable()) and (v13:StealthUp(true, true) or v13:BuffUp(v80.BlindsideBuff))) or ((11826 - 7649) > (6075 - (636 + 589)))) then
				if (v22(v80.Ambush) or ((949 - 549) > (2291 - 1180))) then
					return "Cast Ambush (Caustic)";
				end
			end
		end
		if (((2418 + 633) > (366 + 639)) and v80.SerratedBoneSpike:IsReady()) then
			if (((4708 - (657 + 358)) <= (11602 - 7220)) and not v14:DebuffUp(v80.SerratedBoneSpikeDebuff)) then
				if (v22(v80.SerratedBoneSpike) or ((7477 - 4195) > (5287 - (1151 + 36)))) then
					return "Cast Serrated Bone Spike";
				end
			else
				if (v30 or ((3458 + 122) < (748 + 2096))) then
					if (((265 - 176) < (6322 - (1552 + 280))) and v78.CastTargetIf(v80.SerratedBoneSpike, v88, "min", v130, v131)) then
						return "Cast Serrated Bone (AoE)";
					end
				end
				if ((v120() < (834.8 - (64 + 770))) or ((3384 + 1599) < (4104 - 2296))) then
					if (((680 + 3149) > (5012 - (157 + 1086))) and ((v9.BossFightRemains() <= (10 - 5)) or ((v80.SerratedBoneSpike:MaxCharges() - v80.SerratedBoneSpike:ChargesFractional()) <= (0.25 - 0)))) then
						if (((2277 - 792) <= (3963 - 1059)) and v22(v80.SerratedBoneSpike)) then
							return "Cast Serrated Bone Spike (Dump Charge)";
						end
					elseif (((5088 - (599 + 220)) == (8500 - 4231)) and not v111 and v14:DebuffUp(v80.ShivDebuff)) then
						if (((2318 - (1813 + 118)) <= (2034 + 748)) and v22(v80.SerratedBoneSpike)) then
							return "Cast Serrated Bone Spike (Shiv)";
						end
					end
				end
			end
		end
		if ((v31 and v80.EchoingReprimand:IsReady()) or ((3116 - (841 + 376)) <= (1284 - 367))) then
			if (v22(v80.EchoingReprimand) or ((1002 + 3310) <= (2391 - 1515))) then
				return "Cast Echoing Reprimand";
			end
		end
		if (((3091 - (464 + 395)) <= (6662 - 4066)) and v80.FanofKnives:IsCastable()) then
			local v221 = 0 + 0;
			while true do
				if (((2932 - (467 + 370)) < (7616 - 3930)) and (v221 == (0 + 0))) then
					if ((v30 and (v90 >= (6 - 4)) and (v90 >= (1 + 1 + v24(v13:StealthUp(true, false)) + v24(v80.DragonTemperedBlades:IsAvailable())))) or ((3710 - 2115) >= (4994 - (150 + 370)))) then
						if (v22(v80.FanofKnives) or ((5901 - (74 + 1208)) < (7088 - 4206))) then
							return "Cast Fan of Knives";
						end
					end
					if ((v30 and v13:BuffUp(v80.DeadlyPoison) and (v90 >= (14 - 11))) or ((210 + 84) >= (5221 - (14 + 376)))) then
						for v250, v251 in v33(v89) do
							if (((3518 - 1489) <= (1996 + 1088)) and not v251:DebuffUp(v80.DeadlyPoisonDebuff, true) and (not v104 or v251:DebuffUp(v80.Garrote) or v251:DebuffUp(v80.Rupture))) then
								if (v22(v80.FanofKnives) or ((1790 + 247) == (2308 + 112))) then
									return "Cast Fan of Knives (DP Refresh)";
								end
							end
						end
					end
					break;
				end
			end
		end
		if (((13062 - 8604) > (2937 + 967)) and (v80.Ambush:IsCastable() or v80.AmbushOverride:IsCastable()) and (v13:StealthUp(true, true) or v13:BuffUp(v80.BlindsideBuff) or v13:BuffUp(v80.SepsisBuff)) and (v14:DebuffDown(v80.Kingsbane) or v14:DebuffDown(v80.Deathmark) or v13:BuffUp(v80.BlindsideBuff))) then
			if (((514 - (23 + 55)) >= (291 - 168)) and v22(v80.Ambush)) then
				return "Cast Ambush";
			end
		end
		if (((334 + 166) < (1631 + 185)) and v80.Mutilate:IsCastable() and (v90 == (2 - 0)) and v14:DebuffDown(v80.DeadlyPoisonDebuff, true) and v14:DebuffDown(v80.AmplifyingPoisonDebuff, true)) then
			local v222 = 0 + 0;
			local v223;
			while true do
				if (((4475 - (652 + 249)) == (9564 - 5990)) and (v222 == (1868 - (708 + 1160)))) then
					v223 = v14:GUID();
					for v245, v246 in v33(v91) do
					end
					break;
				end
			end
		end
		if (((599 - 378) < (711 - 321)) and v80.Mutilate:IsCastable()) then
			if (v22(v80.Mutilate) or ((2240 - (10 + 17)) <= (320 + 1101))) then
				return "Cast Mutilate";
			end
		end
		return false;
	end
	local function v139()
		v77();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v84 = (v80.AcrobaticStrikes:IsAvailable() and (1740 - (1400 + 332))) or (9 - 4);
		v85 = (v80.AcrobaticStrikes:IsAvailable() and (1921 - (242 + 1666))) or (5 + 5);
		v86 = v14:IsInMeleeRange(v84);
		v87 = v14:IsInMeleeRange(v85);
		if (((1121 + 1937) < (4142 + 718)) and v30) then
			local v224 = 940 - (850 + 90);
			while true do
				if ((v224 == (1 - 0)) or ((2686 - (360 + 1030)) >= (3935 + 511))) then
					v90 = #v89;
					v91 = v13:GetEnemiesInMeleeRange(v84);
					break;
				end
				if ((v224 == (0 - 0)) or ((1915 - 522) > (6150 - (909 + 752)))) then
					v88 = v13:GetEnemiesInRange(1253 - (109 + 1114));
					v89 = v13:GetEnemiesInMeleeRange(v85);
					v224 = 1 - 0;
				end
			end
		else
			v88 = {};
			v89 = {};
			v90 = 1 + 0;
			v91 = {};
		end
		v93, v94 = (244 - (6 + 236)) * v13:SpellHaste(), (1 + 0) * v13:SpellHaste();
		v95 = v79.EffectiveComboPoints(v13:ComboPoints());
		v96 = v13:ComboPointsMax() - v95;
		v97 = (4 + 0 + (v95 * (8 - 4))) * (0.3 - 0);
		v98 = ((1137 - (1076 + 57)) + (v95 * (1 + 1))) * (689.3 - (579 + 110));
		v99 = v80.Envenom:Damage() * v65;
		v100 = v80.Mutilate:Damage() * v66;
		v104 = v49();
		v92 = v79.CrimsonVial();
		if (v92 or ((350 + 4074) < (24 + 3))) then
			return v92;
		end
		if ((v37 and (v13:HealthPercentage() <= v39)) or ((1060 + 937) > (4222 - (174 + 233)))) then
			local v225 = 0 - 0;
			while true do
				if (((6081 - 2616) > (851 + 1062)) and (v225 == (1174 - (663 + 511)))) then
					if (((654 + 79) < (395 + 1424)) and (v38 == "Refreshing Healing Potion")) then
						if (v82.RefreshingHealingPotion:IsReady() or ((13549 - 9154) == (2880 + 1875))) then
							if (v9.Press(v81.RefreshingHealingPotion) or ((8929 - 5136) < (5734 - 3365))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v38 == "Dreamwalker's Healing Potion") or ((1949 + 2135) == (515 - 250))) then
						if (((3106 + 1252) == (399 + 3959)) and v82.DreamwalkersHealingPotion:IsReady()) then
							if (v9.Press(v81.RefreshingHealingPotion) or ((3860 - (478 + 244)) < (1510 - (440 + 77)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
		v92 = v79.Feint();
		if (((1515 + 1815) > (8502 - 6179)) and v92) then
			return v92;
		end
		if ((v80.Evasion:IsCastable() and v80.Evasion:IsReady() and (v13:HealthPercentage() <= v75)) or ((5182 - (655 + 901)) == (740 + 3249))) then
			if (v9.Cast(v80.Evasion) or ((702 + 214) == (1804 + 867))) then
				return "Cast Evasion (Defensives)";
			end
		end
		if (((1095 - 823) == (1717 - (695 + 750))) and not v13:AffectingCombat() and not v13:IsMounted() and v78.TargetIsValid()) then
			local v226 = 0 - 0;
			while true do
				if (((6556 - 2307) <= (19461 - 14622)) and (v226 == (351 - (285 + 66)))) then
					v92 = v79.Stealth(v80.Stealth2, nil);
					if (((6472 - 3695) < (4510 - (682 + 628))) and v92) then
						return "Stealth (OOC): " .. v92;
					end
					break;
				end
			end
		end
		v79.Poisons();
		if (((16 + 79) < (2256 - (176 + 123))) and not v13:AffectingCombat()) then
			local v227 = 0 + 0;
			while true do
				if (((600 + 226) < (1986 - (239 + 30))) and ((0 + 0) == v227)) then
					if (((1371 + 55) >= (1955 - 850)) and not v13:BuffUp(v79.VanishBuffSpell())) then
						v92 = v79.Stealth(v79.StealthSpell());
						if (((8592 - 5838) <= (3694 - (306 + 9))) and v92) then
							return v92;
						end
					end
					if (v78.TargetIsValid() or ((13703 - 9776) == (246 + 1167))) then
						if (v31 or ((709 + 445) <= (380 + 408))) then
							if ((v29 and v80.MarkedforDeath:IsCastable() and (v13:ComboPointsDeficit() >= v79.CPMaxSpend()) and v78.TargetIsValid()) or ((4698 - 3055) > (4754 - (1140 + 235)))) then
								if (v9.Press(v80.MarkedforDeath, v61) or ((1784 + 1019) > (4172 + 377))) then
									return "Cast Marked for Death (OOC)";
								end
							end
						end
						if (not v13:BuffUp(v80.SliceandDice) or ((57 + 163) >= (3074 - (33 + 19)))) then
							if (((1019 + 1803) == (8458 - 5636)) and v80.SliceandDice:IsReady() and (v95 >= (1 + 1))) then
								if (v9.Press(v80.SliceandDice) or ((2080 - 1019) == (1742 + 115))) then
									return "Cast Slice and Dice";
								end
							end
						end
					end
					break;
				end
			end
		end
		v79.MfDSniping(v80.MarkedforDeath);
		if (((3449 - (586 + 103)) > (125 + 1239)) and v78.TargetIsValid()) then
			if ((not v13:IsCasting() and not v13:IsChanneling()) or ((15091 - 10189) <= (5083 - (1309 + 179)))) then
				local v238 = v78.Interrupt(v80.Kick, 14 - 6, true);
				if (v238 or ((1677 + 2175) == (786 - 493))) then
					return v238;
				end
				v238 = v78.Interrupt(v80.Kick, 7 + 1, true, v19, v81.KickMouseover);
				if (v238 or ((3311 - 1752) == (9141 - 4553))) then
					return v238;
				end
				v238 = v78.Interrupt(v80.Blind, 624 - (295 + 314), v76);
				if (v238 or ((11013 - 6529) == (2750 - (1300 + 662)))) then
					return v238;
				end
				v238 = v78.Interrupt(v80.Blind, 46 - 31, v76, v19, v81.BlindMouseover);
				if (((6323 - (1178 + 577)) >= (2030 + 1877)) and v238) then
					return v238;
				end
				v238 = v78.InterruptWithStun(v80.CheapShot, 23 - 15, v13:StealthUp(false, false));
				if (((2651 - (851 + 554)) < (3069 + 401)) and v238) then
					return v238;
				end
				v238 = v78.InterruptWithStun(v80.KidneyShot, 22 - 14, v13:ComboPoints() > (0 - 0));
				if (((4370 - (115 + 187)) >= (745 + 227)) and v238) then
					return v238;
				end
			end
			v107 = v79.PoisonedBleeds();
			v108 = v13:EnergyRegen() + ((v107 * (6 + 0)) / ((7 - 5) * v13:SpellHaste()));
			v109 = v13:EnergyDeficit() / v108;
			v110 = v108 > (1196 - (160 + 1001));
			v105 = v123();
			v106 = v124();
			v112 = v125();
			v111 = v90 < (2 + 0);
			if (((341 + 152) < (7969 - 4076)) and (v13:StealthUp(true, false) or (v121() > (358 - (237 + 121))) or (v120() > (897 - (525 + 372))))) then
				v92 = v136();
				if (v92 or ((2791 - 1318) >= (10947 - 7615))) then
					return v92 .. " (Stealthed)";
				end
			end
			v92 = v134();
			if (v92 or ((4193 - (96 + 46)) <= (1934 - (643 + 134)))) then
				return v92;
			end
			local v228 = v78.HandleDPSPotion();
			if (((219 + 385) < (6907 - 4026)) and v228) then
				return v228;
			end
			v92 = v135();
			if (v92 or ((3341 - 2441) == (3239 + 138))) then
				return v92;
			end
			local v229 = v132();
			if (((8750 - 4291) > (1207 - 616)) and v229) then
				return v229;
			end
			if (((4117 - (316 + 403)) >= (1592 + 803)) and not v13:BuffUp(v80.SliceandDice)) then
				if ((v80.SliceandDice:IsReady() and (v13:ComboPoints() >= (5 - 3)) and v14:DebuffUp(v80.Rupture)) or (not v80.CutToTheChase:IsAvailable() and (v13:ComboPoints() >= (2 + 2)) and (v13:BuffRemains(v80.SliceandDice) < (((2 - 1) + v13:ComboPoints()) * (1.8 + 0)))) or ((704 + 1479) >= (9784 - 6960))) then
					if (((9246 - 7310) == (4021 - 2085)) and v22(v80.SliceandDice)) then
						return "Cast Slice and Dice";
					end
				end
			elseif ((v87 and v80.CutToTheChase:IsAvailable()) or ((277 + 4555) < (8490 - 4177))) then
				if (((200 + 3888) > (11397 - 7523)) and v80.Envenom:IsReady() and (v13:BuffRemains(v80.SliceandDice) < (22 - (12 + 5))) and (v13:ComboPoints() >= (15 - 11))) then
					if (((9242 - 4910) == (9208 - 4876)) and v22(v80.Envenom)) then
						return "Cast Envenom (CttC)";
					end
				end
			elseif (((9916 - 5917) >= (589 + 2311)) and v80.PoisonedKnife:IsCastable() and v14:IsInRange(2003 - (1656 + 317)) and not v13:StealthUp(true, true) and (v90 == (0 + 0)) and (v13:EnergyTimeToMax() <= (v13:GCD() * (1.5 + 0)))) then
				if (v22(v80.PoisonedKnife) or ((6714 - 4189) > (20001 - 15937))) then
					return "Cast Poisoned Knife";
				end
			end
			v92 = v137();
			if (((4725 - (5 + 349)) == (20761 - 16390)) and v92) then
				return v92;
			end
			v92 = v138();
			if (v92 or ((1537 - (266 + 1005)) > (3286 + 1700))) then
				return v92;
			end
			if (((6793 - 4802) >= (1217 - 292)) and (v80.Ambush:IsCastable() or (v80.AmbushOverride:IsCastable() and (v13:ComboPoints() < (1700 - (561 + 1135)))))) then
				if (((592 - 137) < (6748 - 4695)) and v22(v80.Ambush)) then
					return "Ambush";
				end
			end
			if ((v80.Mutilate:IsCastable() and (v13:ComboPoints() < (1071 - (507 + 559)))) or ((2072 - 1246) == (15002 - 10151))) then
				if (((571 - (212 + 176)) == (1088 - (250 + 655))) and v22(v80.Mutilate)) then
					return "Cast Mutilate (Fallback)";
				end
			end
			if (((3160 - 2001) <= (3124 - 1336)) and v80.Envenom:IsReady() and (v13:BuffRemains(v80.SliceandDice) < (7 - 2)) and (v13:ComboPoints() >= (1960 - (1869 + 87)))) then
				if (v22(v80.Envenom) or ((12163 - 8656) > (6219 - (484 + 1417)))) then
					return "Cast Envenom (ppolling)";
				end
			end
		end
	end
	local function v140()
		local v207 = 0 - 0;
		while true do
			if (((0 - 0) == v207) or ((3848 - (48 + 725)) <= (4843 - 1878))) then
				v80.Deathmark:RegisterAuraTracking();
				v80.Sepsis:RegisterAuraTracking();
				v207 = 2 - 1;
			end
			if (((794 + 571) <= (5374 - 3363)) and (v207 == (1 + 0))) then
				v80.Garrote:RegisterAuraTracking();
				v9.Print("Assassination Rogue by Epic. Supported by Gojira");
				break;
			end
		end
	end
	v9.SetAPL(76 + 183, v139, v140);
end;
return v0["Epix_Rogue_Assassination.lua"]();

