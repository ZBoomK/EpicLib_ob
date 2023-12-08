local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((2758 - (588 + 208)) >= (6756 - 4249))) then
			return v6(...);
		end
		if ((v5 == (1800 - (884 + 916))) or ((573 - 299) == (2077 + 1505))) then
			v6 = v0[v4];
			if (not v6 or ((2571 - (232 + 421)) == (2964 - (1569 + 320)))) then
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
	local v27 = v10.CastQueue;
	local v28 = v10.CastQueuePooling;
	local v29 = v10.Commons.Everyone.num;
	local v30 = v10.Commons.Everyone.bool;
	local v31 = pairs;
	local v32 = table.insert;
	local v33 = math.min;
	local v34 = math.max;
	local v35 = math.abs;
	local v36 = false;
	local v37 = false;
	local v38 = false;
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
	local v83;
	local v84;
	local function v85()
		v39 = EpicSettings.Settings['UseRacials'];
		v53 = EpicSettings.Settings['UseTrinkets'];
		v40 = EpicSettings.Settings['UseHealingPotion'];
		v41 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
		v42 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v43 = EpicSettings.Settings['UseHealthstone'];
		v44 = EpicSettings.Settings['HealthstoneHP'] or (605 - (316 + 289));
		v45 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v46 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v47 = EpicSettings.Settings['InterruptThreshold'] or (1453 - (666 + 787));
		v49 = EpicSettings.Settings['PoisonRefresh'];
		v50 = EpicSettings.Settings['PoisonRefreshCombat'];
		v51 = EpicSettings.Settings['RangedMultiDoT'];
		v52 = EpicSettings.Settings['UsePriorityRotation'];
		v58 = EpicSettings.Settings['STMfDAsDPSCD'];
		v59 = EpicSettings.Settings['KidneyShotInterrupt'];
		v60 = EpicSettings.Settings['RacialsGCD'];
		v61 = EpicSettings.Settings['RacialsOffGCD'];
		v62 = EpicSettings.Settings['VanishOffGCD'];
		v63 = EpicSettings.Settings['ShadowDanceOffGCD'];
		v64 = EpicSettings.Settings['ThistleTeaOffGCD'];
		v65 = EpicSettings.Settings['ColdBloodOffGCD'];
		v66 = EpicSettings.Settings['MarkedforDeathOffGCD'];
		v67 = EpicSettings.Settings['CrimsonVialHP'];
		v68 = EpicSettings.Settings['FeintHP'];
		v69 = EpicSettings.Settings['StealthOOC'];
		v70 = EpicSettings.Settings['CrimsonVialGCD'];
		v71 = EpicSettings.Settings['FeintGCD'];
		v72 = EpicSettings.Settings['KickOffGCD'];
		v73 = EpicSettings.Settings['StealthOffGCD'];
		v74 = EpicSettings.Settings['EviscerateDMGOffset'] or true;
		v75 = EpicSettings.Settings['ShDEcoCharge'];
		v76 = EpicSettings.Settings['BurnShadowDance'];
		v77 = EpicSettings.Settings['PotionTypeSelectedSubtlety'];
		v78 = EpicSettings.Settings['ShurikenTornadoGCD'];
		v79 = EpicSettings.Settings['SymbolsofDeathOffGCD'];
		v80 = EpicSettings.Settings['ShadowBladesOffGCD'];
		v81 = EpicSettings.Settings['VanishStealthMacro'];
		v82 = EpicSettings.Settings['ShadowmeldStealthMacro'];
		v83 = EpicSettings.Settings['ShadowDanceStealthMacro'];
	end
	local v86 = v10.Commons.Everyone;
	local v87 = v10.Commons.Rogue;
	local v88 = v17.Rogue.Subtlety;
	local v89 = v19.Rogue.Subtlety;
	local v90 = v25.Rogue.Subtlety;
	local v91 = {v89.ManicGrieftorch:ID(),v89.BeaconToTheBeyond:ID(),v89.Mirror:ID()};
	local v92, v93, v94, v95;
	local v96, v97, v98, v99, v100;
	local v101;
	local v102, v103, v104;
	local v105, v106;
	local v107, v108, v109, v110;
	local v111;
	v88.Eviscerate:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v107 * (0.176 - 0) * (1.21 + 0) * ((v88.Nightstalker:IsAvailable() and v13:StealthUp(true, false) and (2.08 - 1)) or (1 - 0)) * ((v88.DeeperStratagem:IsAvailable() and (900.05 - (503 + 396))) or (182 - (92 + 89))) * ((v88.DarkShadow:IsAvailable() and v13:BuffUp(v88.ShadowDanceBuff) and (1.3 - 0)) or (1 + 0)) * ((v13:BuffUp(v88.SymbolsofDeath) and (1.1 + 0)) or (3 - 2)) * ((v13:BuffUp(v88.FinalityEviscerateBuff) and (1.3 + 0)) or (2 - 1)) * (1 + 0 + (v13:MasteryPct() / (48 + 52))) * ((2 - 1) + (v13:VersatilityDmgPct() / (13 + 87))) * ((v14:DebuffUp(v88.FindWeaknessDebuff) and (1.5 - 0)) or (1245 - (485 + 759)));
	end);
	v88.Rupture:RegisterPMultiplier(function()
		return (v13:BuffUp(v88.FinalityRuptureBuff) and (2.3 - 1)) or (1190 - (442 + 747));
	end);
	local function v112(v171, v172)
		if (((1531 - (832 + 303)) <= (4750 - (88 + 858))) and not v102) then
			local v222 = 0 + 0;
			while true do
				if ((v222 == (0 + 0)) or ((172 + 3997) == (2976 - (766 + 23)))) then
					v102 = v171;
					v103 = v172 or (0 - 0);
					break;
				end
			end
		end
	end
	local function v113(v173)
		if (((1922 - 516) == (3704 - 2298)) and not v104) then
			v104 = v173;
		end
	end
	local function v114()
		if (((5196 - 3665) < (5344 - (1036 + 37))) and (v76 == "On Bosses not in Dungeons") and v13:IsInDungeonArea()) then
			return false;
		elseif (((451 + 184) == (1236 - 601)) and (v76 ~= "Always") and not v14:IsInBossList()) then
			return false;
		else
			return true;
		end
	end
	local function v115()
		if (((2654 + 719) <= (5036 - (641 + 839))) and (v98 < (915 - (910 + 3)))) then
			return false;
		elseif ((v52 == "Always") or ((8389 - 5098) < (4964 - (1466 + 218)))) then
			return true;
		elseif (((2016 + 2370) >= (2021 - (556 + 592))) and (v52 == "On Bosses") and v14:IsInBossList()) then
			return true;
		elseif (((328 + 593) <= (1910 - (329 + 479))) and (v52 == "Auto")) then
			if (((5560 - (174 + 680)) >= (3308 - 2345)) and (v13:InstanceDifficulty() == (32 - 16)) and (v14:NPCID() == (99219 + 39748))) then
				return true;
			elseif ((v14:NPCID() == (167708 - (396 + 343))) or (v14:NPCID() == (14774 + 152197)) or (v14:NPCID() == (168447 - (29 + 1448))) or ((2349 - (135 + 1254)) <= (3299 - 2423))) then
				return true;
			elseif ((v14:NPCID() == (856611 - 673148)) or (v14:NPCID() == (122405 + 61266)) or ((3593 - (389 + 1138)) == (1506 - (102 + 472)))) then
				return true;
			end
		end
		return false;
	end
	local function v116(v174, v175, v176, v177, v178)
		local v179 = 0 + 0;
		local v180;
		local v181;
		local v182;
		while true do
			if (((2676 + 2149) < (4516 + 327)) and (v179 == (1546 - (320 + 1225)))) then
				for v227, v228 in v31(v177) do
					if (((v228:GUID() ~= v182) and v86.UnitIsCycleValid(v228, v181, -v228:DebuffRemains(v174)) and v175(v228)) or ((6901 - 3024) >= (2777 + 1760))) then
						v180, v181 = v228, v228:TimeToDie();
					end
				end
				if (v180 or ((5779 - (157 + 1307)) < (3585 - (821 + 1038)))) then
					v10.Press(v180, v174);
				elseif (v51 or ((9178 - 5499) < (69 + 556))) then
					v180, v181 = nil, v176;
					for v248, v249 in v31(v97) do
						if (((v249:GUID() ~= v182) and v86.UnitIsCycleValid(v249, v181, -v249:DebuffRemains(v174)) and v175(v249)) or ((8214 - 3589) < (236 + 396))) then
							v180, v181 = v249, v249:TimeToDie();
						end
					end
					if (v180 or ((205 - 122) > (2806 - (834 + 192)))) then
						v10.Press(v180, v174);
					end
				end
				break;
			end
			if (((35 + 511) <= (277 + 800)) and (v179 == (0 + 0))) then
				v180, v181 = nil, v176;
				v182 = v14:GUID();
				v179 = 1 - 0;
			end
		end
	end
	local function v117()
		return (324 - (300 + 4)) + (v88.Vigor:TalentRank() * (7 + 18)) + (v29(v88.ThistleTea:IsAvailable()) * (52 - 32)) + (v29(v88.Shadowcraft:IsAvailable()) * (382 - (112 + 250)));
	end
	local function v118()
		return v88.ShadowDance:ChargesFractional() >= (0.75 + 0 + v21(v88.ShadowDanceTalent:IsAvailable()));
	end
	local function v119()
		return v109 >= (7 - 4);
	end
	local function v120()
		return v13:BuffUp(v88.SliceandDice) or (v98 >= v87.CPMaxSpend());
	end
	local function v121()
		return v88.Premeditation:IsAvailable() and (v98 < (3 + 2));
	end
	local function v122(v183)
		return (v13:BuffUp(v88.ThistleTea) and (v98 == (1 + 0))) or (v183 and ((v98 == (1 + 0)) or (v14:DebuffUp(v88.Rupture) and (v98 >= (1 + 1)))));
	end
	local function v123()
		return (not v13:BuffUp(v88.Premeditation) and (v98 == (1 + 0))) or not v88.TheRotten:IsAvailable() or (v98 > (1415 - (1001 + 413)));
	end
	local function v124()
		return v13:BuffDown(v88.PremeditationBuff) or (v98 > (2 - 1)) or ((v108 <= (884 - (244 + 638))) and v13:BuffUp(v88.TheRottenBuff) and not v13:HasTier(723 - (627 + 66), 5 - 3));
	end
	local function v125(v184, v185)
		return v184 and ((v13:BuffStack(v88.DanseMacabreBuff) >= (605 - (512 + 90))) or not v88.DanseMacabre:IsAvailable()) and (not v185 or (v98 ~= (1908 - (1665 + 241))));
	end
	local function v126()
		return (not v13:BuffUp(v88.TheRotten) or not v13:HasTier(747 - (373 + 344), 1 + 1)) and (not v88.ColdBlood:IsAvailable() or (v88.ColdBlood:CooldownRemains() < (2 + 2)) or (v88.ColdBlood:CooldownRemains() > (26 - 16)));
	end
	local function v127(v186)
		return v13:BuffUp(v88.ShadowDanceBuff) and (v186:TimeSinceLastCast() < v88.ShadowDance:TimeSinceLastCast());
	end
	local function v125()
		return ((v127(v88.Shadowstrike) or v127(v88.ShurikenStorm)) and (v127(v88.Eviscerate) or v127(v88.BlackPowder) or v127(v88.Rupture))) or not v88.DanseMacabre:IsAvailable();
	end
	local function v128()
		return (not v89.WitherbarksBranch:IsEquipped() and not v89.AshesoftheEmbersoul:IsEquipped()) or (not v89.WitherbarksBranch:IsEquipped() and (v89.WitherbarksBranch:CooldownRemains() <= (13 - 5))) or (v89.WitherbarksBranch:IsEquipped() and (v89.WitherbarksBranch:CooldownRemains() <= (1107 - (35 + 1064)))) or v89.BandolierOfTwistedBlades:IsEquipped() or v88.InvigoratingShadowdust:IsAvailable();
	end
	local function v129(v187, v188)
		local v189 = 0 + 0;
		local v190;
		local v191;
		local v192;
		local v193;
		local v194;
		local v195;
		local v196;
		while true do
			if ((v189 == (12 - 6)) or ((4 + 992) > (5537 - (298 + 938)))) then
				return false;
			end
			if (((5329 - (233 + 1026)) > (2353 - (636 + 1030))) and ((3 + 2) == v189)) then
				if ((not v122(v190) and v88.Rupture:IsCastable()) or ((641 + 15) >= (990 + 2340))) then
					if ((not v187 and v37 and not v111 and (v98 >= (1 + 1))) or ((2713 - (55 + 166)) <= (65 + 270))) then
						local v239 = 0 + 0;
						local v240;
						while true do
							if (((16505 - 12183) >= (2859 - (36 + 261))) and (v239 == (0 - 0))) then
								v240 = nil;
								function v240(v256)
									return v86.CanDoTUnit(v256, v106) and v256:DebuffRefreshable(v88.Rupture, v105);
								end
								v239 = 1369 - (34 + 1334);
							end
							if ((v239 == (1 + 0)) or ((2826 + 811) >= (5053 - (1035 + 248)))) then
								v116(v88.Rupture, v240, (23 - (20 + 1)) * v193, v99);
								break;
							end
						end
					end
					if ((v94 and (v14:DebuffRemains(v88.Rupture) < (v88.SymbolsofDeath:CooldownRemains() + 6 + 4)) and (v108 > (319 - (134 + 185))) and (v88.SymbolsofDeath:CooldownRemains() <= (1138 - (549 + 584))) and v87.CanDoTUnit(v14, v106) and v14:FilteredTimeToDie(">", (690 - (314 + 371)) + v88.SymbolsofDeath:CooldownRemains(), -v14:DebuffRemains(v88.Rupture))) or ((8166 - 5787) > (5546 - (478 + 490)))) then
						if (v187 or ((256 + 227) > (1915 - (786 + 386)))) then
							return v88.Rupture;
						else
							if (((7948 - 5494) > (1957 - (1055 + 324))) and v88.Rupture:IsReady() and v10.Cast(v88.Rupture)) then
								return "Cast Rupture 2";
							end
							v113(v88.Rupture);
						end
					end
				end
				if (((2270 - (1093 + 247)) < (3962 + 496)) and v88.BlackPowder:IsCastable() and not v111 and (v98 >= (1 + 2))) then
					if (((2628 - 1966) <= (3298 - 2326)) and v187) then
						return v88.BlackPowder;
					else
						local v241 = 0 - 0;
						while true do
							if (((10981 - 6611) == (1555 + 2815)) and ((0 - 0) == v241)) then
								if ((v88.BlackPowder:IsReady() and v26(v88.BlackPowder)) or ((16413 - 11651) <= (650 + 211))) then
									return "Cast Black Powder";
								end
								v113(v88.BlackPowder);
								break;
							end
						end
					end
				end
				if ((v88.Eviscerate:IsCastable() and v94 and (v108 > (2 - 1))) or ((2100 - (364 + 324)) == (11689 - 7425))) then
					if (v187 or ((7601 - 4433) < (714 + 1439))) then
						return v88.Eviscerate;
					else
						local v242 = 0 - 0;
						while true do
							if (((0 - 0) == v242) or ((15112 - 10136) < (2600 - (1249 + 19)))) then
								if (((4178 + 450) == (18014 - 13386)) and v88.Eviscerate:IsReady() and v26(v88.Eviscerate)) then
									return "Cast Eviscerate";
								end
								v113(v88.Eviscerate);
								break;
							end
						end
					end
				end
				v189 = 1092 - (686 + 400);
			end
			if ((v189 == (1 + 0)) or ((283 - (73 + 156)) == (2 + 393))) then
				v193 = v108;
				v194 = v88.ColdBlood:CooldownRemains();
				v195 = v88.SymbolsofDeath:CooldownRemains();
				v189 = 813 - (721 + 90);
			end
			if (((1 + 81) == (266 - 184)) and (v189 == (473 - (224 + 246)))) then
				if ((v88.Rupture:IsCastable() and v88.Rupture:IsReady()) or ((941 - 360) < (518 - 236))) then
					if ((v14:DebuffDown(v88.Rupture) and (v14:TimeToDie() > (2 + 4))) or ((110 + 4499) < (1833 + 662))) then
						if (((2289 - 1137) == (3833 - 2681)) and v187) then
							return v88.Rupture;
						else
							if (((2409 - (203 + 310)) <= (5415 - (1238 + 755))) and v88.Rupture:IsReady() and v10.Press(v88.Rupture)) then
								return "Cast Rupture";
							end
							v113(v88.Rupture);
						end
					end
				end
				if ((not v13:StealthUp(true, true) and not v121() and (v98 < (1 + 5)) and not v190 and v10.BossFilteredFightRemains(">", v13:BuffRemains(v88.SliceandDice)) and (v13:BuffRemains(v88.SliceandDice) < (((1535 - (709 + 825)) + v13:ComboPoints()) * (1.8 - 0)))) or ((1442 - 452) > (2484 - (196 + 668)))) then
					if (v187 or ((3462 - 2585) > (9725 - 5030))) then
						return v88.SliceandDice;
					else
						if (((3524 - (171 + 662)) >= (1944 - (4 + 89))) and v88.SliceandDice:IsReady() and v10.Press(v88.SliceandDice)) then
							return "Cast Slice and Dice Premed";
						end
						v113(v88.SliceandDice);
					end
				end
				if (((not v122(v190) or v111) and (v14:TimeToDie() > (20 - 14)) and v14:DebuffRefreshable(v88.Rupture, v105)) or ((1087 + 1898) >= (21328 - 16472))) then
					if (((1677 + 2599) >= (2681 - (35 + 1451))) and v187) then
						return v88.Rupture;
					else
						if (((4685 - (28 + 1425)) <= (6683 - (941 + 1052))) and v88.Rupture:IsReady() and v10.Press(v88.Rupture)) then
							return "Cast Rupture";
						end
						v113(v88.Rupture);
					end
				end
				v189 = 4 + 0;
			end
			if ((v189 == (1518 - (822 + 692))) or ((1278 - 382) >= (1482 + 1664))) then
				if (((3358 - (45 + 252)) >= (2927 + 31)) and v13:BuffUp(v88.FinalityRuptureBuff) and v190 and (v98 <= (2 + 2)) and not v127(v88.Rupture)) then
					if (((7755 - 4568) >= (1077 - (114 + 319))) and v187) then
						return v88.Rupture;
					else
						local v243 = 0 - 0;
						while true do
							if (((824 - 180) <= (449 + 255)) and ((0 - 0) == v243)) then
								if (((2007 - 1049) > (2910 - (556 + 1407))) and v88.Rupture:IsReady() and v10.Press(v88.Rupture)) then
									return "Cast Rupture Finality";
								end
								v113(v88.Rupture);
								break;
							end
						end
					end
				end
				if (((5698 - (741 + 465)) >= (3119 - (170 + 295))) and v88.ColdBlood:IsReady() and v125(v190, v196) and v88.SecretTechnique:IsReady()) then
					if (((1814 + 1628) >= (1381 + 122)) and v65) then
						v10.Press(v88.ColdBlood);
					else
						if (v187 or ((7804 - 4634) <= (1214 + 250))) then
							return v88.ColdBlood;
						end
						if (v10.Press(v88.ColdBlood) or ((3077 + 1720) == (2485 + 1903))) then
							return "Cast Cold Blood (SecTec)";
						end
					end
				end
				if (((1781 - (957 + 273)) <= (183 + 498)) and v88.SecretTechnique:IsReady()) then
					if (((1312 + 1965) > (1550 - 1143)) and v125(v190, v196) and (not v88.ColdBlood:IsAvailable() or (v65 and v88.ColdBlood:IsReady()) or v13:BuffUp(v88.ColdBlood) or (v194 > (v191 - (5 - 3))) or not v88.ImprovedShadowDance:IsAvailable())) then
						if (((14340 - 9645) >= (7006 - 5591)) and v187) then
							return v88.SecretTechnique;
						end
						if (v10.Press(v88.SecretTechnique) or ((4992 - (389 + 1391)) <= (593 + 351))) then
							return "Cast Secret Technique";
						end
					end
				end
				v189 = 1 + 4;
			end
			if ((v189 == (0 - 0)) or ((4047 - (783 + 168)) <= (6034 - 4236))) then
				v190 = v13:BuffUp(v88.ShadowDanceBuff);
				v191 = v13:BuffRemains(v88.ShadowDanceBuff);
				v192 = v13:BuffRemains(v88.SymbolsofDeath);
				v189 = 1 + 0;
			end
			if (((3848 - (309 + 2)) == (10861 - 7324)) and (v189 == (1214 - (1090 + 122)))) then
				v196 = v13:BuffUp(v88.PremeditationBuff) or (v188 and v88.Premeditation:IsAvailable());
				if (((1244 + 2593) >= (5272 - 3702)) and v188 and (v188:ID() == v88.ShadowDance:ID())) then
					v190 = true;
					v191 = 6 + 2 + v88.ImprovedShadowDance:TalentRank();
					if (v88.TheFirstDance:IsAvailable() or ((4068 - (628 + 490)) == (684 + 3128))) then
						v193 = v33(v13:ComboPointsMax(), v108 + (9 - 5));
					end
					if (((21584 - 16861) >= (3092 - (431 + 343))) and v13:HasTier(60 - 30, 5 - 3)) then
						v192 = v34(v192, 5 + 1);
					end
				end
				if ((v188 and (v188:ID() == v88.Vanish:ID())) or ((260 + 1767) > (4547 - (556 + 1139)))) then
					v194 = v33(15 - (6 + 9), v88.ColdBlood:CooldownRemains() - ((3 + 12) * v88.InvigoratingShadowdust:TalentRank()));
					v195 = v33(0 + 0, v88.SymbolsofDeath:CooldownRemains() - ((184 - (28 + 141)) * v88.InvigoratingShadowdust:TalentRank()));
				end
				v189 = 2 + 1;
			end
		end
	end
	local function v130(v197, v198)
		local v199 = 0 - 0;
		local v200;
		local v201;
		local v202;
		local v203;
		local v204;
		local v205;
		local v206;
		local v207;
		local v208;
		local v209;
		while true do
			if ((v199 == (3 + 1)) or ((2453 - (486 + 831)) > (11233 - 6916))) then
				if (((16715 - 11967) == (898 + 3850)) and (v208 >= v87.CPMaxSpend())) then
					return v129(v197, v198);
				end
				if (((11812 - 8076) <= (6003 - (668 + 595))) and v13:BuffUp(v88.ShurikenTornado) and (v204 <= (2 + 0))) then
					return v129(v197, v198);
				end
				if ((v109 <= (1 + 0 + v29(v88.DeeperStratagem:IsAvailable() or v88.SecretStratagem:IsAvailable()))) or ((9244 - 5854) <= (3350 - (23 + 267)))) then
					return v129(v197, v198);
				end
				v199 = 1949 - (1129 + 815);
			end
			if ((v199 == (393 - (371 + 16))) or ((2749 - (1326 + 424)) > (5099 - 2406))) then
				if (((1691 - 1228) < (719 - (88 + 30))) and not v205 and (v98 >= (775 - (720 + 51)))) then
					if (v197 or ((4855 - 2672) < (2463 - (421 + 1355)))) then
						return v88.ShurikenStorm;
					elseif (((7504 - 2955) == (2235 + 2314)) and v26(v88.ShurikenStorm)) then
						return "Cast Shuriken Storm";
					end
				end
				if (((5755 - (286 + 797)) == (17079 - 12407)) and v209) then
					if (v197 or ((6075 - 2407) < (834 - (397 + 42)))) then
						return v88.Shadowstrike;
					elseif (v26(v88.Shadowstrike) or ((1302 + 2864) == (1255 - (24 + 776)))) then
						return "Cast Shadowstrike";
					end
				end
				return false;
			end
			if ((v199 == (4 - 1)) or ((5234 - (222 + 563)) == (5867 - 3204))) then
				v209 = v88.Shadowstrike:IsCastable() or v206 or v207 or v200 or v13:BuffUp(v88.SepsisBuff);
				if (v206 or v207 or ((3080 + 1197) < (3179 - (23 + 167)))) then
					v209 = v209 and v14:IsInRange(1823 - (690 + 1108));
				else
					v209 = v209 and v94;
				end
				if ((v209 and v206 and ((v98 < (2 + 2)) or v111)) or ((718 + 152) >= (4997 - (40 + 808)))) then
					if (((365 + 1847) < (12171 - 8988)) and v197) then
						return v88.Shadowstrike;
					elseif (((4441 + 205) > (1583 + 1409)) and v26(v88.Shadowstrike)) then
						return "Cast Shadowstrike (Stealth)";
					end
				end
				v199 = 3 + 1;
			end
			if (((2005 - (47 + 524)) < (2016 + 1090)) and (v199 == (0 - 0))) then
				v200 = v13:BuffUp(v88.ShadowDanceBuff);
				v201 = v13:BuffRemains(v88.ShadowDanceBuff);
				v202 = v13:BuffUp(v88.TheRottenBuff);
				v199 = 1 - 0;
			end
			if (((1792 - 1006) < (4749 - (1165 + 561))) and (v199 == (1 + 4))) then
				if ((v88.Backstab:IsCastable() and not v205 and (v201 >= (9 - 6)) and v13:BuffUp(v88.ShadowBlades) and not v127(v88.Backstab) and v88.DanseMacabre:IsAvailable() and (v98 <= (2 + 1)) and not v202) or ((2921 - (341 + 138)) < (20 + 54))) then
					if (((9359 - 4824) == (4861 - (89 + 237))) and v197) then
						if (v198 or ((9679 - 6670) <= (4431 - 2326))) then
							return v88.Backstab;
						else
							return {v88.Backstab,v88.Stealth};
						end
					elseif (((4346 - 2516) < (1198 + 2471)) and v26(v88.Backstab, v88.Stealth)) then
						return "Cast Backstab (Stealth)";
					end
				end
				if (v88.Gloomblade:IsAvailable() or ((2665 - (1030 + 205)) >= (3391 + 221))) then
					if (((2496 + 187) >= (2746 - (156 + 130))) and not v205 and (v201 >= (6 - 3)) and v13:BuffUp(v88.ShadowBlades) and not v127(v88.Gloomblade) and v88.DanseMacabre:IsAvailable() and (v98 <= (6 - 2))) then
						if (v197 or ((3694 - 1890) >= (863 + 2412))) then
							if (v198 or ((827 + 590) > (3698 - (10 + 59)))) then
								return v88.Gloomblade;
							else
								return {v88.Gloomblade,v88.Stealth};
							end
						elseif (((5958 - (671 + 492)) > (321 + 81)) and v27(v88.Gloomblade, v88.Stealth)) then
							return "Cast Gloomblade (Danse)";
						end
					end
				end
				if (((6028 - (369 + 846)) > (944 + 2621)) and not v127(v88.Shadowstrike) and v13:BuffUp(v88.ShadowBlades)) then
					if (((3339 + 573) == (5857 - (1036 + 909))) and v197) then
						return v88.Shadowstrike;
					elseif (((2243 + 578) <= (8098 - 3274)) and v26(v88.Shadowstrike)) then
						return "Cast Shadowstrike (Danse)";
					end
				end
				v199 = 209 - (11 + 192);
			end
			if (((879 + 859) <= (2370 - (135 + 40))) and (v199 == (2 - 1))) then
				v203, v204 = v108, v109;
				v205 = v13:BuffUp(v88.PremeditationBuff) or (v198 and v88.Premeditation:IsAvailable());
				v206 = v13:BuffUp(v87.StealthSpell()) or (v198 and (v198:ID() == v87.StealthSpell():ID()));
				v199 = 2 + 0;
			end
			if (((90 - 49) <= (4524 - 1506)) and (v199 == (178 - (50 + 126)))) then
				v207 = v13:BuffUp(v87.VanishBuffSpell()) or (v198 and (v198:ID() == v88.Vanish:ID()));
				if (((5972 - 3827) <= (909 + 3195)) and v198 and (v198:ID() == v88.ShadowDance:ID())) then
					local v230 = 1413 - (1233 + 180);
					while true do
						if (((3658 - (522 + 447)) < (6266 - (107 + 1314))) and (v230 == (1 + 0))) then
							if ((v88.TheRotten:IsAvailable() and v13:HasTier(91 - 61, 1 + 1)) or ((4610 - 2288) > (10374 - 7752))) then
								v202 = true;
							end
							if (v88.TheFirstDance:IsAvailable() or ((6444 - (716 + 1194)) == (36 + 2046))) then
								local v251 = 0 + 0;
								while true do
									if (((503 - (74 + 429)) == v251) or ((3030 - 1459) > (926 + 941))) then
										v203 = v33(v13:ComboPointsMax(), v108 + (8 - 4));
										v204 = v13:ComboPointsMax() - v203;
										break;
									end
								end
							end
							break;
						end
						if ((v230 == (0 + 0)) or ((8182 - 5528) >= (7407 - 4411))) then
							v200 = true;
							v201 = (441 - (279 + 154)) + v88.ImprovedShadowDance:TalentRank();
							v230 = 779 - (454 + 324);
						end
					end
				end
				v208 = v87.EffectiveComboPoints(v203);
				v199 = 3 + 0;
			end
		end
	end
	local function v131(v210, v211)
		local v212 = 17 - (12 + 5);
		local v213;
		local v214;
		while true do
			if (((2145 + 1833) > (5360 - 3256)) and (v212 == (1 + 1))) then
				v101 = v27(unpack(v214));
				if (((4088 - (277 + 816)) > (6584 - 5043)) and v101) then
					return "| " .. v214[1185 - (1058 + 125)]:Name();
				end
				v212 = 1 + 2;
			end
			if (((4224 - (815 + 160)) > (4088 - 3135)) and (v212 == (2 - 1))) then
				v214 = {v210,v213};
				if ((v211 and (v13:EnergyPredicted() < v211)) or ((5171 - (41 + 1857)) > (6466 - (1222 + 671)))) then
					v112(v214, v211);
					return false;
				end
				v212 = 5 - 3;
			end
			if (((0 - 0) == v212) or ((4333 - (229 + 953)) < (3058 - (1111 + 663)))) then
				v213 = v130(true, v210);
				if ((v210:ID() == v88.Vanish:ID()) or ((3429 - (874 + 705)) == (215 + 1314))) then
					local v231 = 0 + 0;
					while true do
						if (((1706 - 885) < (60 + 2063)) and (v231 == (679 - (642 + 37)))) then
							if (((206 + 696) < (372 + 1953)) and v26(v88.Vanish, v62)) then
								return "Cast Vanish";
							end
							return false;
						end
					end
				elseif (((2153 - 1295) <= (3416 - (233 + 221))) and (v210:ID() == v88.Shadowmeld:ID())) then
					local v244 = 0 - 0;
					while true do
						if (((0 + 0) == v244) or ((5487 - (718 + 823)) < (811 + 477))) then
							if (v26(v88.Shadowmeld, v39) or ((4047 - (266 + 539)) == (1605 - 1038))) then
								return "Cast Shadowmeld";
							end
							return false;
						end
					end
				elseif ((v210:ID() == v88.ShadowDance:ID()) or ((2072 - (636 + 589)) >= (2997 - 1734))) then
					local v250 = 0 - 0;
					while true do
						if ((v250 == (0 + 0)) or ((819 + 1434) == (2866 - (657 + 358)))) then
							if (v26(v88.ShadowDance, v63) or ((5525 - 3438) > (5403 - 3031))) then
								return "Cast Shadow Dance";
							end
							return false;
						end
					end
				end
				v212 = 1188 - (1151 + 36);
			end
			if ((v212 == (3 + 0)) or ((1169 + 3276) < (12390 - 8241))) then
				return false;
			end
		end
	end
	local function v132()
		v101 = v86.HandleTopTrinket(v91, v38, 1872 - (1552 + 280), nil);
		if (v101 or ((2652 - (64 + 770)) == (58 + 27))) then
			return v101;
		end
		v101 = v86.HandleBottomTrinket(v91, v38, 90 - 50, nil);
		if (((112 + 518) < (3370 - (157 + 1086))) and v101) then
			return v101;
		end
	end
	local function v133()
		if ((v10.CD and v88.ColdBlood:IsReady() and not v88.SecretTechnique:IsAvailable() and (v108 >= (10 - 5))) or ((8487 - 6549) == (3856 - 1342))) then
			if (((5807 - 1552) >= (874 - (599 + 220))) and v26(v88.ColdBlood, v65)) then
				return "Cast Cold Blood";
			end
		end
		if (((5971 - 2972) > (3087 - (1813 + 118))) and v10.CD and v88.Sepsis:IsAvailable() and v88.Sepsis:IsReady()) then
			if (((1718 + 632) > (2372 - (841 + 376))) and v120() and v14:FilteredTimeToDie(">=", 21 - 5) and (v13:BuffUp(v88.PerforatedVeins) or not v88.PerforatedVeins:IsAvailable())) then
				if (((936 + 3093) <= (13246 - 8393)) and v26(v88.Sepsis)) then
					return "Cast Sepsis";
				end
			end
		end
		if ((v38 and v88.Flagellation:IsAvailable() and v88.Flagellation:IsReady()) or ((1375 - (464 + 395)) > (8812 - 5378))) then
			if (((1944 + 2102) >= (3870 - (467 + 370))) and v120() and (v107 >= (9 - 4)) and (v14:TimeToDie() > (8 + 2)) and ((v128() and (v88.ShadowBlades:CooldownRemains() <= (10 - 7))) or v10.BossFilteredFightRemains("<=", 5 + 23) or ((v88.ShadowBlades:CooldownRemains() >= (32 - 18)) and v88.InvigoratingShadowdust:IsAvailable() and v88.ShadowDance:IsAvailable())) and (not v88.InvigoratingShadowdust:IsAvailable() or v88.Sepsis:IsAvailable() or not v88.ShadowDance:IsAvailable() or ((v88.InvigoratingShadowdust:TalentRank() == (522 - (150 + 370))) and (v98 >= (1284 - (74 + 1208)))) or (v88.SymbolsofDeath:CooldownRemains() <= (7 - 4)) or (v13:BuffRemains(v88.SymbolsofDeath) > (14 - 11)))) then
				if (v26(v88.Flagellation) or ((1935 + 784) <= (1837 - (14 + 376)))) then
					return "Cast Flagellation";
				end
			end
		end
		if ((v38 and v88.SymbolsofDeath:IsReady()) or ((7169 - 3035) < (2541 + 1385))) then
			if ((v120() and (not v13:BuffUp(v88.TheRotten) or not v13:HasTier(27 + 3, 2 + 0)) and (v13:BuffRemains(v88.SymbolsofDeath) <= (8 - 5)) and (not v88.Flagellation:IsAvailable() or (v88.Flagellation:CooldownRemains() > (8 + 2)) or ((v13:BuffRemains(v88.ShadowDance) >= (80 - (23 + 55))) and v88.InvigoratingShadowdust:IsAvailable()) or (v88.Flagellation:IsReady() and (v107 >= (11 - 6)) and not v88.InvigoratingShadowdust:IsAvailable()))) or ((110 + 54) >= (2501 + 284))) then
				if (v26(v88.SymbolsofDeath) or ((814 - 289) == (664 + 1445))) then
					return "Cast Symbols of Death";
				end
			end
		end
		if (((934 - (652 + 249)) == (88 - 55)) and v10.CD and v88.ShadowBlades:IsReady()) then
			if (((4922 - (708 + 1160)) <= (10898 - 6883)) and v120() and ((v107 <= (1 - 0)) or v13:HasTier(58 - (10 + 17), 1 + 3)) and (v13:BuffUp(v88.Flagellation) or v13:BuffUp(v88.FlagellationPersistBuff) or not v88.Flagellation:IsAvailable())) then
				if (((3603 - (1400 + 332)) < (6486 - 3104)) and v26(v88.ShadowBlades)) then
					return "Cast Shadow Blades";
				end
			end
		end
		if (((3201 - (242 + 1666)) <= (927 + 1239)) and v10.CD and v88.EchoingReprimand:IsCastable() and v88.EchoingReprimand:IsAvailable()) then
			if ((v120() and (v109 >= (2 + 1))) or ((2198 + 381) < (1063 - (850 + 90)))) then
				if (v26(v88.EchoingReprimand) or ((1481 - 635) >= (3758 - (360 + 1030)))) then
					return "Cast Echoing Reprimand";
				end
			end
		end
		if ((v10.CD and v88.ShurikenTornado:IsAvailable() and v88.ShurikenTornado:IsReady()) or ((3551 + 461) <= (9477 - 6119))) then
			if (((2055 - 561) <= (4666 - (909 + 752))) and v120() and v13:BuffUp(v88.SymbolsofDeath) and (v107 <= (1225 - (109 + 1114))) and not v13:BuffUp(v88.Premeditation) and (not v88.Flagellation:IsAvailable() or (v88.Flagellation:CooldownRemains() > (36 - 16))) and (v98 >= (2 + 1))) then
				if (v26(v88.ShurikenTornado) or ((3353 - (6 + 236)) == (1345 + 789))) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if (((1896 + 459) == (5554 - 3199)) and v10.CD and v88.ShurikenTornado:IsAvailable() and v88.ShurikenTornado:IsReady()) then
			if ((v120() and not v13:BuffUp(v88.ShadowDance) and not v13:BuffUp(v88.Flagellation) and not v13:BuffUp(v88.FlagellationPersistBuff) and not v13:BuffUp(v88.ShadowBlades) and (v98 <= (3 - 1))) or ((1721 - (1076 + 57)) <= (72 + 360))) then
				if (((5486 - (579 + 110)) >= (308 + 3587)) and v26(v88.ShurikenTornado)) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if (((3163 + 414) == (1899 + 1678)) and v10.CD and v88.ShadowDance:IsAvailable() and v114() and v88.ShadowDance:IsReady()) then
			if (((4201 - (174 + 233)) > (10315 - 6622)) and not v13:BuffUp(v88.ShadowDance) and HL.BossFilteredFightRemains("<=", (13 - 5) + ((2 + 1) * v29(v88.Subterfuge:IsAvailable())))) then
				if (v26(v88.ShadowDance) or ((2449 - (663 + 511)) == (3658 + 442))) then
					return "Cast Shadow Dance";
				end
			end
		end
		if ((v10.CD and v88.GoremawsBite:IsAvailable() and v88.GoremawsBite:IsReady()) or ((346 + 1245) >= (11037 - 7457))) then
			if (((596 + 387) <= (4256 - 2448)) and v120() and (v109 >= (7 - 4)) and (not v88.ShadowDance:IsReady() or (v88.ShadowDance:IsAvailable() and v13:BuffUp(v88.ShadowDance) and not v88.InvigoratingShadowdust:IsAvailable()) or ((v98 < (2 + 2)) and not v88.InvigoratingShadowdust:IsAvailable()) or v88.TheRotten:IsAvailable())) then
				if (v26(v88.GoremawsBite) or ((4184 - 2034) <= (854 + 343))) then
					return "Cast Goremaw's Bite";
				end
			end
		end
		if (((345 + 3424) >= (1895 - (478 + 244))) and v88.ThistleTea:IsReady()) then
			if (((2002 - (440 + 77)) == (676 + 809)) and ((((v88.SymbolsofDeath:CooldownRemains() >= (10 - 7)) or v13:BuffUp(v88.SymbolsofDeath)) and not v13:BuffUp(v88.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (1656 - (655 + 901))) and ((v109 >= (1 + 1)) or (v98 >= (3 + 0)))) or ((v88.ThistleTea:ChargesFractional() >= ((2.75 + 0) - ((0.15 - 0) * v88.InvigoratingShadowdust:TalentRank()))) and v88.Vanish:IsReady() and v13:BuffUp(v88.ShadowDance) and v14:DebuffUp(v88.Rupture) and (v98 < (1448 - (695 + 750)))))) or ((v13:BuffRemains(v88.ShadowDance) >= (13 - 9)) and not v13:BuffUp(v88.ThistleTea) and (v98 >= (3 - 0))) or (not v13:BuffUp(v88.ThistleTea) and HL.BossFilteredFightRemains("<=", (24 - 18) * v88.ThistleTea:Charges())))) then
				if (v26(v88.ThistleTea) or ((3666 - (285 + 66)) <= (6484 - 3702))) then
					return "Thistle Tea";
				end
			end
		end
		local v215 = v13:BuffUp(v88.ShadowBlades) or (not v88.ShadowBlades:IsAvailable() and v13:BuffUp(v88.SymbolsofDeath)) or HL.BossFilteredFightRemains("<", 1330 - (682 + 628));
		if ((v88.BloodFury:IsCastable() and v215) or ((142 + 734) >= (3263 - (176 + 123)))) then
			if (v26(v88.BloodFury, v61) or ((934 + 1298) > (1812 + 685))) then
				return "Cast Blood Fury";
			end
		end
		if (v88.Berserking:IsCastable() or ((2379 - (239 + 30)) <= (91 + 241))) then
			if (((3543 + 143) > (5613 - 2441)) and v10.Cast(v88.Berserking, v61)) then
				return "Cast Berserking";
			end
		end
		if (v88.Fireblood:IsCastable() or ((13958 - 9484) < (1135 - (306 + 9)))) then
			if (((14931 - 10652) >= (502 + 2380)) and v10.Cast(v88.Fireblood, v61)) then
				return "Cast Fireblood";
			end
		end
		if (v88.AncestralCall:IsCastable() or ((1245 + 784) >= (1695 + 1826))) then
			if (v10.Cast(v88.AncestralCall, v61) or ((5824 - 3787) >= (6017 - (1140 + 235)))) then
				return "Cast Ancestral Call";
			end
		end
		if (((1095 + 625) < (4089 + 369)) and v53 and v38) then
			v101 = v132();
			if (v101 or ((112 + 324) > (3073 - (33 + 19)))) then
				return v101;
			end
		end
		return false;
	end
	local function v134(v216)
		if (((258 + 455) <= (2538 - 1691)) and v10.CD and not (v86.IsSoloMode() and v13:IsTanking(v14))) then
			if (((949 + 1205) <= (7904 - 3873)) and v88.Vanish:IsCastable()) then
				if (((4328 + 287) == (5304 - (586 + 103))) and ((v109 > (1 + 0)) or (v13:BuffUp(v88.ShadowBlades) and v88.InvigoratingShadowdust:IsAvailable())) and not v118() and ((v88.Flagellation:CooldownRemains() >= (184 - 124)) or not v88.Flagellation:IsAvailable() or v10.BossFilteredFightRemains("<=", (1518 - (1309 + 179)) * v88.Vanish:Charges())) and ((v88.SymbolsofDeath:CooldownRemains() > (5 - 2)) or not v13:HasTier(14 + 16, 5 - 3)) and ((v88.SecretTechnique:CooldownRemains() >= (8 + 2)) or not v88.SecretTechnique:IsAvailable() or ((v88.Vanish:Charges() >= (3 - 1)) and v88.InvigoratingShadowdust:IsAvailable() and (v13:BuffUp(v88.TheRotten) or not v88.TheRotten:IsAvailable())))) then
					v101 = v131(v88.Vanish, v216);
					if (v101 or ((7552 - 3762) == (1109 - (295 + 314)))) then
						return "Vanish Macro " .. v101;
					end
				end
			end
			if (((218 - 129) < (2183 - (1300 + 662))) and (v13:Energy() < (125 - 85)) and v88.Shadowmeld:IsCastable()) then
				if (((3809 - (1178 + 577)) >= (738 + 683)) and v26(v88.Shadowmeld, v13:EnergyTimeToX(118 - 78))) then
					return "Pool for Shadowmeld";
				end
			end
			if (((2097 - (851 + 554)) < (2705 + 353)) and v88.Shadowmeld:IsCastable() and v94 and not v13:IsMoving() and (v13:EnergyPredicted() >= (110 - 70)) and (v13:EnergyDeficitPredicted() >= (21 - 11)) and not v118() and (v109 > (306 - (115 + 187)))) then
				local v229 = 0 + 0;
				while true do
					if ((v229 == (0 + 0)) or ((12822 - 9568) == (2816 - (160 + 1001)))) then
						v101 = v131(v88.Shadowmeld, v216);
						if (v101 or ((1134 + 162) == (3388 + 1522))) then
							return "Shadowmeld Macro " .. v101;
						end
						break;
					end
				end
			end
		end
		if (((6894 - 3526) == (3726 - (237 + 121))) and v94 and v88.ShadowDance:IsCastable()) then
			if (((3540 - (525 + 372)) < (7232 - 3417)) and (v14:DebuffUp(v88.Rupture) or v88.InvigoratingShadowdust:IsAvailable()) and v126() and (not v88.TheFirstDance:IsAvailable() or (v109 >= (12 - 8)) or v13:BuffUp(v88.ShadowBlades)) and ((v119() and v118()) or ((v13:BuffUp(v88.ShadowBlades) or (v13:BuffUp(v88.SymbolsofDeath) and not v88.Sepsis:IsAvailable()) or ((v13:BuffRemains(v88.SymbolsofDeath) >= (146 - (96 + 46))) and not v13:HasTier(807 - (643 + 134), 1 + 1)) or (not v13:BuffUp(v88.SymbolsofDeath) and v13:HasTier(71 - 41, 7 - 5))) and (v88.SecretTechnique:CooldownRemains() < (10 + 0 + ((23 - 11) * v29(not v88.InvigoratingShadowdust:IsAvailable() or v13:HasTier(61 - 31, 721 - (316 + 403))))))))) then
				v101 = v131(v88.ShadowDance, v216);
				if (((1272 + 641) > (1355 - 862)) and v101) then
					return "ShadowDance Macro 1 " .. v101;
				end
			end
		end
		return false;
	end
	local function v135(v217)
		local v218 = 0 + 0;
		local v219;
		while true do
			if (((11974 - 7219) > (2430 + 998)) and (v218 == (1 + 0))) then
				if (((4784 - 3403) <= (11313 - 8944)) and v94) then
					if (v88.Gloomblade:IsCastable() or ((10060 - 5217) == (234 + 3850))) then
						local v245 = 0 - 0;
						while true do
							if (((229 + 4440) > (1067 - 704)) and (v245 == (17 - (12 + 5)))) then
								if ((v219 and v26(v88.Gloomblade)) or ((7290 - 5413) >= (6695 - 3557))) then
									return "Cast Gloomblade";
								end
								v112(v88.Gloomblade, v217);
								break;
							end
						end
					elseif (((10079 - 5337) >= (8991 - 5365)) and v88.Backstab:IsCastable()) then
						if ((v219 and v26(v88.Backstab)) or ((922 + 3618) == (2889 - (1656 + 317)))) then
							return "Cast Backstab";
						end
						v112(v88.Backstab, v217);
					end
				end
				return false;
			end
			if ((v218 == (0 + 0)) or ((927 + 229) > (11553 - 7208))) then
				v219 = not v217 or (v13:EnergyPredicted() >= v217);
				if (((11009 - 8772) < (4603 - (5 + 349))) and v37 and v88.ShurikenStorm:IsCastable() and (v98 >= ((9 - 7) + v21((v88.Gloomblade:IsAvailable() and (v13:BuffRemains(v88.LingeringShadowBuff) >= (1277 - (266 + 1005)))) or v13:BuffUp(v88.PerforatedVeinsBuff))))) then
					local v232 = 0 + 0;
					while true do
						if ((v232 == (0 - 0)) or ((3531 - 848) < (1719 - (561 + 1135)))) then
							if (((908 - 211) <= (2715 - 1889)) and v219 and v10.Cast(v88.ShurikenStorm)) then
								return "Cast Shuriken Storm";
							end
							v112(v88.ShurikenStorm, v217);
							break;
						end
					end
				end
				v218 = 1067 - (507 + 559);
			end
		end
	end
	local function v136()
		local v220 = 0 - 0;
		while true do
			if (((3417 - 2312) <= (1564 - (212 + 176))) and (v220 == (913 - (250 + 655)))) then
				v101 = v87.CrimsonVial();
				if (((9214 - 5835) <= (6660 - 2848)) and v101) then
					return v101;
				end
				v87.Poisons();
				v220 = 13 - 4;
			end
			if ((v220 == (1958 - (1869 + 87))) or ((2733 - 1945) >= (3517 - (484 + 1417)))) then
				v104 = nil;
				v103 = 0 - 0;
				v92 = (v88.AcrobaticStrikes:IsAvailable() and (13 - 5)) or (778 - (48 + 725));
				v220 = 4 - 1;
			end
			if (((4974 - 3120) <= (1964 + 1415)) and (v220 == (18 - 11))) then
				v106 = v88.Eviscerate:Damage() * v29(v74);
				if (((1274 + 3275) == (1326 + 3223)) and v89.Healthstone:IsReady() and (v13:HealthPercentage() < v44) and not (v13:IsChanneling() or v13:IsCasting())) then
					if (v10.Cast(v90.Healthstone) or ((3875 - (152 + 701)) >= (4335 - (430 + 881)))) then
						return "Healthstone ";
					end
				end
				if (((1846 + 2974) > (3093 - (557 + 338))) and v89.RefreshingHealingPotion:IsReady() and (v13:HealthPercentage() < v42) and not (v13:IsChanneling() or v13:IsCasting())) then
					if (v10.Cast(v90.RefreshingHealingPotion) or ((314 + 747) >= (13782 - 8891))) then
						return "RefreshingHealingPotion ";
					end
				end
				v220 = 27 - 19;
			end
			if (((3623 - 2259) <= (9639 - 5166)) and (v220 == (802 - (499 + 302)))) then
				v38 = EpicSettings.Toggles['cds'];
				ToggleMain = EpicSettings.Toggles['toggle'];
				v102 = nil;
				v220 = 868 - (39 + 827);
			end
			if ((v220 == (0 - 0)) or ((8029 - 4434) <= (11 - 8))) then
				v85();
				v36 = EpicSettings.Toggles['ooc'];
				v37 = EpicSettings.Toggles['aoe'];
				v220 = 1 - 0;
			end
			if ((v220 == (1 + 8)) or ((13674 - 9002) == (617 + 3235))) then
				if (((2466 - 907) == (1663 - (103 + 1))) and not v13:AffectingCombat()) then
					local v233 = 554 - (475 + 79);
					while true do
						if ((v233 == (2 - 1)) or ((5606 - 3854) <= (102 + 686))) then
							if (v86.TargetIsValid() or ((3439 + 468) == (1680 - (1395 + 108)))) then
								if (((10097 - 6627) > (1759 - (7 + 1197))) and v15:Exists() and v88.TricksoftheTrade:IsReady()) then
									if (v26(v90.TricksoftheTradeFocus) or ((424 + 548) == (226 + 419))) then
										return "precombat tricks_of_the_trade";
									end
								end
							end
							break;
						end
						if (((3501 - (27 + 292)) >= (6197 - 4082)) and (v233 == (0 - 0))) then
							v101 = v87.Poisons();
							if (((16326 - 12433) < (8733 - 4304)) and v101) then
								return v101;
							end
							v233 = 1 - 0;
						end
					end
				end
				if ((not v13:AffectingCombat() and not v13:IsMounted() and v86.TargetIsValid()) or ((3006 - (43 + 96)) < (7770 - 5865))) then
					v101 = v87.Stealth(v88.Stealth2, nil);
					if (v101 or ((4060 - 2264) >= (3362 + 689))) then
						return "Stealth (OOC): " .. v101;
					end
				end
				if (((458 + 1161) <= (7423 - 3667)) and not v13:IsChanneling() and ToggleMain) then
					local v234 = 0 + 0;
					while true do
						if (((1131 - 527) == (191 + 413)) and (v234 == (0 + 0))) then
							if ((not v13:AffectingCombat() and v14:AffectingCombat() and (v88.Vanish:TimeSinceLastCast() > (1752 - (1414 + 337)))) or ((6424 - (1642 + 298)) == (2346 - 1446))) then
								local v252 = 0 - 0;
								while true do
									if ((v252 == (0 - 0)) or ((1468 + 2991) <= (866 + 247))) then
										if (((4604 - (357 + 615)) > (2386 + 1012)) and v86.TargetIsValid() and (v14:IsSpellInRange(v88.Shadowstrike) or v94)) then
											if (((10015 - 5933) <= (4214 + 703)) and v13:StealthUp(true, true)) then
												v102 = v130(true);
												if (((10355 - 5523) >= (1109 + 277)) and v102) then
													if (((10 + 127) == (87 + 50)) and (type(v102) == "table") and (#v102 > (1302 - (384 + 917)))) then
														if (v26(nil, unpack(v102)) or ((2267 - (128 + 569)) >= (5875 - (1407 + 136)))) then
															return "Stealthed Macro Cast or Pool (OOC): " .. v102[1888 - (687 + 1200)]:Name();
														end
													elseif (v26(v102) or ((5774 - (556 + 1154)) <= (6399 - 4580))) then
														return "Stealthed Cast or Pool (OOC): " .. v102:Name();
													end
												end
											elseif ((v108 >= (100 - (9 + 86))) or ((5407 - (275 + 146)) < (256 + 1318))) then
												v101 = v129();
												if (((4490 - (29 + 35)) > (762 - 590)) and v101) then
													return v101 .. " (OOC)";
												end
											end
										end
										return;
									end
								end
							end
							if (((1750 - 1164) > (2008 - 1553)) and v86.TargetIsValid() and (v36 or v13:AffectingCombat())) then
								local v253 = 0 + 0;
								local v254;
								while true do
									if (((1838 - (53 + 959)) == (1234 - (312 + 96))) and (v253 == (1 - 0))) then
										if (v101 or ((4304 - (147 + 138)) > (5340 - (813 + 86)))) then
											return "CDs: " .. v101;
										end
										if (((1823 + 194) < (7894 - 3633)) and v88.SliceandDice:IsCastable() and (v98 < v87.CPMaxSpend()) and (v13:BuffRemains(v88.SliceandDice) < v13:GCD()) and v10.BossFilteredFightRemains(">", 498 - (18 + 474)) and (v108 >= (2 + 2))) then
											local v257 = 0 - 0;
											while true do
												if (((5802 - (860 + 226)) > (383 - (121 + 182))) and (v257 == (0 + 0))) then
													if ((v88.SliceandDice:IsReady() and v26(v88.SliceandDice)) or ((4747 - (988 + 252)) == (370 + 2902))) then
														return "Cast Slice and Dice (Low Duration)";
													end
													v113(v88.SliceandDice);
													break;
												end
											end
										end
										if (v13:StealthUp(true, true) or ((275 + 601) >= (5045 - (49 + 1921)))) then
											local v258 = 890 - (223 + 667);
											while true do
												if (((4404 - (51 + 1)) > (4395 - 1841)) and (v258 == (0 - 0))) then
													v102 = v130(true);
													if (v102 or ((5531 - (146 + 979)) < (1142 + 2901))) then
														if (((type(v102) == "table") and (#v102 > (606 - (311 + 294)))) or ((5267 - 3378) >= (1433 + 1950))) then
															if (((3335 - (496 + 947)) <= (4092 - (1233 + 125))) and v28(nil, unpack(v102))) then
																return "Stealthed Macro " .. v102[1 + 0]:Name() .. "|" .. v102[2 + 0]:Name();
															end
														elseif (((366 + 1557) < (3863 - (963 + 682))) and v13:BuffUp(v88.ShurikenTornado) and (v108 ~= v13:ComboPoints()) and ((v102 == v88.BlackPowder) or (v102 == v88.Eviscerate) or (v102 == v88.Rupture) or (v102 == v88.SliceandDice))) then
															if (((1814 + 359) > (1883 - (504 + 1000))) and v28(nil, v88.ShurikenTornado, v102)) then
																return "Stealthed Tornado Cast  " .. v102:Name();
															end
														elseif (v26(v102) or ((1745 + 846) == (3105 + 304))) then
															return "Stealthed Cast " .. v102:Name();
														end
													end
													v258 = 1 + 0;
												end
												if (((6655 - 2141) > (2840 + 484)) and (v258 == (1 + 0))) then
													v26(v88.PoolEnergy);
													return "Stealthed Pooling";
												end
											end
										end
										v253 = 184 - (156 + 26);
									end
									if ((v253 == (0 + 0)) or ((325 - 117) >= (4992 - (149 + 15)))) then
										if ((v84 and v88.Shiv:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v86.UnitHasEnrageBuff(v14)) or ((2543 - (890 + 70)) > (3684 - (39 + 78)))) then
											if (v26(v88.Shiv, not v94) or ((1795 - (14 + 468)) == (1745 - 951))) then
												return "dispel";
											end
										end
										if (((8871 - 5697) > (1498 + 1404)) and (v10.CombatTime() < (7 + 3)) and (v10.CombatTime() > (0 + 0)) and v88.ShadowDance:CooldownUp() and (v88.Vanish:TimeSinceLastCast() > (5 + 6))) then
											if (((1080 + 3040) <= (8154 - 3894)) and v13:StealthUp(true, true)) then
												if (v10.Cast(v88.Shadowstrike) or ((873 + 10) > (16789 - 12011))) then
													return "Opener SS";
												end
											end
											if ((v88.SymbolsofDeath:IsCastable() and v13:BuffDown(v88.SymbolsofDeath)) or ((92 + 3528) >= (4942 - (12 + 39)))) then
												if (((3962 + 296) > (2900 - 1963)) and v10.Cast(v88.SymbolsofDeath, true)) then
													return "Opener SymbolsofDeath";
												end
											end
											if ((v88.ShadowBlades:IsCastable() and v13:BuffDown(v88.ShadowBlades)) or ((17341 - 12472) < (269 + 637))) then
												if (v10.Cast(v88.ShadowBlades, true) or ((645 + 580) > (10721 - 6493))) then
													return "Opener ShadowBlades";
												end
											end
											if (((2217 + 1111) > (10815 - 8577)) and v88.ShurikenStorm:IsCastable() and (v98 >= (1712 - (1596 + 114)))) then
												if (((10022 - 6183) > (2118 - (164 + 549))) and v10.Cast(v88.ShurikenStorm)) then
													return "Opener Shuriken Tornado";
												end
											end
											if (((v88.Gloomblade:TimeSinceLastCast() > (1441 - (1059 + 379))) and (v98 <= (1 - 0))) or ((671 + 622) <= (86 + 421))) then
												if (v10.Cast(v88.Gloomblade) or ((3288 - (145 + 247)) < (661 + 144))) then
													return "Opener Gloomblade";
												end
											end
											if (((1071 + 1245) == (6865 - 4549)) and v14:DebuffDown(v88.Rupture) and (v98 <= (1 + 0)) and (v108 > (0 + 0))) then
												if (v10.Cast(v88.Rupture) or ((4173 - 1603) == (2253 - (254 + 466)))) then
													return "Opener Rupture";
												end
											end
											if ((v88.ShadowDance:IsCastable() and v38 and v10.Cast(v90.ShadowDance, true)) or ((1443 - (544 + 16)) == (4640 - 3180))) then
												return "Opener ShadowDance";
											end
										end
										v101 = v133();
										v253 = 629 - (294 + 334);
									end
									if ((v253 == (255 - (236 + 17))) or ((1992 + 2627) <= (778 + 221))) then
										v254 = nil;
										if (not v88.Vigor:IsAvailable() or v88.Shadowcraft:IsAvailable() or ((12842 - 9432) > (19487 - 15371))) then
											v254 = v13:EnergyDeficitPredicted() <= v117();
										else
											v254 = v13:EnergyPredicted() >= v117();
										end
										if (v254 or v88.InvigoratingShadowdust:IsAvailable() or ((465 + 438) >= (2520 + 539))) then
											v101 = v134(v110);
											if (v101 or ((4770 - (413 + 381)) < (121 + 2736))) then
												return "Stealth CDs: " .. v101;
											end
										end
										v253 = 5 - 2;
									end
									if (((12806 - 7876) > (4277 - (582 + 1388))) and (v253 == (4 - 1))) then
										if ((v107 >= v87.CPMaxSpend()) or ((2897 + 1149) < (1655 - (326 + 38)))) then
											local v259 = 0 - 0;
											while true do
												if ((v259 == (0 - 0)) or ((4861 - (47 + 573)) == (1250 + 2295))) then
													v101 = v129();
													if (v101 or ((17192 - 13144) > (6868 - 2636))) then
														return "Finish: " .. v101;
													end
													break;
												end
											end
										end
										if ((v109 <= (1665 - (1269 + 395))) or (HL.BossFilteredFightRemains("<=", 493 - (76 + 416)) and (v107 >= (446 - (319 + 124)))) or ((4000 - 2250) >= (4480 - (564 + 443)))) then
											v101 = v129();
											if (((8764 - 5598) == (3624 - (337 + 121))) and v101) then
												return "Finish: " .. v101;
											end
										end
										if (((5165 - 3402) < (12405 - 8681)) and (v98 >= (1915 - (1261 + 650))) and (v107 >= (2 + 2))) then
											v101 = v129();
											if (((90 - 33) <= (4540 - (772 + 1045))) and v101) then
												return "Finish: " .. v101;
											end
										end
										v253 = 1 + 3;
									end
									if ((v253 == (148 - (102 + 42))) or ((3914 - (1524 + 320)) == (1713 - (1049 + 221)))) then
										v101 = v135(v110);
										if (v101 or ((2861 - (18 + 138)) == (3409 - 2016))) then
											return "Build: " .. v101;
										end
										if (v10.CD or ((5703 - (67 + 1035)) < (409 - (136 + 212)))) then
											if ((v88.ArcaneTorrent:IsReady() and v94 and (v13:EnergyDeficitPredicted() >= ((63 - 48) + v13:EnergyRegen()))) or ((1114 + 276) >= (4374 + 370))) then
												if (v26(v88.ArcaneTorrent, v39) or ((3607 - (240 + 1364)) > (4916 - (1050 + 32)))) then
													return "Cast Arcane Torrent";
												end
											end
											if ((v88.ArcanePulse:IsReady() and v94) or ((556 - 400) > (2315 + 1598))) then
												if (((1250 - (331 + 724)) == (16 + 179)) and v26(v88.ArcanePulse, v39)) then
													return "Cast Arcane Pulse";
												end
											end
											if (((3749 - (269 + 375)) >= (2521 - (267 + 458))) and v88.LightsJudgment:IsReady()) then
												if (((1362 + 3017) >= (4097 - 1966)) and v26(v88.LightsJudgment, v39)) then
													return "Cast Lights Judgment";
												end
											end
											if (((4662 - (667 + 151)) >= (3540 - (1410 + 87))) and v88.BagofTricks:IsReady()) then
												if (v26(v88.BagofTricks, v39) or ((5129 - (1504 + 393)) <= (7381 - 4650))) then
													return "Cast Bag of Tricks";
												end
											end
										end
										v253 = 12 - 7;
									end
									if (((5701 - (461 + 335)) == (627 + 4278)) and (v253 == (1766 - (1730 + 31)))) then
										if (v104 or ((5803 - (728 + 939)) >= (15622 - 11211))) then
											v112(v104);
										end
										if ((v102 and v94) or ((5999 - 3041) == (9203 - 5186))) then
											if (((2296 - (138 + 930)) >= (743 + 70)) and (type(v102) == "table") and (#v102 > (1 + 0))) then
												if (v28(v13:EnergyTimeToX(v103), unpack(v102)) or ((2962 + 493) > (16537 - 12487))) then
													return "Macro pool towards " .. v102[1767 - (459 + 1307)]:Name() .. " at " .. v103;
												end
											elseif (((2113 - (474 + 1396)) == (424 - 181)) and v102:IsCastable()) then
												v103 = v34(v103, v102:Cost());
												if (v26(v102, v13:EnergyTimeToX(v103)) or ((254 + 17) > (6 + 1566))) then
													return "Pool towards: " .. v102:Name() .. " at " .. v103;
												end
											end
										end
										break;
									end
								end
							end
							v234 = 2 - 1;
						end
						if (((348 + 2391) < (10992 - 7699)) and (v234 == (4 - 3))) then
							if ((v88.ShurikenToss:IsCastable() and v14:IsInRange(621 - (562 + 29)) and not v95 and not v13:StealthUp(true, true) and not v13:BuffUp(v88.Sprint) and (v13:EnergyDeficitPredicted() < (18 + 2)) and ((v109 >= (1420 - (374 + 1045))) or (v13:EnergyTimeToMax() <= (1.2 + 0)))) or ((12240 - 8298) < (1772 - (448 + 190)))) then
								if (v26(v88.ShurikenToss) or ((870 + 1823) == (2245 + 2728))) then
									return "Cast Shuriken Toss";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((1399 + 747) == (8250 - 6104)) and ((12 - 8) == v220)) then
				if (v37 or ((3738 - (1307 + 187)) == (12784 - 9560))) then
					local v235 = 0 - 0;
					while true do
						if ((v235 == (0 - 0)) or ((5587 - (232 + 451)) <= (1830 + 86))) then
							v96 = v13:GetEnemiesInRange(27 + 3);
							v97 = v13:GetEnemiesInMeleeRange(v93);
							v235 = 565 - (510 + 54);
						end
						if (((181 - 91) <= (1101 - (13 + 23))) and (v235 == (1 - 0))) then
							v98 = #v97;
							v99 = v13:GetEnemiesInMeleeRange(v92);
							break;
						end
					end
				else
					local v236 = 0 - 0;
					while true do
						if (((8724 - 3922) == (5890 - (830 + 258))) and (v236 == (3 - 2))) then
							v98 = 1 + 0;
							v99 = {};
							break;
						end
						if ((v236 == (0 + 0)) or ((3721 - (860 + 581)) <= (1884 - 1373))) then
							v96 = {};
							v97 = {};
							v236 = 1 + 0;
						end
					end
				end
				v108 = v13:ComboPoints();
				v107 = v87.EffectiveComboPoints(v108);
				v220 = 246 - (237 + 4);
			end
			if ((v220 == (13 - 7)) or ((4239 - 2563) <= (877 - 414))) then
				if (((3167 + 702) == (2223 + 1646)) and (v107 > v108) and (v109 > (7 - 5)) and v13:AffectingCombat()) then
					if (((497 + 661) <= (1422 + 1191)) and (((v108 == (1428 - (85 + 1341))) and not v13:BuffUp(v88.EchoingReprimand3)) or ((v108 == (4 - 1)) and not v13:BuffUp(v88.EchoingReprimand4)) or ((v108 == (11 - 7)) and not v13:BuffUp(v88.EchoingReprimand5)))) then
						local v246 = 372 - (45 + 327);
						local v247;
						while true do
							if (((0 - 0) == v246) or ((2866 - (444 + 58)) <= (869 + 1130))) then
								v247 = v87.TimeToSht(1 + 3);
								if ((v247 == (0 + 0)) or ((14263 - 9341) < (1926 - (64 + 1668)))) then
									v247 = v87.TimeToSht(1978 - (1227 + 746));
								end
								v246 = 2 - 1;
							end
							if ((v246 == (1 - 0)) or ((2585 - (415 + 79)) < (1 + 30))) then
								if ((v247 < (v34(v13:EnergyTimeToX(526 - (142 + 349)), v13:GCDRemains()) + 0.5 + 0)) or ((3341 - 911) >= (2422 + 2450))) then
									v107 = v108;
								end
								break;
							end
						end
					end
				end
				if ((v13:BuffUp(v88.ShurikenTornado, nil, true) and (v108 < v87.CPMaxSpend())) or ((3361 + 1409) < (4724 - 2989))) then
					local v237 = 1864 - (1710 + 154);
					local v238;
					while true do
						if ((v237 == (318 - (200 + 118))) or ((1759 + 2680) <= (4108 - 1758))) then
							v238 = v87.TimeToNextTornado();
							if ((v238 <= v13:GCDRemains()) or (v35(v13:GCDRemains() - v238) < (0.25 - 0)) or ((3980 + 499) < (4418 + 48))) then
								local v255 = v98 + v29(v13:BuffUp(v88.ShadowBlades));
								v108 = v33(v108 + v255, v87.CPMaxSpend());
								v109 = v34(v109 - v255, 0 + 0);
								if (((407 + 2140) > (2654 - 1429)) and (v107 < v87.CPMaxSpend())) then
									v107 = v108;
								end
							end
							break;
						end
					end
				end
				v105 = ((1254 - (363 + 887)) + (v107 * (6 - 2))) * (0.3 - 0);
				v220 = 2 + 5;
			end
			if (((10929 - 6258) > (1828 + 846)) and (v220 == (1669 - (674 + 990)))) then
				v109 = v13:ComboPointsDeficit();
				v111 = v115();
				v110 = v13:EnergyMax() - v117();
				v220 = 2 + 4;
			end
			if (((2 + 1) == v220) or ((5857 - 2161) < (4382 - (507 + 548)))) then
				v93 = (v88.AcrobaticStrikes:IsAvailable() and (850 - (289 + 548))) or (1828 - (821 + 997));
				v94 = v14:IsInMeleeRange(v92);
				v95 = v14:IsInMeleeRange(v93);
				v220 = 259 - (195 + 60);
			end
		end
	end
	local function v137()
		v10.Print("Subtlety Rogue rotation has NOT been updated for patch 10.2.0. It is unlikely to work properly at this time.");
	end
	v10.SetAPL(71 + 190, v136, v137);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

