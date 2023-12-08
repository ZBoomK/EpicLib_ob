local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((1446 - 703) == (380 + 103))) then
			return v6(...);
		end
		if (((3934 - (641 + 839)) > (1491 - (910 + 3))) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((2614 - (1466 + 218)) < (2049 + 2409)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1149 - (556 + 592);
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
	local v28 = v10.Cast;
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
		v42 = EpicSettings.Settings['HealingPotionHP'] or (808 - (329 + 479));
		v43 = EpicSettings.Settings['UseHealthstone'];
		v44 = EpicSettings.Settings['HealthstoneHP'] or (854 - (174 + 680));
		v45 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v46 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
		v47 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
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
	local v96, v97, v98, v99;
	local v100;
	local v101, v102, v103;
	local v104, v105;
	local v106, v107, v108, v109;
	local v110;
	v88.Eviscerate:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v106 * (1389.176 - (135 + 1254)) * (3.21 - 2) * ((v88.Nightstalker:IsAvailable() and v13:StealthUp(true, false) and (4.08 - 3)) or (1 + 0)) * ((v88.DeeperStratagem:IsAvailable() and (1528.05 - (389 + 1138))) or (575 - (102 + 472))) * ((v88.DarkShadow:IsAvailable() and v13:BuffUp(v88.ShadowDanceBuff) and (1.3 + 0)) or (1 + 0)) * ((v13:BuffUp(v88.SymbolsofDeath) and (1.1 + 0)) or (1546 - (320 + 1225))) * ((v13:BuffUp(v88.FinalityEviscerateBuff) and (1.3 - 0)) or (1 + 0)) * ((1465 - (157 + 1307)) + (v13:MasteryPct() / (1959 - (821 + 1038)))) * ((2 - 1) + (v13:VersatilityDmgPct() / (11 + 89))) * ((v14:DebuffUp(v88.FindWeaknessDebuff) and (1.5 - 0)) or (1 + 0));
	end);
	v88.Rupture:RegisterPMultiplier(function()
		return (v13:BuffUp(v88.FinalityRuptureBuff) and (2.3 - 1)) or (1027 - (834 + 192));
	end);
	local function v111(v170, v171)
		if (((43 + 619) <= (250 + 722)) and not v101) then
			local v227 = 0 + 0;
			while true do
				if (((6770 - 2400) == (4674 - (300 + 4))) and (v227 == (0 + 0))) then
					v101 = v170;
					v102 = v171 or (0 - 0);
					break;
				end
			end
		end
	end
	local function v112(v172)
		if (not v103 or ((5124 - (112 + 250)) <= (344 + 517))) then
			v103 = v172;
		end
	end
	local function v113()
		if (((v76 == "On Bosses not in Dungeons") and v13:IsInDungeonArea()) or ((3537 - 2125) == (2443 + 1821))) then
			return false;
		elseif (((v76 ~= "Always") and not v14:IsInBossList()) or ((1639 + 1529) < (1611 + 542))) then
			return false;
		else
			return true;
		end
	end
	local function v114()
		local v173 = 0 + 0;
		while true do
			if ((v173 == (0 + 0)) or ((6390 - (1001 + 413)) < (2970 - 1638))) then
				if (((5510 - (244 + 638)) == (5321 - (627 + 66))) and (v98 < (5 - 3))) then
					return false;
				elseif ((v52 == "Always") or ((656 - (512 + 90)) == (2301 - (1665 + 241)))) then
					return true;
				elseif (((799 - (373 + 344)) == (37 + 45)) and (v52 == "On Bosses") and v14:IsInBossList()) then
					return true;
				elseif ((v52 == "Auto") or ((154 + 427) < (743 - 461))) then
					if (((v13:InstanceDifficulty() == (26 - 10)) and (v14:NPCID() == (140066 - (35 + 1064)))) or ((3354 + 1255) < (5338 - 2843))) then
						return true;
					elseif (((5 + 1147) == (2388 - (298 + 938))) and ((v14:NPCID() == (168228 - (233 + 1026))) or (v14:NPCID() == (168637 - (636 + 1030))) or (v14:NPCID() == (85367 + 81603)))) then
						return true;
					elseif (((1852 + 44) <= (1017 + 2405)) and ((v14:NPCID() == (12396 + 171067)) or (v14:NPCID() == (183892 - (55 + 166))))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v115(v174, v175, v176, v177, v178)
		local v179 = 0 + 0;
		local v180;
		local v181;
		local v182;
		while true do
			if ((v179 == (1 + 0)) or ((3780 - 2790) > (1917 - (36 + 261)))) then
				for v235, v236 in v31(v177) do
					if (((v236:GUID() ~= v182) and v86.UnitIsCycleValid(v236, v181, -v236:DebuffRemains(v174)) and v175(v236)) or ((1533 - 656) > (6063 - (34 + 1334)))) then
						v180, v181 = v236, v236:TimeToDie();
					end
				end
				if (((1035 + 1656) >= (1439 + 412)) and v180) then
					v10.Press(v180, v174);
				elseif (v51 or ((4268 - (1035 + 248)) >= (4877 - (20 + 1)))) then
					local v247 = 0 + 0;
					while true do
						if (((4595 - (134 + 185)) >= (2328 - (549 + 584))) and (v247 == (686 - (314 + 371)))) then
							if (((11095 - 7863) <= (5658 - (478 + 490))) and v180) then
								v10.Press(v180, v174);
							end
							break;
						end
						if ((v247 == (0 + 0)) or ((2068 - (786 + 386)) >= (10189 - 7043))) then
							v180, v181 = nil, v176;
							for v267, v268 in v31(v97) do
								if (((4440 - (1055 + 324)) >= (4298 - (1093 + 247))) and (v268:GUID() ~= v182) and v86.UnitIsCycleValid(v268, v181, -v268:DebuffRemains(v174)) and v175(v268)) then
									v180, v181 = v268, v268:TimeToDie();
								end
							end
							v247 = 1 + 0;
						end
					end
				end
				break;
			end
			if (((336 + 2851) >= (2556 - 1912)) and (v179 == (0 - 0))) then
				v180, v181 = nil, v176;
				v182 = v14:GUID();
				v179 = 2 - 1;
			end
		end
	end
	local function v116()
		return (50 - 30) + (v88.Vigor:TalentRank() * (9 + 16)) + (v29(v88.ThistleTea:IsAvailable()) * (77 - 57)) + (v29(v88.Shadowcraft:IsAvailable()) * (68 - 48));
	end
	local function v117()
		return v88.ShadowDance:ChargesFractional() >= (0.75 + 0 + v21(v88.ShadowDanceTalent:IsAvailable()));
	end
	local function v118()
		return v108 >= (7 - 4);
	end
	local function v119()
		return v13:BuffUp(v88.SliceandDice) or (v98 >= v87.CPMaxSpend());
	end
	local function v120()
		return v88.Premeditation:IsAvailable() and (v98 < (693 - (364 + 324)));
	end
	local function v121(v183)
		return (v13:BuffUp(v88.ThistleTea) and (v98 == (2 - 1))) or (v183 and ((v98 == (2 - 1)) or (v14:DebuffUp(v88.Rupture) and (v98 >= (1 + 1)))));
	end
	local function v122()
		return (not v13:BuffUp(v88.Premeditation) and (v98 == (4 - 3))) or not v88.TheRotten:IsAvailable() or (v98 > (1 - 0));
	end
	local function v123()
		return v13:BuffDown(v88.PremeditationBuff) or (v98 > (2 - 1)) or ((v107 <= (1270 - (1249 + 19))) and v13:BuffUp(v88.TheRottenBuff) and not v13:HasTier(28 + 2, 7 - 5));
	end
	local function v124(v184, v185)
		return v184 and ((v13:BuffStack(v88.DanseMacabreBuff) >= (1089 - (686 + 400))) or not v88.DanseMacabre:IsAvailable()) and (not v185 or (v98 ~= (2 + 0)));
	end
	local function v125()
		return (not v13:BuffUp(v88.TheRotten) or not v13:HasTier(259 - (73 + 156), 1 + 1)) and (not v88.ColdBlood:IsAvailable() or (v88.ColdBlood:CooldownRemains() < (815 - (721 + 90))) or (v88.ColdBlood:CooldownRemains() > (1 + 9)));
	end
	local function v126(v186)
		return v13:BuffUp(v88.ShadowDanceBuff) and (v186:TimeSinceLastCast() < v88.ShadowDance:TimeSinceLastCast());
	end
	local function v124()
		return ((v126(v88.Shadowstrike) or v126(v88.ShurikenStorm)) and (v126(v88.Eviscerate) or v126(v88.BlackPowder) or v126(v88.Rupture))) or not v88.DanseMacabre:IsAvailable();
	end
	local function v127()
		return (not v89.WitherbarksBranch:IsEquipped() and not v89.AshesoftheEmbersoul:IsEquipped()) or (not v89.WitherbarksBranch:IsEquipped() and (v89.WitherbarksBranch:CooldownRemains() <= (25 - 17))) or (v89.WitherbarksBranch:IsEquipped() and (v89.WitherbarksBranch:CooldownRemains() <= (478 - (224 + 246)))) or v89.BandolierOfTwistedBlades:IsEquipped() or v88.InvigoratingShadowdust:IsAvailable();
	end
	local function v128(v187, v188)
		local v189 = 0 - 0;
		local v190;
		local v191;
		local v192;
		local v193;
		local v194;
		local v195;
		local v196;
		while true do
			if (((1185 - 541) <= (128 + 576)) and (v189 == (1 + 3))) then
				if (((704 + 254) > (1882 - 935)) and v88.BlackPowder:IsCastable() and not v110 and (v98 >= (9 - 6))) then
					if (((5005 - (203 + 310)) >= (4647 - (1238 + 755))) and v187) then
						return v88.BlackPowder;
					else
						local v248 = 0 + 0;
						while true do
							if (((4976 - (709 + 825)) >= (2768 - 1265)) and (v248 == (0 - 0))) then
								if ((v88.BlackPowder:IsReady() and v26(v88.BlackPowder)) or ((4034 - (196 + 668)) <= (5780 - 4316))) then
									return "Cast Black Powder";
								end
								v112(v88.BlackPowder);
								break;
							end
						end
					end
				end
				if ((v88.Eviscerate:IsCastable() and v94 and (v107 > (1 - 0))) or ((5630 - (171 + 662)) == (4481 - (4 + 89)))) then
					if (((1931 - 1380) <= (248 + 433)) and v187) then
						return v88.Eviscerate;
					else
						local v249 = 0 - 0;
						while true do
							if (((1286 + 1991) > (1893 - (35 + 1451))) and (v249 == (1453 - (28 + 1425)))) then
								if (((6688 - (941 + 1052)) >= (1357 + 58)) and v88.Eviscerate:IsReady() and v26(v88.Eviscerate)) then
									return "Cast Eviscerate";
								end
								v112(v88.Eviscerate);
								break;
							end
						end
					end
				end
				return false;
			end
			if ((v189 == (1517 - (822 + 692))) or ((4585 - 1373) <= (445 + 499))) then
				if ((v13:BuffUp(v88.FinalityRuptureBuff) and v190 and (v98 <= (301 - (45 + 252))) and not v126(v88.Rupture)) or ((3064 + 32) <= (619 + 1179))) then
					if (((8607 - 5070) == (3970 - (114 + 319))) and v187) then
						return v88.Rupture;
					else
						if (((5509 - 1672) >= (2011 - 441)) and v88.Rupture:IsReady() and v10.Press(v88.Rupture)) then
							return "Cast Rupture Finality";
						end
						v112(v88.Rupture);
					end
				end
				if ((v88.ColdBlood:IsReady() and v124(v190, v196) and v88.SecretTechnique:IsReady()) or ((1881 + 1069) == (5678 - 1866))) then
					if (((9895 - 5172) >= (4281 - (556 + 1407))) and v65) then
						v10.Press(v88.ColdBlood);
					else
						local v250 = 1206 - (741 + 465);
						while true do
							if ((v250 == (465 - (170 + 295))) or ((1069 + 958) > (2620 + 232))) then
								if (v187 or ((2796 - 1660) > (3579 + 738))) then
									return v88.ColdBlood;
								end
								if (((3045 + 1703) == (2689 + 2059)) and v10.Press(v88.ColdBlood)) then
									return "Cast Cold Blood (SecTec)";
								end
								break;
							end
						end
					end
				end
				if (((4966 - (957 + 273)) <= (1268 + 3472)) and v88.SecretTechnique:IsReady()) then
					if ((v124(v190, v196) and (not v88.ColdBlood:IsAvailable() or (v65 and v88.ColdBlood:IsReady()) or v13:BuffUp(v88.ColdBlood) or (v194 > (v191 - (1 + 1))) or not v88.ImprovedShadowDance:IsAvailable())) or ((12917 - 9527) <= (8063 - 5003))) then
						local v251 = 0 - 0;
						while true do
							if ((v251 == (0 - 0)) or ((2779 - (389 + 1391)) > (1690 + 1003))) then
								if (((49 + 414) < (1368 - 767)) and v187) then
									return v88.SecretTechnique;
								end
								if (v10.Press(v88.SecretTechnique) or ((3134 - (783 + 168)) < (2305 - 1618))) then
									return "Cast Secret Technique";
								end
								break;
							end
						end
					end
				end
				if (((4475 + 74) == (4860 - (309 + 2))) and not v121(v190) and v88.Rupture:IsCastable()) then
					if (((14346 - 9674) == (5884 - (1090 + 122))) and not v187 and v37 and not v110 and (v98 >= (1 + 1))) then
						local v252 = 0 - 0;
						local v253;
						while true do
							if ((v252 == (1 + 0)) or ((4786 - (628 + 490)) < (71 + 324))) then
								v115(v88.Rupture, v253, (4 - 2) * v193, v99);
								break;
							end
							if (((0 - 0) == v252) or ((4940 - (431 + 343)) == (918 - 463))) then
								v253 = nil;
								function v253(v269)
									return v86.CanDoTUnit(v269, v105) and v269:DebuffRefreshable(v88.Rupture, v104);
								end
								v252 = 2 - 1;
							end
						end
					end
					if ((v94 and (v14:DebuffRemains(v88.Rupture) < (v88.SymbolsofDeath:CooldownRemains() + 8 + 2)) and (v107 > (0 + 0)) and (v88.SymbolsofDeath:CooldownRemains() <= (1700 - (556 + 1139))) and v87.CanDoTUnit(v14, v105) and v14:FilteredTimeToDie(">", (20 - (6 + 9)) + v88.SymbolsofDeath:CooldownRemains(), -v14:DebuffRemains(v88.Rupture))) or ((815 + 3634) == (1365 + 1298))) then
						if (v187 or ((4446 - (28 + 141)) < (1158 + 1831))) then
							return v88.Rupture;
						else
							local v262 = 0 - 0;
							while true do
								if ((v262 == (0 + 0)) or ((2187 - (486 + 831)) >= (10796 - 6647))) then
									if (((7787 - 5575) < (602 + 2581)) and v88.Rupture:IsReady() and v10.Cast(v88.Rupture)) then
										return "Cast Rupture 2";
									end
									v112(v88.Rupture);
									break;
								end
							end
						end
					end
				end
				v189 = 12 - 8;
			end
			if (((5909 - (668 + 595)) > (2693 + 299)) and (v189 == (0 + 0))) then
				v190 = v13:BuffUp(v88.ShadowDanceBuff);
				v191 = v13:BuffRemains(v88.ShadowDanceBuff);
				v192 = v13:BuffRemains(v88.SymbolsofDeath);
				v193 = v107;
				v189 = 2 - 1;
			end
			if (((1724 - (23 + 267)) < (5050 - (1129 + 815))) and (v189 == (389 - (371 + 16)))) then
				if (((2536 - (1326 + 424)) < (5724 - 2701)) and v188 and (v188:ID() == v88.Vanish:ID())) then
					local v240 = 0 - 0;
					while true do
						if ((v240 == (118 - (88 + 30))) or ((3213 - (720 + 51)) < (164 - 90))) then
							v194 = v33(1776 - (421 + 1355), v88.ColdBlood:CooldownRemains() - ((24 - 9) * v88.InvigoratingShadowdust:TalentRank()));
							v195 = v33(0 + 0, v88.SymbolsofDeath:CooldownRemains() - ((1098 - (286 + 797)) * v88.InvigoratingShadowdust:TalentRank()));
							break;
						end
					end
				end
				if (((16578 - 12043) == (7511 - 2976)) and v88.Rupture:IsCastable() and v88.Rupture:IsReady()) then
					if ((v14:DebuffDown(v88.Rupture) and (v14:TimeToDie() > (445 - (397 + 42)))) or ((940 + 2069) <= (2905 - (24 + 776)))) then
						if (((2819 - 989) < (4454 - (222 + 563))) and v187) then
							return v88.Rupture;
						else
							local v263 = 0 - 0;
							while true do
								if (((0 + 0) == v263) or ((1620 - (23 + 167)) >= (5410 - (690 + 1108)))) then
									if (((969 + 1714) >= (2030 + 430)) and v88.Rupture:IsReady() and v10.Press(v88.Rupture)) then
										return "Cast Rupture";
									end
									v112(v88.Rupture);
									break;
								end
							end
						end
					end
				end
				if ((not v13:StealthUp(true, true) and not v120() and (v98 < (854 - (40 + 808))) and not v190 and v10.BossFilteredFightRemains(">", v13:BuffRemains(v88.SliceandDice)) and (v13:BuffRemains(v88.SliceandDice) < ((1 + 0 + v13:ComboPoints()) * (3.8 - 2)))) or ((1725 + 79) >= (1733 + 1542))) then
					if (v187 or ((778 + 639) > (4200 - (47 + 524)))) then
						return v88.SliceandDice;
					else
						local v254 = 0 + 0;
						while true do
							if (((13107 - 8312) > (600 - 198)) and (v254 == (0 - 0))) then
								if (((6539 - (1165 + 561)) > (106 + 3459)) and v88.SliceandDice:IsReady() and v10.Press(v88.SliceandDice)) then
									return "Cast Slice and Dice Premed";
								end
								v112(v88.SliceandDice);
								break;
							end
						end
					end
				end
				if (((12116 - 8204) == (1493 + 2419)) and (not v121(v190) or v110) and (v14:TimeToDie() > (485 - (341 + 138))) and v14:DebuffRefreshable(v88.Rupture, v104)) then
					if (((762 + 2059) <= (9954 - 5130)) and v187) then
						return v88.Rupture;
					else
						local v255 = 326 - (89 + 237);
						while true do
							if (((5590 - 3852) <= (4621 - 2426)) and (v255 == (881 - (581 + 300)))) then
								if (((1261 - (855 + 365)) <= (7168 - 4150)) and v88.Rupture:IsReady() and v10.Press(v88.Rupture)) then
									return "Cast Rupture";
								end
								v112(v88.Rupture);
								break;
							end
						end
					end
				end
				v189 = 1 + 2;
			end
			if (((3380 - (1030 + 205)) <= (3853 + 251)) and (v189 == (1 + 0))) then
				v194 = v88.ColdBlood:CooldownRemains();
				v195 = v88.SymbolsofDeath:CooldownRemains();
				v196 = v13:BuffUp(v88.PremeditationBuff) or (v188 and v88.Premeditation:IsAvailable());
				if (((2975 - (156 + 130)) < (11008 - 6163)) and v188 and (v188:ID() == v88.ShadowDance:ID())) then
					local v241 = 0 - 0;
					while true do
						if ((v241 == (0 - 0)) or ((612 + 1710) > (1529 + 1093))) then
							v190 = true;
							v191 = (77 - (10 + 59)) + v88.ImprovedShadowDance:TalentRank();
							v241 = 1 + 0;
						end
						if ((v241 == (4 - 3)) or ((5697 - (671 + 492)) == (1658 + 424))) then
							if (v88.TheFirstDance:IsAvailable() or ((2786 - (369 + 846)) > (495 + 1372))) then
								v193 = v33(v13:ComboPointsMax(), v107 + 4 + 0);
							end
							if (v13:HasTier(1975 - (1036 + 909), 2 + 0) or ((4455 - 1801) >= (3199 - (11 + 192)))) then
								v192 = v34(v192, 4 + 2);
							end
							break;
						end
					end
				end
				v189 = 177 - (135 + 40);
			end
		end
	end
	local function v129(v197, v198)
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
			if (((2398 + 1580) > (4635 - 2531)) and (v199 == (7 - 2))) then
				if (((3171 - (50 + 126)) > (4290 - 2749)) and v88.Backstab:IsCastable() and not v205 and (v201 >= (1 + 2)) and v13:BuffUp(v88.ShadowBlades) and not v126(v88.Backstab) and v88.DanseMacabre:IsAvailable() and (v98 <= (1416 - (1233 + 180))) and not v202) then
					if (((4218 - (522 + 447)) > (2374 - (107 + 1314))) and v197) then
						if (v198 or ((1519 + 1754) > (13934 - 9361))) then
							return v88.Backstab;
						else
							return {v88.Backstab,v88.Stealth};
						end
					elseif (v26(v88.Backstab, v88.Stealth) or ((12467 - 9316) < (3194 - (716 + 1194)))) then
						return "Cast Backstab (Stealth)";
					end
				end
				if (v88.Gloomblade:IsAvailable() or ((32 + 1818) == (164 + 1365))) then
					if (((1324 - (74 + 429)) < (4094 - 1971)) and not v205 and (v201 >= (2 + 1)) and v13:BuffUp(v88.ShadowBlades) and not v126(v88.Gloomblade) and v88.DanseMacabre:IsAvailable() and (v98 <= (8 - 4))) then
						if (((639 + 263) < (7167 - 4842)) and v197) then
							if (((2121 - 1263) <= (3395 - (279 + 154))) and v198) then
								return v88.Gloomblade;
							else
								return {v88.Gloomblade,v88.Stealth};
							end
						elseif (v27(v88.Gloomblade, v88.Stealth) or ((3963 - (12 + 5)) < (695 + 593))) then
							return "Cast Gloomblade (Danse)";
						end
					end
				end
				if ((not v126(v88.Shadowstrike) and v13:BuffUp(v88.ShadowBlades)) or ((8260 - 5018) == (210 + 357))) then
					if (v197 or ((1940 - (277 + 816)) >= (5396 - 4133))) then
						return v88.Shadowstrike;
					elseif (v26(v88.Shadowstrike) or ((3436 - (1058 + 125)) == (348 + 1503))) then
						return "Cast Shadowstrike (Danse)";
					end
				end
				v199 = 981 - (815 + 160);
			end
			if ((v199 == (0 - 0)) or ((4953 - 2866) > (566 + 1806))) then
				v200 = v13:BuffUp(v88.ShadowDanceBuff);
				v201 = v13:BuffRemains(v88.ShadowDanceBuff);
				v202 = v13:BuffUp(v88.TheRottenBuff);
				v199 = 2 - 1;
			end
			if ((v199 == (1902 - (41 + 1857))) or ((6338 - (1222 + 671)) < (10723 - 6574))) then
				if ((v208 >= v87.CPMaxSpend()) or ((2612 - 794) == (1267 - (229 + 953)))) then
					return v128(v197, v198);
				end
				if (((2404 - (1111 + 663)) < (3706 - (874 + 705))) and v13:BuffUp(v88.ShurikenTornado) and (v204 <= (1 + 1))) then
					return v128(v197, v198);
				end
				if ((v108 <= (1 + 0 + v29(v88.DeeperStratagem:IsAvailable() or v88.SecretStratagem:IsAvailable()))) or ((4028 - 2090) == (71 + 2443))) then
					return v128(v197, v198);
				end
				v199 = 684 - (642 + 37);
			end
			if (((971 + 3284) >= (9 + 46)) and (v199 == (7 - 4))) then
				v209 = v88.Shadowstrike:IsCastable() or v206 or v207 or v200 or v13:BuffUp(v88.SepsisBuff);
				if (((3453 - (233 + 221)) > (2672 - 1516)) and (v206 or v207)) then
					v209 = v209 and v14:IsInRange(23 + 2);
				else
					v209 = v209 and v94;
				end
				if (((3891 - (718 + 823)) > (727 + 428)) and v209 and v206 and ((v98 < (809 - (266 + 539))) or v110)) then
					if (((11406 - 7377) <= (6078 - (636 + 589))) and v197) then
						return v88.Shadowstrike;
					elseif (v26(v88.Shadowstrike) or ((1224 - 708) > (7082 - 3648))) then
						return "Cast Shadowstrike (Stealth)";
					end
				end
				v199 = 4 + 0;
			end
			if (((1470 + 2576) >= (4048 - (657 + 358))) and (v199 == (4 - 2))) then
				v207 = v13:BuffUp(v87.VanishBuffSpell()) or (v198 and (v198:ID() == v88.Vanish:ID()));
				if ((v198 and (v198:ID() == v88.ShadowDance:ID())) or ((6194 - 3475) <= (2634 - (1151 + 36)))) then
					local v242 = 0 + 0;
					while true do
						if ((v242 == (0 + 0)) or ((12345 - 8211) < (5758 - (1552 + 280)))) then
							v200 = true;
							v201 = (842 - (64 + 770)) + v88.ImprovedShadowDance:TalentRank();
							v242 = 1 + 0;
						end
						if ((v242 == (2 - 1)) or ((30 + 134) >= (4028 - (157 + 1086)))) then
							if ((v88.TheRotten:IsAvailable() and v13:HasTier(60 - 30, 8 - 6)) or ((804 - 279) == (2877 - 768))) then
								v202 = true;
							end
							if (((852 - (599 + 220)) == (65 - 32)) and v88.TheFirstDance:IsAvailable()) then
								local v265 = 1931 - (1813 + 118);
								while true do
									if (((2233 + 821) <= (5232 - (841 + 376))) and (v265 == (0 - 0))) then
										v203 = v33(v13:ComboPointsMax(), v107 + 1 + 3);
										v204 = v13:ComboPointsMax() - v203;
										break;
									end
								end
							end
							break;
						end
					end
				end
				v208 = v87.EffectiveComboPoints(v203);
				v199 = 8 - 5;
			end
			if (((2730 - (464 + 395)) < (8679 - 5297)) and (v199 == (1 + 0))) then
				v203, v204 = v107, v108;
				v205 = v13:BuffUp(v88.PremeditationBuff) or (v198 and v88.Premeditation:IsAvailable());
				v206 = v13:BuffUp(v87.StealthSpell()) or (v198 and (v198:ID() == v87.StealthSpell():ID()));
				v199 = 839 - (467 + 370);
			end
			if (((2671 - 1378) <= (1590 + 576)) and ((20 - 14) == v199)) then
				if ((not v205 and (v98 >= (1 + 3))) or ((5999 - 3420) < (643 - (150 + 370)))) then
					if (v197 or ((2128 - (74 + 1208)) >= (5824 - 3456))) then
						return v88.ShurikenStorm;
					elseif (v26(v88.ShurikenStorm) or ((19027 - 15015) <= (2390 + 968))) then
						return "Cast Shuriken Storm";
					end
				end
				if (((1884 - (14 + 376)) <= (5212 - 2207)) and v209) then
					if (v197 or ((2014 + 1097) == (1875 + 259))) then
						return v88.Shadowstrike;
					elseif (((2246 + 109) == (6900 - 4545)) and v26(v88.Shadowstrike)) then
						return "Cast Shadowstrike";
					end
				end
				return false;
			end
		end
	end
	local function v130(v210, v211)
		local v212 = v129(true, v210);
		if ((v210:ID() == v88.Vanish:ID()) or ((443 + 145) <= (510 - (23 + 55)))) then
			local v228 = 0 - 0;
			while true do
				if (((3202 + 1595) >= (3498 + 397)) and ((0 - 0) == v228)) then
					if (((1126 + 2451) == (4478 - (652 + 249))) and v26(v88.Vanish, v62)) then
						return "Cast Vanish";
					end
					return false;
				end
			end
		elseif (((10153 - 6359) > (5561 - (708 + 1160))) and (v210:ID() == v88.Shadowmeld:ID())) then
			local v237 = 0 - 0;
			while true do
				if ((v237 == (0 - 0)) or ((1302 - (10 + 17)) == (921 + 3179))) then
					if (v26(v88.Shadowmeld, v39) or ((3323 - (1400 + 332)) >= (6866 - 3286))) then
						return "Cast Shadowmeld";
					end
					return false;
				end
			end
		elseif (((2891 - (242 + 1666)) <= (774 + 1034)) and (v210:ID() == v88.ShadowDance:ID())) then
			local v246 = 0 + 0;
			while true do
				if ((v246 == (0 + 0)) or ((3090 - (850 + 90)) <= (2096 - 899))) then
					if (((5159 - (360 + 1030)) >= (1039 + 134)) and v26(v88.ShadowDance, v63)) then
						return "Cast Shadow Dance";
					end
					return false;
				end
			end
		end
		local v213 = {v210,v212};
		if (((3146 - (909 + 752)) == (2708 - (109 + 1114))) and v211 and (v13:EnergyPredicted() < v211)) then
			local v229 = 0 - 0;
			while true do
				if (((0 + 0) == v229) or ((3557 - (6 + 236)) <= (1753 + 1029))) then
					v111(v213, v211);
					return false;
				end
			end
		end
		v100 = v27(unpack(v213));
		if (v100 or ((706 + 170) >= (6989 - 4025))) then
			return "| " .. v213[3 - 1]:Name();
		end
		return false;
	end
	local function v131()
		local v214 = 1133 - (1076 + 57);
		while true do
			if ((v214 == (0 + 0)) or ((2921 - (579 + 110)) > (198 + 2299))) then
				v100 = v86.HandleTopTrinket(v91, v38, 36 + 4, nil);
				if (v100 or ((1120 + 990) <= (739 - (174 + 233)))) then
					return v100;
				end
				v214 = 2 - 1;
			end
			if (((6469 - 2783) > (1411 + 1761)) and (v214 == (1175 - (663 + 511)))) then
				v100 = v86.HandleBottomTrinket(v91, v38, 36 + 4, nil);
				if (v100 or ((972 + 3502) < (2528 - 1708))) then
					return v100;
				end
				break;
			end
		end
	end
	local function v132()
		local v215 = 0 + 0;
		local v216;
		while true do
			if (((10073 - 5794) >= (6976 - 4094)) and (v215 == (0 + 0))) then
				if ((v38 and v88.ColdBlood:IsReady() and not v88.SecretTechnique:IsAvailable() and (v107 >= (9 - 4))) or ((1447 + 582) >= (322 + 3199))) then
					if (v26(v88.ColdBlood, v65) or ((2759 - (478 + 244)) >= (5159 - (440 + 77)))) then
						return "Cast Cold Blood";
					end
				end
				if (((783 + 937) < (16316 - 11858)) and v38 and v88.Sepsis:IsAvailable() and v88.Sepsis:IsReady()) then
					if ((v119() and v14:FilteredTimeToDie(">=", 1572 - (655 + 901)) and (v13:BuffUp(v88.PerforatedVeins) or not v88.PerforatedVeins:IsAvailable())) or ((81 + 355) > (2313 + 708))) then
						if (((482 + 231) <= (3412 - 2565)) and v26(v88.Sepsis)) then
							return "Cast Sepsis";
						end
					end
				end
				if (((3599 - (695 + 750)) <= (13764 - 9733)) and v38 and v88.Flagellation:IsAvailable() and v88.Flagellation:IsReady()) then
					if (((7121 - 2506) == (18560 - 13945)) and v119() and (v106 >= (356 - (285 + 66))) and (v14:TimeToDie() > (23 - 13)) and ((v127() and (v88.ShadowBlades:CooldownRemains() <= (1313 - (682 + 628)))) or v10.BossFilteredFightRemains("<=", 5 + 23) or ((v88.ShadowBlades:CooldownRemains() >= (313 - (176 + 123))) and v88.InvigoratingShadowdust:IsAvailable() and v88.ShadowDance:IsAvailable())) and (not v88.InvigoratingShadowdust:IsAvailable() or v88.Sepsis:IsAvailable() or not v88.ShadowDance:IsAvailable() or ((v88.InvigoratingShadowdust:TalentRank() == (1 + 1)) and (v98 >= (2 + 0))) or (v88.SymbolsofDeath:CooldownRemains() <= (272 - (239 + 30))) or (v13:BuffRemains(v88.SymbolsofDeath) > (1 + 2)))) then
						if (v26(v88.Flagellation) or ((3643 + 147) == (884 - 384))) then
							return "Cast Flagellation";
						end
					end
				end
				if (((277 - 188) < (536 - (306 + 9))) and v38 and v88.SymbolsofDeath:IsReady()) then
					if (((7167 - 5113) >= (248 + 1173)) and v119() and (not v13:BuffUp(v88.TheRotten) or not v13:HasTier(19 + 11, 1 + 1)) and (v13:BuffRemains(v88.SymbolsofDeath) <= (8 - 5)) and (not v88.Flagellation:IsAvailable() or (v88.Flagellation:CooldownRemains() > (1385 - (1140 + 235))) or ((v13:BuffRemains(v88.ShadowDance) >= (2 + 0)) and v88.InvigoratingShadowdust:IsAvailable()) or (v88.Flagellation:IsReady() and (v106 >= (5 + 0)) and not v88.InvigoratingShadowdust:IsAvailable()))) then
						if (((178 + 514) < (3110 - (33 + 19))) and v26(v88.SymbolsofDeath)) then
							return "Cast Symbols of Death";
						end
					end
				end
				v215 = 1 + 0;
			end
			if ((v215 == (5 - 3)) or ((1434 + 1820) == (3245 - 1590))) then
				if ((v38 and v88.ShadowDance:IsAvailable() and v113() and v88.ShadowDance:IsReady()) or ((1216 + 80) == (5599 - (586 + 103)))) then
					if (((307 + 3061) == (10368 - 7000)) and not v13:BuffUp(v88.ShadowDance) and v10.BossFilteredFightRemains("<=", (1496 - (1309 + 179)) + ((5 - 2) * v29(v88.Subterfuge:IsAvailable())))) then
						if (((1151 + 1492) < (10245 - 6430)) and v26(v88.ShadowDance)) then
							return "Cast Shadow Dance";
						end
					end
				end
				if (((1445 + 468) > (1047 - 554)) and v38 and v88.GoremawsBite:IsAvailable() and v88.GoremawsBite:IsReady()) then
					if (((9474 - 4719) > (4037 - (295 + 314))) and v119() and (v108 >= (6 - 3)) and (not v88.ShadowDance:IsReady() or (v88.ShadowDance:IsAvailable() and v13:BuffUp(v88.ShadowDance) and not v88.InvigoratingShadowdust:IsAvailable()) or ((v98 < (1966 - (1300 + 662))) and not v88.InvigoratingShadowdust:IsAvailable()) or v88.TheRotten:IsAvailable())) then
						if (((4336 - 2955) <= (4124 - (1178 + 577))) and v26(v88.GoremawsBite)) then
							return "Cast Goremaw's Bite";
						end
					end
				end
				if (v88.ThistleTea:IsReady() or ((2516 + 2327) == (12073 - 7989))) then
					if (((6074 - (851 + 554)) > (321 + 42)) and ((((v88.SymbolsofDeath:CooldownRemains() >= (8 - 5)) or v13:BuffUp(v88.SymbolsofDeath)) and not v13:BuffUp(v88.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (217 - 117)) and ((v108 >= (304 - (115 + 187))) or (v98 >= (3 + 0)))) or ((v88.ThistleTea:ChargesFractional() >= ((2.75 + 0) - ((0.15 - 0) * v88.InvigoratingShadowdust:TalentRank()))) and v88.Vanish:IsReady() and v13:BuffUp(v88.ShadowDance) and v14:DebuffUp(v88.Rupture) and (v98 < (1164 - (160 + 1001)))))) or ((v13:BuffRemains(v88.ShadowDance) >= (4 + 0)) and not v13:BuffUp(v88.ThistleTea) and (v98 >= (3 + 0))) or (not v13:BuffUp(v88.ThistleTea) and v10.BossFilteredFightRemains("<=", (11 - 5) * v88.ThistleTea:Charges())))) then
						if (v26(v88.ThistleTea) or ((2235 - (237 + 121)) >= (4035 - (525 + 372)))) then
							return "Thistle Tea";
						end
					end
				end
				v216 = v13:BuffUp(v88.ShadowBlades) or (not v88.ShadowBlades:IsAvailable() and v13:BuffUp(v88.SymbolsofDeath)) or v10.BossFilteredFightRemains("<", 37 - 17);
				v215 = 9 - 6;
			end
			if (((4884 - (96 + 46)) >= (4403 - (643 + 134))) and (v215 == (1 + 0))) then
				if ((v38 and v88.ShadowBlades:IsReady()) or ((10885 - 6345) == (3400 - 2484))) then
					if ((v119() and ((v106 <= (1 + 0)) or v13:HasTier(60 - 29, 7 - 3)) and (v13:BuffUp(v88.Flagellation) or v13:BuffUp(v88.FlagellationPersistBuff) or not v88.Flagellation:IsAvailable())) or ((1875 - (316 + 403)) > (2889 + 1456))) then
						if (((6150 - 3913) < (1536 + 2713)) and v26(v88.ShadowBlades)) then
							return "Cast Shadow Blades";
						end
					end
				end
				if ((v38 and v88.EchoingReprimand:IsCastable() and v88.EchoingReprimand:IsAvailable()) or ((6756 - 4073) < (17 + 6))) then
					if (((225 + 472) <= (2861 - 2035)) and v119() and (v108 >= (14 - 11))) then
						if (((2295 - 1190) <= (68 + 1108)) and v26(v88.EchoingReprimand)) then
							return "Cast Echoing Reprimand";
						end
					end
				end
				if (((6651 - 3272) <= (187 + 3625)) and v38 and v88.ShurikenTornado:IsAvailable() and v88.ShurikenTornado:IsReady()) then
					if ((v119() and v13:BuffUp(v88.SymbolsofDeath) and (v106 <= (5 - 3)) and not v13:BuffUp(v88.Premeditation) and (not v88.Flagellation:IsAvailable() or (v88.Flagellation:CooldownRemains() > (37 - (12 + 5)))) and (v98 >= (11 - 8))) or ((1681 - 893) >= (3434 - 1818))) then
						if (((4597 - 2743) <= (686 + 2693)) and v26(v88.ShurikenTornado)) then
							return "Cast Shuriken Tornado";
						end
					end
				end
				if (((6522 - (1656 + 317)) == (4054 + 495)) and v38 and v88.ShurikenTornado:IsAvailable() and v88.ShurikenTornado:IsReady()) then
					if ((v119() and not v13:BuffUp(v88.ShadowDance) and not v13:BuffUp(v88.Flagellation) and not v13:BuffUp(v88.FlagellationPersistBuff) and not v13:BuffUp(v88.ShadowBlades) and (v98 <= (2 + 0))) or ((8035 - 5013) >= (14882 - 11858))) then
						if (((5174 - (5 + 349)) > (10440 - 8242)) and v26(v88.ShurikenTornado)) then
							return "Cast Shuriken Tornado";
						end
					end
				end
				v215 = 1273 - (266 + 1005);
			end
			if ((v215 == (2 + 1)) or ((3620 - 2559) >= (6439 - 1548))) then
				if (((3060 - (561 + 1135)) <= (5828 - 1355)) and v88.BloodFury:IsCastable() and v216) then
					if (v26(v88.BloodFury, v61) or ((11817 - 8222) <= (1069 - (507 + 559)))) then
						return "Cast Blood Fury";
					end
				end
				if (v88.Berserking:IsCastable() or ((11723 - 7051) == (11912 - 8060))) then
					if (((1947 - (212 + 176)) == (2464 - (250 + 655))) and v10.Cast(v88.Berserking, v61)) then
						return "Cast Berserking";
					end
				end
				if (v88.Fireblood:IsCastable() or ((4777 - 3025) <= (1376 - 588))) then
					if (v10.Cast(v88.Fireblood, v61) or ((6112 - 2205) == (2133 - (1869 + 87)))) then
						return "Cast Fireblood";
					end
				end
				if (((12035 - 8565) > (2456 - (484 + 1417))) and v88.AncestralCall:IsCastable()) then
					if (v10.Cast(v88.AncestralCall, v61) or ((2083 - 1111) == (1080 - 435))) then
						return "Cast Ancestral Call";
					end
				end
				v215 = 777 - (48 + 725);
			end
			if (((5197 - 2015) >= (5674 - 3559)) and ((3 + 1) == v215)) then
				if (((10403 - 6510) < (1240 + 3189)) and v53 and v38) then
					local v243 = 0 + 0;
					while true do
						if ((v243 == (853 - (152 + 701))) or ((4178 - (430 + 881)) < (730 + 1175))) then
							v100 = v131();
							if (v100 or ((2691 - (557 + 338)) >= (1198 + 2853))) then
								return v100;
							end
							break;
						end
					end
				end
				return false;
			end
		end
	end
	local function v133(v217)
		local v218 = 0 - 0;
		while true do
			if (((5669 - 4050) <= (9978 - 6222)) and (v218 == (2 - 1))) then
				return false;
			end
			if (((1405 - (499 + 302)) == (1470 - (39 + 827))) and (v218 == (0 - 0))) then
				if ((v38 and not (v86.IsSoloMode() and v13:IsTanking(v14))) or ((10013 - 5529) == (3574 - 2674))) then
					local v244 = 0 - 0;
					while true do
						if ((v244 == (1 + 0)) or ((13050 - 8591) <= (179 + 934))) then
							if (((5746 - 2114) > (3502 - (103 + 1))) and v88.Shadowmeld:IsCastable() and v94 and not v13:IsMoving() and (v13:EnergyPredicted() >= (594 - (475 + 79))) and (v13:EnergyDeficitPredicted() >= (21 - 11)) and not v117() and (v108 > (12 - 8))) then
								local v266 = 0 + 0;
								while true do
									if (((3593 + 489) <= (6420 - (1395 + 108))) and ((0 - 0) == v266)) then
										v100 = v130(v88.Shadowmeld, v217);
										if (((6036 - (7 + 1197)) >= (605 + 781)) and v100) then
											return "Shadowmeld Macro " .. v100;
										end
										break;
									end
								end
							end
							break;
						end
						if (((48 + 89) == (456 - (27 + 292))) and (v244 == (0 - 0))) then
							if (v88.Vanish:IsCastable() or ((2002 - 432) >= (18167 - 13835))) then
								if ((((v108 > (1 - 0)) or (v13:BuffUp(v88.ShadowBlades) and v88.InvigoratingShadowdust:IsAvailable())) and not v117() and ((v88.Flagellation:CooldownRemains() >= (114 - 54)) or not v88.Flagellation:IsAvailable() or v10.BossFilteredFightRemains("<=", (169 - (43 + 96)) * v88.Vanish:Charges())) and ((v88.SymbolsofDeath:CooldownRemains() > (12 - 9)) or not v13:HasTier(67 - 37, 2 + 0)) and ((v88.SecretTechnique:CooldownRemains() >= (3 + 7)) or not v88.SecretTechnique:IsAvailable() or ((v88.Vanish:Charges() >= (3 - 1)) and v88.InvigoratingShadowdust:IsAvailable() and (v13:BuffUp(v88.TheRotten) or not v88.TheRotten:IsAvailable())))) or ((1558 + 2506) <= (3408 - 1589))) then
									local v270 = 0 + 0;
									while true do
										if ((v270 == (0 + 0)) or ((6737 - (1414 + 337)) < (3514 - (1642 + 298)))) then
											v100 = v130(v88.Vanish, v217);
											if (((11537 - 7111) > (494 - 322)) and v100) then
												return "Vanish Macro " .. v100;
											end
											break;
										end
									end
								end
							end
							if (((1738 - 1152) > (150 + 305)) and (v13:Energy() < (32 + 8)) and v88.Shadowmeld:IsCastable()) then
								if (((1798 - (357 + 615)) == (580 + 246)) and v26(v88.Shadowmeld, v13:EnergyTimeToX(98 - 58))) then
									return "Pool for Shadowmeld";
								end
							end
							v244 = 1 + 0;
						end
					end
				end
				if ((v94 and v88.ShadowDance:IsCastable()) or ((8612 - 4593) > (3552 + 889))) then
					if (((138 + 1879) < (2679 + 1582)) and (v14:DebuffUp(v88.Rupture) or v88.InvigoratingShadowdust:IsAvailable()) and v125() and (not v88.TheFirstDance:IsAvailable() or (v108 >= (1305 - (384 + 917))) or v13:BuffUp(v88.ShadowBlades)) and ((v118() and v117()) or ((v13:BuffUp(v88.ShadowBlades) or (v13:BuffUp(v88.SymbolsofDeath) and not v88.Sepsis:IsAvailable()) or ((v13:BuffRemains(v88.SymbolsofDeath) >= (701 - (128 + 569))) and not v13:HasTier(1573 - (1407 + 136), 1889 - (687 + 1200))) or (not v13:BuffUp(v88.SymbolsofDeath) and v13:HasTier(1740 - (556 + 1154), 6 - 4))) and (v88.SecretTechnique:CooldownRemains() < ((105 - (9 + 86)) + ((433 - (275 + 146)) * v29(not v88.InvigoratingShadowdust:IsAvailable() or v13:HasTier(5 + 25, 66 - (29 + 35))))))))) then
						local v256 = 0 - 0;
						while true do
							if (((14086 - 9370) > (353 - 273)) and (v256 == (0 + 0))) then
								v100 = v130(v88.ShadowDance, v217);
								if (v100 or ((4519 - (53 + 959)) == (3680 - (312 + 96)))) then
									return "ShadowDance Macro 1 " .. v100;
								end
								break;
							end
						end
					end
				end
				v218 = 1 - 0;
			end
		end
	end
	local function v134(v219)
		local v220 = 285 - (147 + 138);
		local v221;
		while true do
			if (((899 - (813 + 86)) == v220) or ((792 + 84) >= (5696 - 2621))) then
				v221 = not v219 or (v13:EnergyPredicted() >= v219);
				if (((4844 - (18 + 474)) > (862 + 1692)) and v37 and v88.ShurikenStorm:IsCastable() and (v98 >= ((6 - 4) + v21((v88.Gloomblade:IsAvailable() and (v13:BuffRemains(v88.LingeringShadowBuff) >= (1092 - (860 + 226)))) or v13:BuffUp(v88.PerforatedVeinsBuff))))) then
					local v245 = 303 - (121 + 182);
					while true do
						if ((v245 == (0 + 0)) or ((5646 - (988 + 252)) < (457 + 3586))) then
							if ((v221 and v10.Cast(v88.ShurikenStorm)) or ((592 + 1297) >= (5353 - (49 + 1921)))) then
								return "Cast Shuriken Storm";
							end
							v111(v88.ShurikenStorm, v219);
							break;
						end
					end
				end
				v220 = 891 - (223 + 667);
			end
			if (((1944 - (51 + 1)) <= (4705 - 1971)) and (v220 == (1 - 0))) then
				if (((3048 - (146 + 979)) < (626 + 1592)) and v94) then
					if (((2778 - (311 + 294)) > (1056 - 677)) and v88.Gloomblade:IsCastable()) then
						local v257 = 0 + 0;
						while true do
							if ((v257 == (1443 - (496 + 947))) or ((3949 - (1233 + 125)) == (1384 + 2025))) then
								if (((4050 + 464) > (632 + 2692)) and v221 and v26(v88.Gloomblade)) then
									return "Cast Gloomblade";
								end
								v111(v88.Gloomblade, v219);
								break;
							end
						end
					elseif (v88.Backstab:IsCastable() or ((1853 - (963 + 682)) >= (4030 + 798))) then
						local v264 = 1504 - (504 + 1000);
						while true do
							if (((0 + 0) == v264) or ((1442 + 141) > (337 + 3230))) then
								if ((v221 and v26(v88.Backstab)) or ((1935 - 622) == (679 + 115))) then
									return "Cast Backstab";
								end
								v111(v88.Backstab, v219);
								break;
							end
						end
					end
				end
				return false;
			end
		end
	end
	local function v135()
		v85();
		v36 = EpicSettings.Toggles['ooc'];
		v37 = EpicSettings.Toggles['aoe'];
		v38 = EpicSettings.Toggles['cds'];
		ToggleMain = EpicSettings.Toggles['toggle'];
		v101 = nil;
		v103 = nil;
		v102 = 0 + 0;
		v92 = (v88.AcrobaticStrikes:IsAvailable() and (190 - (156 + 26))) or (3 + 2);
		v93 = (v88.AcrobaticStrikes:IsAvailable() and (19 - 6)) or (174 - (149 + 15));
		v94 = v14:IsInMeleeRange(v92);
		v95 = v14:IsInMeleeRange(v93);
		if (((4134 - (890 + 70)) > (3019 - (39 + 78))) and v37) then
			local v230 = 482 - (14 + 468);
			while true do
				if (((9059 - 4939) <= (11906 - 7646)) and (v230 == (0 + 0))) then
					v96 = v13:GetEnemiesInRange(19 + 11);
					v97 = v13:GetEnemiesInMeleeRange(v93);
					v230 = 1 + 0;
				end
				if ((v230 == (1 + 0)) or ((232 + 651) > (9145 - 4367))) then
					v98 = #v97;
					v99 = v13:GetEnemiesInMeleeRange(v92);
					break;
				end
			end
		else
			v96 = {};
			v97 = {};
			v98 = 1 + 0;
			v99 = {};
		end
		v107 = v13:ComboPoints();
		v106 = v87.EffectiveComboPoints(v107);
		v108 = v13:ComboPointsDeficit();
		v110 = v114();
		v109 = v13:EnergyMax() - v116();
		if (((v106 > v107) and (v108 > (6 - 4)) and v13:AffectingCombat()) or ((92 + 3528) >= (4942 - (12 + 39)))) then
			if (((3962 + 296) > (2900 - 1963)) and (((v107 == (6 - 4)) and not v13:BuffUp(v88.EchoingReprimand3)) or ((v107 == (1 + 2)) and not v13:BuffUp(v88.EchoingReprimand4)) or ((v107 == (3 + 1)) and not v13:BuffUp(v88.EchoingReprimand5)))) then
				local v238 = 0 - 0;
				local v239;
				while true do
					if ((v238 == (1 + 0)) or ((23530 - 18661) < (2616 - (1596 + 114)))) then
						if ((v239 < (v34(v13:EnergyTimeToX(91 - 56), v13:GCDRemains()) + (713.5 - (164 + 549)))) or ((2663 - (1059 + 379)) > (5249 - 1021))) then
							v106 = v107;
						end
						break;
					end
					if (((1725 + 1603) > (378 + 1860)) and (v238 == (392 - (145 + 247)))) then
						v239 = v87.TimeToSht(4 + 0);
						if (((1774 + 2065) > (4165 - 2760)) and (v239 == (0 + 0))) then
							v239 = v87.TimeToSht(5 + 0);
						end
						v238 = 1 - 0;
					end
				end
			end
		end
		if ((v13:BuffUp(v88.ShurikenTornado, nil, true) and (v107 < v87.CPMaxSpend())) or ((2013 - (254 + 466)) <= (1067 - (544 + 16)))) then
			local v231 = 0 - 0;
			local v232;
			while true do
				if ((v231 == (628 - (294 + 334))) or ((3149 - (236 + 17)) < (348 + 457))) then
					v232 = v87.TimeToNextTornado();
					if (((1803 + 513) == (8722 - 6406)) and ((v232 <= v13:GCDRemains()) or (v35(v13:GCDRemains() - v232) < (0.25 - 0)))) then
						local v258 = v98 + v29(v13:BuffUp(v88.ShadowBlades));
						v107 = v33(v107 + v258, v87.CPMaxSpend());
						v108 = v34(v108 - v258, 0 + 0);
						if ((v106 < v87.CPMaxSpend()) or ((2117 + 453) == (2327 - (413 + 381)))) then
							v106 = v107;
						end
					end
					break;
				end
			end
		end
		v104 = (1 + 3 + (v106 * (8 - 4))) * (0.3 - 0);
		v105 = v88.Eviscerate:Damage() * v29(v74);
		if ((v89.Healthstone:IsReady() and (v13:HealthPercentage() < v44) and not (v13:IsChanneling() or v13:IsCasting())) or ((2853 - (582 + 1388)) == (2487 - 1027))) then
			if (v10.Cast(v90.Healthstone) or ((3307 + 1312) <= (1363 - (326 + 38)))) then
				return "Healthstone ";
			end
		end
		if ((v89.RefreshingHealingPotion:IsReady() and (v13:HealthPercentage() < v42) and not (v13:IsChanneling() or v13:IsCasting())) or ((10087 - 6677) > (5875 - 1759))) then
			if (v10.Cast(v90.RefreshingHealingPotion) or ((1523 - (47 + 573)) >= (1079 + 1980))) then
				return "RefreshingHealingPotion ";
			end
		end
		v100 = v87.CrimsonVial();
		if (v100 or ((16886 - 12910) < (4636 - 1779))) then
			return v100;
		end
		v87.Poisons();
		if (((6594 - (1269 + 395)) > (2799 - (76 + 416))) and not v13:AffectingCombat()) then
			local v233 = 443 - (319 + 124);
			while true do
				if ((v233 == (2 - 1)) or ((5053 - (564 + 443)) < (3573 - 2282))) then
					if (v86.TargetIsValid() or ((4699 - (337 + 121)) == (10387 - 6842))) then
						if ((v15:Exists() and v88.TricksoftheTrade:IsReady()) or ((13484 - 9436) > (6143 - (1261 + 650)))) then
							if (v26(v90.TricksoftheTradeFocus) or ((741 + 1009) >= (5534 - 2061))) then
								return "precombat tricks_of_the_trade";
							end
						end
					end
					break;
				end
				if (((4983 - (772 + 1045)) == (447 + 2719)) and (v233 == (144 - (102 + 42)))) then
					v100 = v87.Poisons();
					if (((3607 - (1524 + 320)) < (4994 - (1049 + 221))) and v100) then
						return v100;
					end
					v233 = 157 - (18 + 138);
				end
			end
		end
		if (((139 - 82) <= (3825 - (67 + 1035))) and not v13:AffectingCombat() and not v13:IsMounted() and v86.TargetIsValid()) then
			v100 = v87.Stealth(v88.Stealth2, nil);
			if (v100 or ((2418 - (136 + 212)) == (1882 - 1439))) then
				return "Stealth (OOC): " .. v100;
			end
		end
		if ((not v13:IsChanneling() and ToggleMain) or ((2168 + 537) == (1285 + 108))) then
			local v234 = 1604 - (240 + 1364);
			while true do
				if ((v234 == (1083 - (1050 + 32))) or ((16428 - 11827) < (37 + 24))) then
					if ((v88.ShurikenToss:IsCastable() and v14:IsInRange(1085 - (331 + 724)) and not v95 and not v13:StealthUp(true, true) and not v13:BuffUp(v88.Sprint) and (v13:EnergyDeficitPredicted() < (2 + 18)) and ((v108 >= (645 - (269 + 375))) or (v13:EnergyTimeToMax() <= (726.2 - (267 + 458))))) or ((433 + 957) >= (9122 - 4378))) then
						if (v26(v88.ShurikenToss) or ((2821 - (667 + 151)) > (5331 - (1410 + 87)))) then
							return "Cast Shuriken Toss";
						end
					end
					break;
				end
				if ((v234 == (1897 - (1504 + 393))) or ((421 - 265) > (10151 - 6238))) then
					if (((991 - (461 + 335)) == (25 + 170)) and not v13:AffectingCombat() and v14:AffectingCombat() and (v88.Vanish:TimeSinceLastCast() > (1762 - (1730 + 31)))) then
						local v259 = 1667 - (728 + 939);
						while true do
							if (((10996 - 7891) >= (3642 - 1846)) and (v259 == (0 - 0))) then
								if (((5447 - (138 + 930)) >= (1948 + 183)) and v86.TargetIsValid() and (v14:IsSpellInRange(v88.Shadowstrike) or v94)) then
									if (((3006 + 838) >= (1751 + 292)) and v13:StealthUp(true, true)) then
										v101 = v129(true);
									elseif ((v107 >= (20 - 15)) or ((4998 - (459 + 1307)) <= (4601 - (474 + 1396)))) then
										local v277 = 0 - 0;
										while true do
											if (((4597 + 308) == (17 + 4888)) and (v277 == (0 - 0))) then
												v100 = v128();
												if (v100 or ((525 + 3611) >= (14725 - 10314))) then
													return v100 .. " (OOC)";
												end
												break;
											end
										end
									end
								end
								return;
							end
						end
					end
					if ((v86.TargetIsValid() and (v36 or v13:AffectingCombat())) or ((12900 - 9942) == (4608 - (562 + 29)))) then
						local v260 = 0 + 0;
						local v261;
						while true do
							if (((2647 - (374 + 1045)) >= (644 + 169)) and ((0 - 0) == v260)) then
								if ((v84 and v88.Shiv:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v86.UnitHasEnrageBuff(v14)) or ((4093 - (448 + 190)) > (1308 + 2742))) then
									if (((110 + 133) == (159 + 84)) and v26(v88.Shiv, not v94)) then
										return "dispel";
									end
								end
								if (((v10.CombatTime() < (38 - 28)) and (v10.CombatTime() > (0 - 0)) and v88.ShadowDance:CooldownUp() and (v88.Vanish:TimeSinceLastCast() > (1505 - (1307 + 187)))) or ((1074 - 803) > (3680 - 2108))) then
									local v271 = 0 - 0;
									while true do
										if (((3422 - (232 + 451)) < (3145 + 148)) and (v271 == (3 + 0))) then
											if ((v88.ShadowDance:IsCastable() and v38 and v10.Cast(v90.ShadowDance, true)) or ((4506 - (510 + 54)) < (2284 - 1150))) then
												return "Opener ShadowDance";
											end
											break;
										end
										if ((v271 == (38 - (13 + 23))) or ((5248 - 2555) == (7144 - 2171))) then
											if (((3898 - 1752) == (3234 - (830 + 258))) and (v88.Gloomblade:TimeSinceLastCast() > (10 - 7)) and (v98 <= (1 + 0))) then
												if (v10.Cast(v88.Gloomblade) or ((1910 + 334) == (4665 - (860 + 581)))) then
													return "Opener Gloomblade";
												end
											end
											if ((v14:DebuffDown(v88.Rupture) and (v98 <= (3 - 2)) and (v107 > (0 + 0))) or ((5145 - (237 + 4)) <= (4502 - 2586))) then
												if (((227 - 137) <= (2019 - 954)) and v10.Cast(v88.Rupture)) then
													return "Opener Rupture";
												end
											end
											v271 = 3 + 0;
										end
										if (((2758 + 2044) == (18129 - 13327)) and (v271 == (0 + 0))) then
											if (v13:StealthUp(true, true) or ((1241 + 1039) <= (1937 - (85 + 1341)))) then
												if (v10.Cast(v88.Shadowstrike) or ((2859 - 1183) <= (1307 - 844))) then
													return "Opener SS";
												end
											end
											if (((4241 - (45 + 327)) == (7300 - 3431)) and v88.SymbolsofDeath:IsCastable() and v13:BuffDown(v88.SymbolsofDeath)) then
												if (((1660 - (444 + 58)) <= (1136 + 1477)) and v10.Cast(v88.SymbolsofDeath, true)) then
													return "Opener SymbolsofDeath";
												end
											end
											v271 = 1 + 0;
										end
										if ((v271 == (1 + 0)) or ((6850 - 4486) <= (3731 - (64 + 1668)))) then
											if ((v88.ShadowBlades:IsCastable() and v13:BuffDown(v88.ShadowBlades)) or ((6895 - (1227 + 746)) < (596 - 402))) then
												if (v10.Cast(v88.ShadowBlades, true) or ((3880 - 1789) < (525 - (415 + 79)))) then
													return "Opener ShadowBlades";
												end
											end
											if ((v88.ShurikenStorm:IsCastable() and (v98 >= (1 + 1))) or ((2921 - (142 + 349)) >= (2088 + 2784))) then
												if (v10.Cast(v88.ShurikenStorm) or ((6558 - 1788) < (863 + 872))) then
													return "Opener Shuriken Tornado";
												end
											end
											v271 = 2 + 0;
										end
									end
								end
								v100 = v132();
								if (v100 or ((12088 - 7649) <= (4214 - (1710 + 154)))) then
									return "CDs: " .. v100;
								end
								v260 = 319 - (200 + 118);
							end
							if (((2 + 1) == v260) or ((7830 - 3351) < (6623 - 2157))) then
								v100 = v134(v109);
								if (((2264 + 283) > (1212 + 13)) and v100) then
									return "Build: " .. v100;
								end
								if (((2507 + 2164) > (428 + 2246)) and v38) then
									local v272 = 0 - 0;
									while true do
										if ((v272 == (1251 - (363 + 887))) or ((6453 - 2757) < (15835 - 12508))) then
											if (v88.LightsJudgment:IsReady() or ((702 + 3840) == (6949 - 3979))) then
												if (((173 + 79) <= (3641 - (674 + 990))) and v26(v88.LightsJudgment, v39)) then
													return "Cast Lights Judgment";
												end
											end
											if (v88.BagofTricks:IsReady() or ((412 + 1024) == (1545 + 2230))) then
												if (v26(v88.BagofTricks, v39) or ((2564 - 946) < (1985 - (507 + 548)))) then
													return "Cast Bag of Tricks";
												end
											end
											break;
										end
										if (((5560 - (289 + 548)) > (5971 - (821 + 997))) and (v272 == (255 - (195 + 60)))) then
											if ((v88.ArcaneTorrent:IsReady() and v94 and (v13:EnergyDeficitPredicted() >= (5 + 10 + v13:EnergyRegen()))) or ((5155 - (251 + 1250)) >= (13633 - 8979))) then
												if (((654 + 297) <= (2528 - (809 + 223))) and v26(v88.ArcaneTorrent, v39)) then
													return "Cast Arcane Torrent";
												end
											end
											if ((v88.ArcanePulse:IsReady() and v94) or ((2533 - 797) == (1714 - 1143))) then
												if (v26(v88.ArcanePulse, v39) or ((2962 - 2066) > (3512 + 1257))) then
													return "Cast Arcane Pulse";
												end
											end
											v272 = 1 + 0;
										end
									end
								end
								if (v103 or ((1662 - (14 + 603)) <= (1149 - (118 + 11)))) then
									v111(v103);
								end
								break;
							end
							if ((v260 == (1 + 0)) or ((967 + 193) <= (955 - 627))) then
								if (((4757 - (551 + 398)) > (1848 + 1076)) and v88.SliceandDice:IsCastable() and (v98 < v87.CPMaxSpend()) and (v13:BuffRemains(v88.SliceandDice) < v13:GCD()) and v10.BossFilteredFightRemains(">", 3 + 3) and (v107 >= (4 + 0))) then
									local v273 = 0 - 0;
									while true do
										if (((8965 - 5074) < (1595 + 3324)) and ((0 - 0) == v273)) then
											if ((v88.SliceandDice:IsReady() and v26(v88.SliceandDice)) or ((617 + 1617) <= (1591 - (40 + 49)))) then
												return "Cast Slice and Dice (Low Duration)";
											end
											v112(v88.SliceandDice);
											break;
										end
									end
								end
								if (v13:StealthUp(true, true) or ((9566 - 7054) < (922 - (99 + 391)))) then
									local v274 = 0 + 0;
									while true do
										if (((0 - 0) == v274) or ((4576 - 2728) == (843 + 22))) then
											v101 = v129(true);
											if (v101 or ((12319 - 7637) <= (6145 - (1032 + 572)))) then
												if (v26(v101) or ((3443 - (203 + 214)) >= (5863 - (568 + 1249)))) then
													return "Stealthed Tornado Cast  " .. v101:Name();
												end
											end
											v274 = 1 + 0;
										end
										if (((4822 - 2814) > (2464 - 1826)) and (v274 == (1307 - (913 + 393)))) then
											v26(v88.PoolEnergy);
											return "Stealthed Pooling";
										end
									end
								end
								v261 = nil;
								if (((5012 - 3237) <= (4567 - 1334)) and (not v88.Vigor:IsAvailable() or v88.Shadowcraft:IsAvailable())) then
									v261 = v13:EnergyDeficitPredicted() <= v116();
								else
									v261 = v13:EnergyPredicted() >= v116();
								end
								v260 = 412 - (269 + 141);
							end
							if (((4 - 2) == v260) or ((6524 - (362 + 1619)) == (3622 - (950 + 675)))) then
								if (v261 or v88.InvigoratingShadowdust:IsAvailable() or ((1196 + 1906) < (1907 - (216 + 963)))) then
									v100 = v133(v109);
									if (((1632 - (485 + 802)) == (904 - (432 + 127))) and v100) then
										return "Stealth CDs: " .. v100;
									end
								end
								if ((v106 >= v87.CPMaxSpend()) or ((3900 - (1065 + 8)) < (210 + 168))) then
									local v275 = 1601 - (635 + 966);
									while true do
										if ((v275 == (0 + 0)) or ((3518 - (5 + 37)) < (6458 - 3861))) then
											v100 = v128();
											if (((1282 + 1797) < (7587 - 2793)) and v100) then
												return "Finish: " .. v100;
											end
											break;
										end
									end
								end
								if (((2272 + 2582) > (9275 - 4811)) and ((v108 <= (3 - 2)) or (v10.BossFilteredFightRemains("<=", 1 - 0) and (v106 >= (7 - 4))))) then
									local v276 = 0 + 0;
									while true do
										if ((v276 == (529 - (318 + 211))) or ((24169 - 19257) == (5345 - (963 + 624)))) then
											v100 = v128();
											if (((54 + 72) <= (4328 - (518 + 328))) and v100) then
												return "Finish: " .. v100;
											end
											break;
										end
									end
								end
								if (((v98 >= (8 - 4)) and (v106 >= (6 - 2))) or ((2691 - (301 + 16)) == (12819 - 8445))) then
									v100 = v128();
									if (((4423 - 2848) == (4109 - 2534)) and v100) then
										return "Finish: " .. v100;
									end
								end
								v260 = 3 + 0;
							end
						end
					end
					v234 = 1 + 0;
				end
			end
		end
	end
	local function v136()
		v10.Print("Subtlety Rogue rotation has NOT been updated for patch 10.2.0. It is unlikely to work properly at this time.");
	end
	v10.SetAPL(557 - 296, v135, v136);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

