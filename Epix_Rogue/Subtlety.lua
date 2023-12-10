local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((5944 - 2614) > (1212 - 556)) and not v5) then
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
	local v15 = v11.MouseOver;
	local v16 = v9.Spell;
	local v17 = v9.MultiSpell;
	local v18 = v9.Item;
	local v19 = v9.Utils;
	local v20 = v9.Utils.BoolToInt;
	local v21 = v9.AoEON;
	local v22 = v9.CDsON;
	local v23 = v9.Bind;
	local v24 = v9.Macro;
	local v25 = v9.Press;
	local v26 = v9.Cast;
	local v27 = v9.Commons.Everyone.num;
	local v28 = v9.Commons.Everyone.bool;
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
		v39 = EpicSettings.Settings['HealingPotionName'] or (611 - (466 + 145));
		v40 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v41 = EpicSettings.Settings['UseHealthstone'];
		v42 = EpicSettings.Settings['HealthstoneHP'] or (1151 - (255 + 896));
		v43 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v44 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
		v45 = EpicSettings.Settings['InterruptThreshold'] or (899 - (503 + 396));
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
	local v84 = v9.Commons.Everyone;
	local v85 = v9.Commons.Rogue;
	local v86 = v16.Rogue.Subtlety;
	local v87 = v18.Rogue.Subtlety;
	local v88 = v24.Rogue.Subtlety;
	local v89 = {v87.ManicGrieftorch:ID(),v87.BeaconToTheBeyond:ID(),v87.Mirror:ID()};
	local v90, v91, v92, v93;
	local v94, v95, v96, v97;
	local v98;
	local v99, v100, v101;
	local v102, v103;
	local v104, v105, v106, v107;
	local v108;
	v86.Eviscerate:RegisterDamageFormula(function()
		return v12:AttackPowerDamageMod() * v104 * (0.176 + 0) * (3.21 - 2) * ((v86.Nightstalker:IsAvailable() and v12:StealthUp(true, false) and (1.08 + 0)) or (2 - 1)) * ((v86.DeeperStratagem:IsAvailable() and (1.05 + 0)) or (1 + 0)) * ((v86.DarkShadow:IsAvailable() and v12:BuffUp(v86.ShadowDanceBuff) and (2.3 - 1)) or (1 + 0)) * ((v12:BuffUp(v86.SymbolsofDeath) and (1.1 - 0)) or (1245 - (485 + 759))) * ((v12:BuffUp(v86.FinalityEviscerateBuff) and (2.3 - 1)) or (1190 - (442 + 747))) * ((1136 - (832 + 303)) + (v12:MasteryPct() / (1046 - (88 + 858)))) * (1 + 0 + (v12:VersatilityDmgPct() / (83 + 17))) * ((v13:DebuffUp(v86.FindWeaknessDebuff) and (1.5 + 0)) or (790 - (766 + 23)));
	end);
	v86.Rupture:RegisterPMultiplier(function()
		return (v12:BuffUp(v86.FinalityRuptureBuff) and (4.3 - 3)) or (1 - 0);
	end);
	local function v109(v166, v167)
		if (not v99 or ((6565 - 4073) <= (1137 - 802))) then
			local v219 = 1073 - (1036 + 37);
			while true do
				if (((3065 + 1257) >= (4988 - 2426)) and (v219 == (0 + 0))) then
					v99 = v166;
					v100 = v167 or (1480 - (641 + 839));
					break;
				end
			end
		end
	end
	local function v110(v168)
		if (not v101 or ((4550 - (910 + 3)) >= (9610 - 5840))) then
			v101 = v168;
		end
	end
	local function v111()
		if (((v74 == "On Bosses not in Dungeons") and v12:IsInDungeonArea()) or ((4063 - (1466 + 218)) > (2104 + 2474))) then
			return false;
		elseif (((v74 ~= "Always") and not v13:IsInBossList()) or ((1631 - (556 + 592)) > (265 + 478))) then
			return false;
		else
			return true;
		end
	end
	local function v112()
		local v169 = 808 - (329 + 479);
		while true do
			if (((3308 - (174 + 680)) > (1985 - 1407)) and (v169 == (0 - 0))) then
				if (((664 + 266) < (5197 - (396 + 343))) and (v96 < (1 + 1))) then
					return false;
				elseif (((2139 - (29 + 1448)) <= (2361 - (135 + 1254))) and (v50 == "Always")) then
					return true;
				elseif (((16462 - 12092) == (20404 - 16034)) and (v50 == "On Bosses") and v13:IsInBossList()) then
					return true;
				elseif ((v50 == "Auto") or ((3174 + 1588) <= (2388 - (389 + 1138)))) then
					if (((v12:InstanceDifficulty() == (590 - (102 + 472))) and (v13:NPCID() == (131142 + 7825))) or ((783 + 629) == (3976 + 288))) then
						return true;
					elseif ((v13:NPCID() == (168514 - (320 + 1225))) or (v13:NPCID() == (297240 - 130269)) or (v13:NPCID() == (102163 + 64807)) or ((4632 - (157 + 1307)) < (4012 - (821 + 1038)))) then
						return true;
					elseif ((v13:NPCID() == (457738 - 274275)) or (v13:NPCID() == (20087 + 163584)) or ((8838 - 3862) < (496 + 836))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v113(v170, v171, v172, v173, v174)
		local v175 = 0 - 0;
		local v176;
		local v177;
		local v178;
		while true do
			if (((5654 - (834 + 192)) == (295 + 4333)) and (v175 == (1 + 0))) then
				for v227, v228 in v29(v173) do
					if (((v228:GUID() ~= v178) and v84.UnitIsCycleValid(v228, v177, -v228:DebuffRemains(v170)) and v171(v228)) or ((2 + 52) == (611 - 216))) then
						v176, v177 = v228, v228:TimeToDie();
					end
				end
				if (((386 - (300 + 4)) == (22 + 60)) and v176) then
					v9.Press(v176, v170);
				elseif (v49 or ((1520 - 939) < (644 - (112 + 250)))) then
					local v236 = 0 + 0;
					while true do
						if ((v236 == (2 - 1)) or ((2641 + 1968) < (1291 + 1204))) then
							if (((862 + 290) == (572 + 580)) and v176) then
								v9.Press(v176, v170);
							end
							break;
						end
						if (((1409 + 487) <= (4836 - (1001 + 413))) and (v236 == (0 - 0))) then
							v176, v177 = nil, v172;
							for v258, v259 in v29(v95) do
								if (((v259:GUID() ~= v178) and v84.UnitIsCycleValid(v259, v177, -v259:DebuffRemains(v170)) and v171(v259)) or ((1872 - (244 + 638)) > (2313 - (627 + 66)))) then
									v176, v177 = v259, v259:TimeToDie();
								end
							end
							v236 = 2 - 1;
						end
					end
				end
				break;
			end
			if ((v175 == (602 - (512 + 90))) or ((2783 - (1665 + 241)) > (5412 - (373 + 344)))) then
				v176, v177 = nil, v172;
				v178 = v13:GUID();
				v175 = 1 + 0;
			end
		end
	end
	local function v114()
		return 6 + 14 + (v86.Vigor:TalentRank() * (65 - 40)) + (v27(v86.ThistleTea:IsAvailable()) * (33 - 13)) + (v27(v86.Shadowcraft:IsAvailable()) * (1119 - (35 + 1064)));
	end
	local function v115()
		return v86.ShadowDance:ChargesFractional() >= (0.75 + 0 + v20(v86.ShadowDanceTalent:IsAvailable()));
	end
	local function v116()
		return v106 >= (6 - 3);
	end
	local function v117()
		return v12:BuffUp(v86.SliceandDice) or (v96 >= v85.CPMaxSpend());
	end
	local function v118()
		return v86.Premeditation:IsAvailable() and (v96 < (1 + 4));
	end
	local function v119(v179)
		return (v12:BuffUp(v86.ThistleTea) and (v96 == (1237 - (298 + 938)))) or (v179 and ((v96 == (1260 - (233 + 1026))) or (v13:DebuffUp(v86.Rupture) and (v96 >= (1668 - (636 + 1030))))));
	end
	local function v120()
		return (not v12:BuffUp(v86.TheRotten) or not v12:HasTier(16 + 14, 2 + 0)) and (not v86.ColdBlood:IsAvailable() or (v86.ColdBlood:CooldownRemains() < (2 + 2)) or (v86.ColdBlood:CooldownRemains() > (1 + 9)));
	end
	local function v121(v180)
		return v12:BuffUp(v86.ShadowDanceBuff) and (v180:TimeSinceLastCast() < v86.ShadowDance:TimeSinceLastCast());
	end
	local function v122()
		return ((v121(v86.Shadowstrike) or v121(v86.ShurikenStorm)) and (v121(v86.Eviscerate) or v121(v86.BlackPowder) or v121(v86.Rupture))) or not v86.DanseMacabre:IsAvailable();
	end
	local function v123()
		return (not v87.WitherbarksBranch:IsEquipped() and not v87.AshesoftheEmbersoul:IsEquipped()) or (not v87.WitherbarksBranch:IsEquipped() and (v87.WitherbarksBranch:CooldownRemains() <= (229 - (55 + 166)))) or (v87.WitherbarksBranch:IsEquipped() and (v87.WitherbarksBranch:CooldownRemains() <= (2 + 6))) or v87.BandolierOfTwistedBlades:IsEquipped() or v86.InvigoratingShadowdust:IsAvailable();
	end
	local function v124(v181, v182)
		local v183 = 0 + 0;
		local v184;
		local v185;
		local v186;
		local v187;
		local v188;
		local v189;
		local v190;
		while true do
			if (((10277 - 7586) >= (2148 - (36 + 261))) and (v183 == (6 - 2))) then
				if ((v86.BlackPowder:IsCastable() and not v108 and (v96 >= (1371 - (34 + 1334)))) or ((1148 + 1837) >= (3774 + 1082))) then
					if (((5559 - (1035 + 248)) >= (1216 - (20 + 1))) and v181) then
						return v86.BlackPowder;
					else
						local v237 = 0 + 0;
						while true do
							if (((3551 - (134 + 185)) <= (5823 - (549 + 584))) and (v237 == (685 - (314 + 371)))) then
								if ((v86.BlackPowder:IsReady() and v25(v86.BlackPowder)) or ((3075 - 2179) >= (4114 - (478 + 490)))) then
									return "Cast Black Powder";
								end
								v110(v86.BlackPowder);
								break;
							end
						end
					end
				end
				if (((1622 + 1439) >= (4130 - (786 + 386))) and v86.Eviscerate:IsCastable() and v92 and (v105 > (3 - 2))) then
					if (((4566 - (1055 + 324)) >= (1984 - (1093 + 247))) and v181) then
						return v86.Eviscerate;
					else
						local v238 = 0 + 0;
						while true do
							if (((68 + 576) <= (2794 - 2090)) and (v238 == (0 - 0))) then
								if (((2725 - 1767) > (2379 - 1432)) and v86.Eviscerate:IsReady() and v25(v86.Eviscerate)) then
									return "Cast Eviscerate";
								end
								v110(v86.Eviscerate);
								break;
							end
						end
					end
				end
				return false;
			end
			if (((1598 + 2894) >= (10224 - 7570)) and (v183 == (10 - 7))) then
				if (((2596 + 846) >= (3843 - 2340)) and v12:BuffUp(v86.FinalityRuptureBuff) and v184 and (v96 <= (692 - (364 + 324))) and not v121(v86.Rupture)) then
					if (v181 or ((8690 - 5520) <= (3512 - 2048))) then
						return v86.Rupture;
					else
						local v239 = 0 + 0;
						while true do
							if (((0 - 0) == v239) or ((7681 - 2884) == (13326 - 8938))) then
								if (((1819 - (1249 + 19)) <= (615 + 66)) and v86.Rupture:IsReady() and v9.Press(v86.Rupture)) then
									return "Cast Rupture Finality";
								end
								v110(v86.Rupture);
								break;
							end
						end
					end
				end
				if (((12755 - 9478) > (1493 - (686 + 400))) and v86.ColdBlood:IsReady() and v122() and v86.SecretTechnique:IsReady()) then
					if (((3684 + 1011) >= (1644 - (73 + 156))) and v63) then
						v9.Press(v86.ColdBlood);
					else
						local v240 = 0 + 0;
						while true do
							if ((v240 == (811 - (721 + 90))) or ((37 + 3175) <= (3064 - 2120))) then
								if (v181 or ((3566 - (224 + 246)) <= (2912 - 1114))) then
									return v86.ColdBlood;
								end
								if (((6512 - 2975) == (642 + 2895)) and v9.Press(v86.ColdBlood)) then
									return "Cast Cold Blood (SecTec)";
								end
								break;
							end
						end
					end
				end
				if (((92 + 3745) >= (1154 + 416)) and v86.SecretTechnique:IsReady()) then
					if ((v122() and (not v86.ColdBlood:IsAvailable() or (v63 and v86.ColdBlood:IsReady()) or v12:BuffUp(v86.ColdBlood) or (v188 > (v185 - (3 - 1))) or not v86.ImprovedShadowDance:IsAvailable())) or ((9817 - 6867) == (4325 - (203 + 310)))) then
						local v241 = 1993 - (1238 + 755);
						while true do
							if (((330 + 4393) >= (3852 - (709 + 825))) and (v241 == (0 - 0))) then
								if (v181 or ((2952 - 925) > (3716 - (196 + 668)))) then
									return v86.SecretTechnique;
								end
								if (v9.Press(v86.SecretTechnique) or ((4485 - 3349) > (8942 - 4625))) then
									return "Cast Secret Technique";
								end
								break;
							end
						end
					end
				end
				if (((5581 - (171 + 662)) == (4841 - (4 + 89))) and not v119(v184) and v86.Rupture:IsCastable()) then
					local v231 = 0 - 0;
					while true do
						if (((1361 + 2375) <= (20819 - 16079)) and (v231 == (0 + 0))) then
							if ((not v181 and v35 and not v108 and (v96 >= (1488 - (35 + 1451)))) or ((4843 - (28 + 1425)) <= (5053 - (941 + 1052)))) then
								local v255 = 0 + 0;
								local v256;
								while true do
									if ((v255 == (1514 - (822 + 692))) or ((1425 - 426) > (1269 + 1424))) then
										v256 = nil;
										function v256(v260)
											return v84.CanDoTUnit(v260, v103) and v260:DebuffRefreshable(v86.Rupture, v102);
										end
										v255 = 298 - (45 + 252);
									end
									if (((459 + 4) < (207 + 394)) and (v255 == (2 - 1))) then
										v113(v86.Rupture, v256, (435 - (114 + 319)) * v187, v97);
										break;
									end
								end
							end
							if ((v92 and (v13:DebuffRemains(v86.Rupture) < (v86.SymbolsofDeath:CooldownRemains() + (14 - 4))) and (v105 > (0 - 0)) and (v86.SymbolsofDeath:CooldownRemains() <= (4 + 1)) and v85.CanDoTUnit(v13, v103) and v13:FilteredTimeToDie(">", (7 - 2) + v86.SymbolsofDeath:CooldownRemains(), -v13:DebuffRemains(v86.Rupture))) or ((4573 - 2390) < (2650 - (556 + 1407)))) then
								if (((5755 - (741 + 465)) == (5014 - (170 + 295))) and v181) then
									return v86.Rupture;
								else
									if (((2462 + 2210) == (4292 + 380)) and v86.Rupture:IsReady() and v9.Cast(v86.Rupture)) then
										return "Cast Rupture 2";
									end
									v110(v86.Rupture);
								end
							end
							break;
						end
					end
				end
				v183 = 9 - 5;
			end
			if ((v183 == (0 + 0)) or ((2353 + 1315) < (224 + 171))) then
				v184 = v12:BuffUp(v86.ShadowDanceBuff);
				v185 = v12:BuffRemains(v86.ShadowDanceBuff);
				v186 = v12:BuffRemains(v86.SymbolsofDeath);
				v187 = v105;
				v183 = 1231 - (957 + 273);
			end
			if ((v183 == (1 + 1)) or ((1668 + 2498) == (1733 - 1278))) then
				if ((v182 and (v182:ID() == v86.Vanish:ID())) or ((11723 - 7274) == (8134 - 5471))) then
					v188 = v31(0 - 0, v86.ColdBlood:CooldownRemains() - ((1795 - (389 + 1391)) * v86.InvigoratingShadowdust:TalentRank()));
					v189 = v31(0 + 0, v86.SymbolsofDeath:CooldownRemains() - ((2 + 13) * v86.InvigoratingShadowdust:TalentRank()));
				end
				if ((v86.Rupture:IsCastable() and v86.Rupture:IsReady()) or ((9736 - 5459) < (3940 - (783 + 168)))) then
					if ((v13:DebuffDown(v86.Rupture) and (v13:TimeToDie() > (19 - 13))) or ((856 + 14) >= (4460 - (309 + 2)))) then
						if (((6792 - 4580) < (4395 - (1090 + 122))) and v181) then
							return v86.Rupture;
						else
							if (((1507 + 3139) > (10048 - 7056)) and v86.Rupture:IsReady() and v9.Press(v86.Rupture)) then
								return "Cast Rupture";
							end
							v110(v86.Rupture);
						end
					end
				end
				if (((982 + 452) < (4224 - (628 + 490))) and not v12:StealthUp(true, true) and not v118() and (v96 < (2 + 4)) and not v184 and v9.BossFilteredFightRemains(">", v12:BuffRemains(v86.SliceandDice)) and (v12:BuffRemains(v86.SliceandDice) < (((2 - 1) + v12:ComboPoints()) * (4.8 - 3)))) then
					if (((1560 - (431 + 343)) < (6105 - 3082)) and v181) then
						return v86.SliceandDice;
					else
						local v242 = 0 - 0;
						while true do
							if ((v242 == (0 + 0)) or ((313 + 2129) < (1769 - (556 + 1139)))) then
								if (((4550 - (6 + 9)) == (831 + 3704)) and v86.SliceandDice:IsReady() and v9.Press(v86.SliceandDice)) then
									return "Cast Slice and Dice Premed";
								end
								v110(v86.SliceandDice);
								break;
							end
						end
					end
				end
				if (((not v119(v184) or v108) and (v13:TimeToDie() > (4 + 2)) and v13:DebuffRefreshable(v86.Rupture, v102)) or ((3178 - (28 + 141)) <= (816 + 1289))) then
					if (((2258 - 428) < (2599 + 1070)) and v181) then
						return v86.Rupture;
					else
						if ((v86.Rupture:IsReady() and v9.Press(v86.Rupture)) or ((2747 - (486 + 831)) >= (9399 - 5787))) then
							return "Cast Rupture";
						end
						v110(v86.Rupture);
					end
				end
				v183 = 10 - 7;
			end
			if (((507 + 2176) >= (7778 - 5318)) and (v183 == (1264 - (668 + 595)))) then
				v188 = v86.ColdBlood:CooldownRemains();
				v189 = v86.SymbolsofDeath:CooldownRemains();
				v190 = v12:BuffUp(v86.PremeditationBuff) or (v182 and v86.Premeditation:IsAvailable());
				if ((v182 and (v182:ID() == v86.ShadowDance:ID())) or ((1624 + 180) >= (661 + 2614))) then
					local v232 = 0 - 0;
					while true do
						if ((v232 == (290 - (23 + 267))) or ((3361 - (1129 + 815)) > (4016 - (371 + 16)))) then
							v184 = true;
							v185 = (1758 - (1326 + 424)) + v86.ImprovedShadowDance:TalentRank();
							v232 = 1 - 0;
						end
						if (((17522 - 12727) > (520 - (88 + 30))) and (v232 == (772 - (720 + 51)))) then
							if (((10706 - 5893) > (5341 - (421 + 1355))) and v86.TheFirstDance:IsAvailable()) then
								v187 = v31(v12:ComboPointsMax(), v105 + (6 - 2));
							end
							if (((1922 + 1990) == (4995 - (286 + 797))) and v12:HasTier(109 - 79, 2 - 0)) then
								v186 = v32(v186, 445 - (397 + 42));
							end
							break;
						end
					end
				end
				v183 = 1 + 1;
			end
		end
	end
	local function v125(v191, v192)
		local v193 = 800 - (24 + 776);
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
			if (((4345 - 1524) <= (5609 - (222 + 563))) and (v193 == (0 - 0))) then
				v194 = v12:BuffUp(v86.ShadowDanceBuff);
				v195 = v12:BuffRemains(v86.ShadowDanceBuff);
				v196 = v12:BuffUp(v86.TheRottenBuff);
				v193 = 1 + 0;
			end
			if (((1928 - (23 + 167)) <= (3993 - (690 + 1108))) and (v193 == (1 + 0))) then
				v197, v198 = v105, v106;
				v199 = v12:BuffUp(v86.PremeditationBuff) or (v192 and v86.Premeditation:IsAvailable());
				v200 = v12:BuffUp(v85.StealthSpell()) or (v192 and (v192:ID() == v85.StealthSpell():ID()));
				v193 = 2 + 0;
			end
			if (((889 - (40 + 808)) <= (497 + 2521)) and (v193 == (11 - 8))) then
				v203 = v86.Shadowstrike:IsCastable() or v200 or v201 or v194 or v12:BuffUp(v86.SepsisBuff);
				if (((2051 + 94) <= (2172 + 1932)) and (v200 or v201)) then
					v203 = v203 and v13:IsInRange(14 + 11);
				else
					v203 = v203 and v92;
				end
				if (((3260 - (47 + 524)) < (3145 + 1700)) and v203 and v200 and ((v96 < (10 - 6)) or v108)) then
					if (v191 or ((3471 - 1149) > (5979 - 3357))) then
						return v86.Shadowstrike;
					elseif (v25(v86.Shadowstrike) or ((6260 - (1165 + 561)) == (62 + 2020))) then
						return "Cast Shadowstrike (Stealth)";
					end
				end
				v193 = 12 - 8;
			end
			if ((v193 == (2 + 2)) or ((2050 - (341 + 138)) > (504 + 1363))) then
				if ((v202 >= v85.CPMaxSpend()) or ((5476 - 2822) >= (3322 - (89 + 237)))) then
					return v124(v191, v192);
				end
				if (((12797 - 8819) > (4429 - 2325)) and v12:BuffUp(v86.ShurikenTornado) and (v198 <= (883 - (581 + 300)))) then
					return v124(v191, v192);
				end
				if (((4215 - (855 + 365)) > (3660 - 2119)) and (v106 <= (1 + 0 + v27(v86.DeeperStratagem:IsAvailable() or v86.SecretStratagem:IsAvailable())))) then
					return v124(v191, v192);
				end
				v193 = 1240 - (1030 + 205);
			end
			if (((3051 + 198) > (887 + 66)) and (v193 == (288 - (156 + 130)))) then
				v201 = v12:BuffUp(v85.VanishBuffSpell()) or (v192 and (v192:ID() == v86.Vanish:ID()));
				if ((v192 and (v192:ID() == v86.ShadowDance:ID())) or ((7436 - 4163) > (7707 - 3134))) then
					v194 = true;
					v195 = (16 - 8) + v86.ImprovedShadowDance:TalentRank();
					if ((v86.TheRotten:IsAvailable() and v12:HasTier(8 + 22, 2 + 0)) or ((3220 - (10 + 59)) < (364 + 920))) then
						v196 = true;
					end
					if (v86.TheFirstDance:IsAvailable() or ((9110 - 7260) == (2692 - (671 + 492)))) then
						local v243 = 0 + 0;
						while true do
							if (((2036 - (369 + 846)) < (563 + 1560)) and (v243 == (0 + 0))) then
								v197 = v31(v12:ComboPointsMax(), v105 + (1949 - (1036 + 909)));
								v198 = v12:ComboPointsMax() - v197;
								break;
							end
						end
					end
				end
				v202 = v85.EffectiveComboPoints(v197);
				v193 = 3 + 0;
			end
			if (((1513 - 611) < (2528 - (11 + 192))) and ((4 + 2) == v193)) then
				if (((1033 - (135 + 40)) <= (7176 - 4214)) and not v199 and (v96 >= (3 + 1))) then
					if (v191 or ((8692 - 4746) < (1930 - 642))) then
						return v86.ShurikenStorm;
					elseif (v25(v86.ShurikenStorm) or ((3418 - (50 + 126)) == (1578 - 1011))) then
						return "Cast Shuriken Storm";
					end
				end
				if (v203 or ((188 + 659) >= (2676 - (1233 + 180)))) then
					if (v191 or ((3222 - (522 + 447)) == (3272 - (107 + 1314)))) then
						return v86.Shadowstrike;
					elseif (v25(v86.Shadowstrike) or ((969 + 1118) > (7227 - 4855))) then
						return "Cast Shadowstrike";
					end
				end
				return false;
			end
			if ((v193 == (3 + 2)) or ((8826 - 4381) < (16415 - 12266))) then
				if ((v86.Backstab:IsCastable() and not v199 and (v195 >= (1913 - (716 + 1194))) and v12:BuffUp(v86.ShadowBlades) and not v121(v86.Backstab) and v86.DanseMacabre:IsAvailable() and (v96 <= (1 + 2)) and not v196) or ((195 + 1623) == (588 - (74 + 429)))) then
					if (((1215 - 585) < (1055 + 1072)) and v191) then
						if (v192 or ((4436 - 2498) == (1779 + 735))) then
							return v86.Backstab;
						else
							return {v86.Backstab,v86.Stealth};
						end
					elseif (((4688 - (279 + 154)) >= (833 - (454 + 324))) and v25(v86.Backstab, v86.Stealth)) then
						return "Cast Backstab (Stealth)";
					end
				end
				if (((2360 + 639) > (1173 - (12 + 5))) and v86.Gloomblade:IsAvailable()) then
					if (((1268 + 1082) > (2942 - 1787)) and not v199 and (v195 >= (2 + 1)) and v12:BuffUp(v86.ShadowBlades) and not v121(v86.Gloomblade) and v86.DanseMacabre:IsAvailable() and (v96 <= (1097 - (277 + 816)))) then
						if (((17216 - 13187) <= (6036 - (1058 + 125))) and v191) then
							if (v192 or ((97 + 419) > (4409 - (815 + 160)))) then
								return v86.Gloomblade;
							else
								return {v86.Gloomblade,v86.Stealth};
							end
						elseif (((966 + 3080) >= (8865 - 5832)) and v25(v86.Gloomblade, v86.Stealth)) then
							return "Cast Gloomblade (Danse)";
						end
					end
				end
				if ((not v121(v86.Shadowstrike) and v12:BuffUp(v86.ShadowBlades)) or ((4617 - (41 + 1857)) <= (3340 - (1222 + 671)))) then
					if (v191 or ((10684 - 6550) < (5642 - 1716))) then
						return v86.Shadowstrike;
					elseif (v25(v86.Shadowstrike) or ((1346 - (229 + 953)) >= (4559 - (1111 + 663)))) then
						return "Cast Shadowstrike (Danse)";
					end
				end
				v193 = 1585 - (874 + 705);
			end
		end
	end
	local function v126(v204, v205)
		local v206 = 0 + 0;
		local v207;
		while true do
			if (((0 + 0) == v206) or ((1091 - 566) == (60 + 2049))) then
				v207 = v125(true, v204);
				if (((712 - (642 + 37)) == (8 + 25)) and (v204:ID() == v86.Vanish:ID())) then
					local v233 = 0 + 0;
					while true do
						if (((7667 - 4613) <= (4469 - (233 + 221))) and (v233 == (0 - 0))) then
							if (((1647 + 224) < (4923 - (718 + 823))) and v25(v86.Vanish, v60)) then
								return "Cast Vanish";
							end
							return false;
						end
					end
				elseif (((814 + 479) <= (2971 - (266 + 539))) and (v204:ID() == v86.Shadowmeld:ID())) then
					local v244 = 0 - 0;
					while true do
						if ((v244 == (1225 - (636 + 589))) or ((6121 - 3542) < (253 - 130))) then
							if (v25(v86.Shadowmeld, v37) or ((671 + 175) >= (861 + 1507))) then
								return "Cast Shadowmeld";
							end
							return false;
						end
					end
				elseif ((v204:ID() == v86.ShadowDance:ID()) or ((5027 - (657 + 358)) <= (8891 - 5533))) then
					local v253 = 0 - 0;
					while true do
						if (((2681 - (1151 + 36)) <= (2902 + 103)) and (v253 == (0 + 0))) then
							if (v25(v86.ShadowDance, v61) or ((9290 - 6179) == (3966 - (1552 + 280)))) then
								return "Cast Shadow Dance";
							end
							return false;
						end
					end
				end
				v206 = 835 - (64 + 770);
			end
			if (((1599 + 756) == (5346 - 2991)) and (v206 == (1 + 0))) then
				return false;
			end
		end
	end
	local function v127()
		local v208 = 1243 - (157 + 1086);
		while true do
			if ((v208 == (1 - 0)) or ((2575 - 1987) <= (662 - 230))) then
				v98 = v84.HandleBottomTrinket(v89, v36, 54 - 14, nil);
				if (((5616 - (599 + 220)) >= (7756 - 3861)) and v98) then
					return v98;
				end
				break;
			end
			if (((5508 - (1813 + 118)) == (2615 + 962)) and (v208 == (1217 - (841 + 376)))) then
				v98 = v84.HandleTopTrinket(v89, v36, 56 - 16, nil);
				if (((882 + 2912) > (10080 - 6387)) and v98) then
					return v98;
				end
				v208 = 860 - (464 + 395);
			end
		end
	end
	local function v128()
		if ((v36 and v86.ColdBlood:IsReady() and not v86.SecretTechnique:IsAvailable() and (v105 >= (12 - 7))) or ((613 + 662) == (4937 - (467 + 370)))) then
			if (v25(v86.ColdBlood, v63) or ((3287 - 1696) >= (2628 + 952))) then
				return "Cast Cold Blood";
			end
		end
		if (((3369 - 2386) <= (283 + 1525)) and v36 and v86.Sepsis:IsAvailable() and v86.Sepsis:IsReady()) then
			if ((v117() and v13:FilteredTimeToDie(">=", 37 - 21) and (v12:BuffUp(v86.PerforatedVeins) or not v86.PerforatedVeins:IsAvailable())) or ((2670 - (150 + 370)) <= (2479 - (74 + 1208)))) then
				if (((9269 - 5500) >= (5562 - 4389)) and v25(v86.Sepsis)) then
					return "Cast Sepsis";
				end
			end
		end
		if (((1057 + 428) == (1875 - (14 + 376))) and v36 and v86.Flagellation:IsAvailable() and v86.Flagellation:IsReady()) then
			if ((v117() and (v104 >= (8 - 3)) and (v13:TimeToDie() > (7 + 3)) and ((v123() and (v86.ShadowBlades:CooldownRemains() <= (3 + 0))) or v9.BossFilteredFightRemains("<=", 27 + 1) or ((v86.ShadowBlades:CooldownRemains() >= (40 - 26)) and v86.InvigoratingShadowdust:IsAvailable() and v86.ShadowDance:IsAvailable())) and (not v86.InvigoratingShadowdust:IsAvailable() or v86.Sepsis:IsAvailable() or not v86.ShadowDance:IsAvailable() or ((v86.InvigoratingShadowdust:TalentRank() == (2 + 0)) and (v96 >= (80 - (23 + 55)))) or (v86.SymbolsofDeath:CooldownRemains() <= (6 - 3)) or (v12:BuffRemains(v86.SymbolsofDeath) > (3 + 0)))) or ((2977 + 338) <= (4313 - 1531))) then
				if (v25(v86.Flagellation) or ((276 + 600) >= (3865 - (652 + 249)))) then
					return "Cast Flagellation";
				end
			end
		end
		if ((v36 and v86.SymbolsofDeath:IsReady()) or ((5973 - 3741) > (4365 - (708 + 1160)))) then
			if ((v117() and (not v12:BuffUp(v86.TheRotten) or not v12:HasTier(81 - 51, 3 - 1)) and (v12:BuffRemains(v86.SymbolsofDeath) <= (30 - (10 + 17))) and (not v86.Flagellation:IsAvailable() or (v86.Flagellation:CooldownRemains() > (3 + 7)) or ((v12:BuffRemains(v86.ShadowDance) >= (1734 - (1400 + 332))) and v86.InvigoratingShadowdust:IsAvailable()) or (v86.Flagellation:IsReady() and (v104 >= (9 - 4)) and not v86.InvigoratingShadowdust:IsAvailable()))) or ((4018 - (242 + 1666)) <= (143 + 189))) then
				if (((1351 + 2335) > (2704 + 468)) and v25(v86.SymbolsofDeath)) then
					return "Cast Symbols of Death";
				end
			end
		end
		if ((v36 and v86.ShadowBlades:IsReady()) or ((5414 - (850 + 90)) < (1436 - 616))) then
			if (((5669 - (360 + 1030)) >= (2551 + 331)) and v117() and ((v104 <= (2 - 1)) or v12:HasTier(42 - 11, 1665 - (909 + 752))) and (v12:BuffUp(v86.Flagellation) or v12:BuffUp(v86.FlagellationPersistBuff) or not v86.Flagellation:IsAvailable())) then
				if (v25(v86.ShadowBlades) or ((3252 - (109 + 1114)) >= (6446 - 2925))) then
					return "Cast Shadow Blades";
				end
			end
		end
		if ((v36 and v86.EchoingReprimand:IsCastable() and v86.EchoingReprimand:IsAvailable()) or ((793 + 1244) >= (4884 - (6 + 236)))) then
			if (((1084 + 636) < (3589 + 869)) and v117() and (v106 >= (6 - 3))) then
				if (v25(v86.EchoingReprimand) or ((761 - 325) > (4154 - (1076 + 57)))) then
					return "Cast Echoing Reprimand";
				end
			end
		end
		if (((118 + 595) <= (1536 - (579 + 110))) and v36 and v86.ShurikenTornado:IsAvailable() and v86.ShurikenTornado:IsReady()) then
			if (((171 + 1983) <= (3564 + 467)) and v117() and v12:BuffUp(v86.SymbolsofDeath) and (v104 <= (2 + 0)) and not v12:BuffUp(v86.Premeditation) and (not v86.Flagellation:IsAvailable() or (v86.Flagellation:CooldownRemains() > (427 - (174 + 233)))) and (v96 >= (8 - 5))) then
				if (((8100 - 3485) == (2053 + 2562)) and v25(v86.ShurikenTornado)) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if ((v36 and v86.ShurikenTornado:IsAvailable() and v86.ShurikenTornado:IsReady()) or ((4964 - (663 + 511)) == (447 + 53))) then
			if (((20 + 69) < (681 - 460)) and v117() and not v12:BuffUp(v86.ShadowDance) and not v12:BuffUp(v86.Flagellation) and not v12:BuffUp(v86.FlagellationPersistBuff) and not v12:BuffUp(v86.ShadowBlades) and (v96 <= (2 + 0))) then
				if (((4835 - 2781) >= (3439 - 2018)) and v25(v86.ShurikenTornado)) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if (((331 + 361) < (5951 - 2893)) and v36 and v86.ShadowDance:IsAvailable() and v111() and v86.ShadowDance:IsReady()) then
			if ((not v12:BuffUp(v86.ShadowDance) and v9.BossFilteredFightRemains("<=", 6 + 2 + ((1 + 2) * v27(v86.Subterfuge:IsAvailable())))) or ((3976 - (478 + 244)) == (2172 - (440 + 77)))) then
				if (v25(v86.ShadowDance) or ((590 + 706) == (17970 - 13060))) then
					return "Cast Shadow Dance";
				end
			end
		end
		if (((4924 - (655 + 901)) == (625 + 2743)) and v36 and v86.GoremawsBite:IsAvailable() and v86.GoremawsBite:IsReady()) then
			if (((2024 + 619) < (2576 + 1239)) and v117() and (v106 >= (11 - 8)) and (not v86.ShadowDance:IsReady() or (v86.ShadowDance:IsAvailable() and v12:BuffUp(v86.ShadowDance) and not v86.InvigoratingShadowdust:IsAvailable()) or ((v96 < (1449 - (695 + 750))) and not v86.InvigoratingShadowdust:IsAvailable()) or v86.TheRotten:IsAvailable())) then
				if (((6531 - 4618) > (760 - 267)) and v25(v86.GoremawsBite)) then
					return "Cast Goremaw's Bite";
				end
			end
		end
		if (((19123 - 14368) > (3779 - (285 + 66))) and v86.ThistleTea:IsReady()) then
			if (((3218 - 1837) <= (3679 - (682 + 628))) and ((((v86.SymbolsofDeath:CooldownRemains() >= (1 + 2)) or v12:BuffUp(v86.SymbolsofDeath)) and not v12:BuffUp(v86.ThistleTea) and (((v12:EnergyDeficitPredicted() >= (399 - (176 + 123))) and ((v106 >= (1 + 1)) or (v96 >= (3 + 0)))) or ((v86.ThistleTea:ChargesFractional() >= ((271.75 - (239 + 30)) - ((0.15 + 0) * v86.InvigoratingShadowdust:TalentRank()))) and v86.Vanish:IsReady() and v12:BuffUp(v86.ShadowDance) and v13:DebuffUp(v86.Rupture) and (v96 < (3 + 0))))) or ((v12:BuffRemains(v86.ShadowDance) >= (6 - 2)) and not v12:BuffUp(v86.ThistleTea) and (v96 >= (8 - 5))) or (not v12:BuffUp(v86.ThistleTea) and v9.BossFilteredFightRemains("<=", (321 - (306 + 9)) * v86.ThistleTea:Charges())))) then
				if (v25(v86.ThistleTea) or ((16900 - 12057) == (711 + 3373))) then
					return "Thistle Tea";
				end
			end
		end
		local v209 = v12:BuffUp(v86.ShadowBlades) or (not v86.ShadowBlades:IsAvailable() and v12:BuffUp(v86.SymbolsofDeath)) or v9.BossFilteredFightRemains("<", 13 + 7);
		if (((2248 + 2421) > (1037 - 674)) and v86.BloodFury:IsCastable() and v209) then
			if (v25(v86.BloodFury, v37) or ((3252 - (1140 + 235)) >= (1997 + 1141))) then
				return "Cast Blood Fury";
			end
		end
		if (((4349 + 393) >= (931 + 2695)) and v86.Berserking:IsCastable()) then
			if (v9.Cast(v86.Berserking, v37) or ((4592 - (33 + 19)) == (331 + 585))) then
				return "Cast Berserking";
			end
		end
		if (v86.Fireblood:IsCastable() or ((3464 - 2308) > (1915 + 2430))) then
			if (((4386 - 2149) < (3985 + 264)) and v9.Cast(v86.Fireblood, v37)) then
				return "Cast Fireblood";
			end
		end
		if (v86.AncestralCall:IsCastable() or ((3372 - (586 + 103)) < (3 + 20))) then
			if (((2145 - 1448) <= (2314 - (1309 + 179))) and v9.Cast(v86.AncestralCall, v37)) then
				return "Cast Ancestral Call";
			end
		end
		if (((1994 - 889) <= (512 + 664)) and v51 and v36) then
			local v220 = 0 - 0;
			while true do
				if (((2553 + 826) <= (8098 - 4286)) and (v220 == (0 - 0))) then
					v98 = v127();
					if (v98 or ((1397 - (295 + 314)) >= (3969 - 2353))) then
						return v98;
					end
					break;
				end
			end
		end
		if (((3816 - (1300 + 662)) <= (10610 - 7231)) and v86.ThistleTea:IsReady()) then
			if (((6304 - (1178 + 577)) == (2363 + 2186)) and ((((v86.SymbolsofDeath:CooldownRemains() >= (8 - 5)) or v12:BuffUp(v86.SymbolsofDeath)) and not v12:BuffUp(v86.ThistleTea) and (((v12:EnergyDeficitPredicted() >= (1505 - (851 + 554))) and ((v12:ComboPointsDeficit() >= (2 + 0)) or (v96 >= (8 - 5)))) or ((v86.ThistleTea:ChargesFractional() >= (3.75 - 1)) and v12:BuffUp(v86.ShadowDanceBuff)))) or ((v12:BuffRemains(v86.ShadowDanceBuff) >= (306 - (115 + 187))) and not v12:BuffUp(v86.ThistleTea) and (v96 >= (3 + 0))) or (not v12:BuffUp(v86.ThistleTea) and v9.BossFilteredFightRemains("<=", (6 + 0) * v86.ThistleTea:Charges())))) then
				if (v25(v86.ThistleTea) or ((11908 - 8886) >= (4185 - (160 + 1001)))) then
					return "Thistle Tea";
				end
			end
		end
		return false;
	end
	local function v129(v210)
		local v211 = 0 + 0;
		while true do
			if (((3326 + 1494) > (4499 - 2301)) and (v211 == (358 - (237 + 121)))) then
				if ((v36 and not (v84.IsSoloMode() and v12:IsTanking(v13))) or ((1958 - (525 + 372)) >= (9272 - 4381))) then
					local v234 = 0 - 0;
					while true do
						if (((1506 - (96 + 46)) <= (5250 - (643 + 134))) and (v234 == (1 + 0))) then
							if ((v86.Shadowmeld:IsCastable() and v92 and not v12:IsMoving() and (v12:EnergyPredicted() >= (95 - 55)) and (v12:EnergyDeficitPredicted() >= (37 - 27)) and not v115() and (v106 > (4 + 0))) or ((7055 - 3460) <= (5 - 2))) then
								local v257 = 719 - (316 + 403);
								while true do
									if ((v257 == (0 + 0)) or ((12845 - 8173) == (1393 + 2459))) then
										v98 = v126(v86.Shadowmeld, v210);
										if (((3925 - 2366) == (1105 + 454)) and v98) then
											return "Shadowmeld Macro " .. v98;
										end
										break;
									end
								end
							end
							break;
						end
						if ((v234 == (0 + 0)) or ((6070 - 4318) <= (3763 - 2975))) then
							if (v86.Vanish:IsCastable() or ((8116 - 4209) == (11 + 166))) then
								if (((6831 - 3361) > (28 + 527)) and ((v106 > (2 - 1)) or (v12:BuffUp(v86.ShadowBlades) and v86.InvigoratingShadowdust:IsAvailable())) and not v115() and ((v86.Flagellation:CooldownRemains() >= (77 - (12 + 5))) or not v86.Flagellation:IsAvailable() or v9.BossFilteredFightRemains("<=", (116 - 86) * v86.Vanish:Charges())) and ((v86.SymbolsofDeath:CooldownRemains() > (5 - 2)) or not v12:HasTier(63 - 33, 4 - 2)) and ((v86.SecretTechnique:CooldownRemains() >= (3 + 7)) or not v86.SecretTechnique:IsAvailable() or ((v86.Vanish:Charges() >= (1975 - (1656 + 317))) and v86.InvigoratingShadowdust:IsAvailable() and (v12:BuffUp(v86.TheRotten) or not v86.TheRotten:IsAvailable())))) then
									v98 = v126(v86.Vanish, v210);
									if (v98 or ((867 + 105) == (517 + 128))) then
										return "Vanish Macro " .. v98;
									end
								end
							end
							if (((8460 - 5278) >= (10409 - 8294)) and (v12:Energy() < (394 - (5 + 349))) and v86.Shadowmeld:IsCastable()) then
								if (((18491 - 14598) < (5700 - (266 + 1005))) and v25(v86.Shadowmeld, v12:EnergyTimeToX(27 + 13))) then
									return "Pool for Shadowmeld";
								end
							end
							v234 = 3 - 2;
						end
					end
				end
				if ((v92 and v86.ShadowDance:IsCastable()) or ((3774 - 907) < (3601 - (561 + 1135)))) then
					if (((v13:DebuffUp(v86.Rupture) or v86.InvigoratingShadowdust:IsAvailable()) and v120() and (not v86.TheFirstDance:IsAvailable() or (v106 >= (5 - 1)) or v12:BuffUp(v86.ShadowBlades)) and ((v116() and v115()) or ((v12:BuffUp(v86.ShadowBlades) or (v12:BuffUp(v86.SymbolsofDeath) and not v86.Sepsis:IsAvailable()) or ((v12:BuffRemains(v86.SymbolsofDeath) >= (12 - 8)) and not v12:HasTier(1096 - (507 + 559), 4 - 2)) or (not v12:BuffUp(v86.SymbolsofDeath) and v12:HasTier(92 - 62, 390 - (212 + 176)))) and (v86.SecretTechnique:CooldownRemains() < ((915 - (250 + 655)) + ((32 - 20) * v27(not v86.InvigoratingShadowdust:IsAvailable() or v12:HasTier(52 - 22, 2 - 0)))))))) or ((3752 - (1869 + 87)) >= (14050 - 9999))) then
						local v245 = 1901 - (484 + 1417);
						while true do
							if (((3469 - 1850) <= (6294 - 2538)) and (v245 == (773 - (48 + 725)))) then
								v98 = v126(v86.ShadowDance, v210);
								if (((986 - 382) == (1620 - 1016)) and v98) then
									return "ShadowDance Macro 1 " .. v98;
								end
								break;
							end
						end
					end
				end
				v211 = 1 + 0;
			end
			if ((v211 == (2 - 1)) or ((1255 + 3229) == (263 + 637))) then
				return false;
			end
		end
	end
	local function v130(v212)
		local v213 = 853 - (152 + 701);
		local v214;
		while true do
			if (((1311 - (430 + 881)) == v213) or ((1708 + 2751) <= (2008 - (557 + 338)))) then
				v214 = not v212 or (v12:EnergyPredicted() >= v212);
				if (((1074 + 2558) > (9575 - 6177)) and v35 and v86.ShurikenStorm:IsCastable() and (v96 >= ((6 - 4) + v20((v86.Gloomblade:IsAvailable() and (v12:BuffRemains(v86.LingeringShadowBuff) >= (15 - 9))) or v12:BuffUp(v86.PerforatedVeinsBuff))))) then
					local v235 = 0 - 0;
					while true do
						if (((4883 - (499 + 302)) <= (5783 - (39 + 827))) and (v235 == (0 - 0))) then
							if (((10791 - 5959) >= (5504 - 4118)) and v214 and v9.Cast(v86.ShurikenStorm)) then
								return "Cast Shuriken Storm";
							end
							v109(v86.ShurikenStorm, v212);
							break;
						end
					end
				end
				v213 = 1 - 0;
			end
			if (((12 + 125) == (400 - 263)) and ((1 + 0) == v213)) then
				if (v92 or ((2484 - 914) >= (4436 - (103 + 1)))) then
					if (v86.Gloomblade:IsCastable() or ((4618 - (475 + 79)) <= (3931 - 2112))) then
						if ((v214 and v25(v86.Gloomblade)) or ((15955 - 10969) < (204 + 1370))) then
							return "Cast Gloomblade";
						end
						v109(v86.Gloomblade, v212);
					elseif (((3896 + 530) > (1675 - (1395 + 108))) and v86.Backstab:IsCastable()) then
						local v254 = 0 - 0;
						while true do
							if (((1790 - (7 + 1197)) > (199 + 256)) and (v254 == (0 + 0))) then
								if (((1145 - (27 + 292)) == (2420 - 1594)) and v214 and v25(v86.Backstab)) then
									return "Cast Backstab";
								end
								v109(v86.Backstab, v212);
								break;
							end
						end
					end
				end
				return false;
			end
		end
	end
	local function v131()
		v83();
		v34 = EpicSettings.Toggles['ooc'];
		v35 = EpicSettings.Toggles['aoe'];
		v36 = EpicSettings.Toggles['cds'];
		ToggleMain = EpicSettings.Toggles['toggle'];
		v99 = nil;
		v101 = nil;
		v100 = 0 - 0;
		v90 = (v86.AcrobaticStrikes:IsAvailable() and (33 - 25)) or (9 - 4);
		v91 = (v86.AcrobaticStrikes:IsAvailable() and (24 - 11)) or (149 - (43 + 96));
		v92 = v13:IsInMeleeRange(v90);
		v93 = v13:IsInMeleeRange(v91);
		if (v35 or ((16393 - 12374) > (10040 - 5599))) then
			v94 = v12:GetEnemiesInRange(25 + 5);
			v95 = v12:GetEnemiesInMeleeRange(v91);
			v96 = #v95;
			v97 = v12:GetEnemiesInMeleeRange(v90);
		else
			local v221 = 0 + 0;
			while true do
				if (((3986 - 1969) < (1634 + 2627)) and (v221 == (0 - 0))) then
					v94 = {};
					v95 = {};
					v221 = 1 + 0;
				end
				if (((346 + 4370) > (1831 - (1414 + 337))) and (v221 == (1941 - (1642 + 298)))) then
					v96 = 2 - 1;
					v97 = {};
					break;
				end
			end
		end
		v105 = v12:ComboPoints();
		v104 = v85.EffectiveComboPoints(v105);
		v106 = v12:ComboPointsDeficit();
		v108 = v112();
		v107 = v12:EnergyMax() - v114();
		if (((v104 > v105) and (v106 > (5 - 3)) and v12:AffectingCombat()) or ((10407 - 6900) == (1077 + 2195))) then
			if (((v105 == (2 + 0)) and not v12:BuffUp(v86.EchoingReprimand3)) or ((v105 == (975 - (357 + 615))) and not v12:BuffUp(v86.EchoingReprimand4)) or ((v105 == (3 + 1)) and not v12:BuffUp(v86.EchoingReprimand5)) or ((2148 - 1272) >= (2635 + 440))) then
				local v229 = 0 - 0;
				local v230;
				while true do
					if (((3481 + 871) > (174 + 2380)) and (v229 == (1 + 0))) then
						if ((v230 < (v32(v12:EnergyTimeToX(1336 - (384 + 917)), v12:GCDRemains()) + (697.5 - (128 + 569)))) or ((5949 - (1407 + 136)) < (5930 - (687 + 1200)))) then
							v104 = v105;
						end
						break;
					end
					if (((1710 - (556 + 1154)) == v229) or ((6645 - 4756) >= (3478 - (9 + 86)))) then
						v230 = v85.TimeToSht(425 - (275 + 146));
						if (((308 + 1584) <= (2798 - (29 + 35))) and (v230 == (0 - 0))) then
							v230 = v85.TimeToSht(14 - 9);
						end
						v229 = 4 - 3;
					end
				end
			end
		end
		if (((1253 + 670) < (3230 - (53 + 959))) and v12:BuffUp(v86.ShurikenTornado, nil, true) and (v105 < v85.CPMaxSpend())) then
			local v222 = 408 - (312 + 96);
			local v223;
			while true do
				if (((3771 - 1598) > (664 - (147 + 138))) and (v222 == (899 - (813 + 86)))) then
					v223 = v85.TimeToNextTornado();
					if ((v223 <= v12:GCDRemains()) or (v33(v12:GCDRemains() - v223) < (0.25 + 0)) or ((4800 - 2209) == (3901 - (18 + 474)))) then
						local v246 = 0 + 0;
						local v247;
						while true do
							if (((14732 - 10218) > (4410 - (860 + 226))) and ((303 - (121 + 182)) == v246)) then
								v247 = v96 + v27(v12:BuffUp(v86.ShadowBlades));
								v105 = v31(v105 + v247, v85.CPMaxSpend());
								v246 = 1 + 0;
							end
							if ((v246 == (1241 - (988 + 252))) or ((24 + 184) >= (1513 + 3315))) then
								v106 = v32(v106 - v247, 1970 - (49 + 1921));
								if ((v104 < v85.CPMaxSpend()) or ((2473 - (223 + 667)) > (3619 - (51 + 1)))) then
									v104 = v105;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
		v102 = ((6 - 2) + (v104 * (8 - 4))) * (1125.3 - (146 + 979));
		v103 = v86.Eviscerate:Damage() * v27(v72);
		if ((v87.Healthstone:IsReady() and (v12:HealthPercentage() < v42) and not (v12:IsChanneling() or v12:IsCasting())) or ((371 + 942) == (1399 - (311 + 294)))) then
			if (((8851 - 5677) > (1230 + 1672)) and v9.Cast(v88.Healthstone)) then
				return "Healthstone ";
			end
		end
		if (((5563 - (496 + 947)) <= (5618 - (1233 + 125))) and v87.RefreshingHealingPotion:IsReady() and (v12:HealthPercentage() < v40) and not (v12:IsChanneling() or v12:IsCasting())) then
			if (v9.Cast(v88.RefreshingHealingPotion) or ((359 + 524) > (4287 + 491))) then
				return "RefreshingHealingPotion ";
			end
		end
		v98 = v85.CrimsonVial();
		if (v98 or ((688 + 2932) >= (6536 - (963 + 682)))) then
			return v98;
		end
		v85.Poisons();
		if (((3554 + 704) > (2441 - (504 + 1000))) and not v12:AffectingCombat()) then
			local v224 = 0 + 0;
			while true do
				if ((v224 == (1 + 0)) or ((460 + 4409) < (1335 - 429))) then
					if ((v84.TargetIsValid() and (v13:IsSpellInRange(v86.Shadowstrike) or v92)) or ((1047 + 178) > (2459 + 1769))) then
						if (((3510 - (156 + 26)) > (1290 + 948)) and v12:StealthUp(true, true)) then
						elseif (((6005 - 2166) > (1569 - (149 + 15))) and (v105 >= (965 - (890 + 70)))) then
							v98 = v124();
							if (v98 or ((1410 - (39 + 78)) <= (989 - (14 + 468)))) then
								return v98 .. " (OOC)";
							end
						elseif (v86.Backstab:IsCastable() or ((6368 - 3472) < (2250 - 1445))) then
							if (((1195 + 1121) == (1391 + 925)) and v26(v86.Backstab)) then
								return "Cast Backstab (OOC)";
							end
						end
					end
					return;
				end
				if ((v224 == (0 + 0)) or ((1161 + 1409) == (402 + 1131))) then
					if (v84.TargetIsValid() or ((1689 - 806) == (1443 + 17))) then
						if ((v14:Exists() and v86.TricksoftheTrade:IsReady()) or ((16230 - 11611) <= (26 + 973))) then
							if (v25(v88.TricksoftheTradeFocus) or ((3461 - (12 + 39)) > (3830 + 286))) then
								return "precombat tricks_of_the_trade";
							end
						end
					end
					if ((not v12:AffectingCombat() and not v12:IsMounted() and v84.TargetIsValid()) or ((2795 - 1892) >= (10894 - 7835))) then
						v98 = v85.Stealth(v86.Stealth2, nil);
						if (v98 or ((1179 + 2797) < (1504 + 1353))) then
							return "Stealth (OOC): " .. v98;
						end
					end
					v224 = 2 - 1;
				end
			end
		end
		if (((3284 + 1646) > (11149 - 8842)) and v84.TargetIsValid() and (v34 or v12:AffectingCombat())) then
			local v225 = 1710 - (1596 + 114);
			local v226;
			while true do
				if ((v225 == (12 - 7)) or ((4759 - (164 + 549)) < (2729 - (1059 + 379)))) then
					if ((v86.ShurikenToss:IsCastable() and v13:IsInRange(37 - 7) and not v93 and not v12:StealthUp(true, true) and not v12:BuffUp(v86.Sprint) and (v12:EnergyDeficitPredicted() < (11 + 9)) and ((v106 >= (1 + 0)) or (v12:EnergyTimeToMax() <= (393.2 - (145 + 247))))) or ((3480 + 761) == (1639 + 1906))) then
						if (v25(v86.ShurikenToss) or ((12001 - 7953) > (812 + 3420))) then
							return "Cast Shuriken Toss";
						end
					end
					break;
				end
				if ((v225 == (3 + 0)) or ((2841 - 1091) >= (4193 - (254 + 466)))) then
					if (((3726 - (544 + 16)) == (10061 - 6895)) and (v104 >= v85.CPMaxSpend())) then
						v98 = v124();
						if (((2391 - (294 + 334)) < (3977 - (236 + 17))) and v98) then
							return "Finish: " .. v98;
						end
					end
					if (((25 + 32) <= (2120 + 603)) and ((v106 <= (3 - 2)) or (v9.BossFilteredFightRemains("<=", 4 - 3) and (v104 >= (2 + 1))))) then
						v98 = v124();
						if (v98 or ((1705 + 365) == (1237 - (413 + 381)))) then
							return "Finish: " .. v98;
						end
					end
					if (((v96 >= (1 + 3)) and (v104 >= (8 - 4))) or ((7026 - 4321) == (3363 - (582 + 1388)))) then
						v98 = v124();
						if (v98 or ((7839 - 3238) < (44 + 17))) then
							return "Finish: " .. v98;
						end
					end
					v225 = 368 - (326 + 38);
				end
				if ((v225 == (5 - 3)) or ((1984 - 594) >= (5364 - (47 + 573)))) then
					v226 = nil;
					if (not v86.Vigor:IsAvailable() or v86.Shadowcraft:IsAvailable() or ((707 + 1296) > (16283 - 12449))) then
						v226 = v12:EnergyDeficitPredicted() <= v114();
					else
						v226 = v12:EnergyPredicted() >= v114();
					end
					if (v226 or v86.InvigoratingShadowdust:IsAvailable() or ((253 - 97) > (5577 - (1269 + 395)))) then
						local v248 = 492 - (76 + 416);
						while true do
							if (((638 - (319 + 124)) == (445 - 250)) and (v248 == (1007 - (564 + 443)))) then
								v98 = v129(v107);
								if (((8595 - 5490) >= (2254 - (337 + 121))) and v98) then
									return "Stealth CDs: " .. v98;
								end
								break;
							end
						end
					end
					v225 = 8 - 5;
				end
				if (((14586 - 10207) >= (4042 - (1261 + 650))) and (v225 == (1 + 0))) then
					if (((6126 - 2282) >= (3860 - (772 + 1045))) and v98) then
						return "CDs: " .. v98;
					end
					if ((v86.SliceandDice:IsCastable() and (v96 < v85.CPMaxSpend()) and (v12:BuffRemains(v86.SliceandDice) < v12:GCD()) and v9.BossFilteredFightRemains(">", 1 + 5) and (v105 >= (148 - (102 + 42)))) or ((5076 - (1524 + 320)) <= (4001 - (1049 + 221)))) then
						local v249 = 156 - (18 + 138);
						while true do
							if (((12006 - 7101) == (6007 - (67 + 1035))) and ((348 - (136 + 212)) == v249)) then
								if ((v86.SliceandDice:IsReady() and v25(v86.SliceandDice)) or ((17575 - 13439) >= (3534 + 877))) then
									return "Cast Slice and Dice (Low Duration)";
								end
								v110(v86.SliceandDice);
								break;
							end
						end
					end
					if (v12:StealthUp(true, true) or ((2727 + 231) == (5621 - (240 + 1364)))) then
						local v250 = 1082 - (1050 + 32);
						while true do
							if (((4384 - 3156) >= (481 + 332)) and (v250 == (1055 - (331 + 724)))) then
								v25(v86.PoolEnergy);
								return "Stealthed Pooling";
							end
						end
					end
					v225 = 1 + 1;
				end
				if (((644 - (269 + 375)) == v225) or ((4180 - (267 + 458)) > (1260 + 2790))) then
					if (((467 - 224) == (1061 - (667 + 151))) and v82 and v86.Shiv:IsReady() and not v12:IsCasting() and not v12:IsChanneling() and v84.UnitHasEnrageBuff(v13)) then
						if (v25(v86.Shiv, not v92) or ((1768 - (1410 + 87)) > (3469 - (1504 + 393)))) then
							return "dispel";
						end
					end
					if (((7403 - 4664) < (8543 - 5250)) and (v9.CombatTime() < (806 - (461 + 335))) and (v9.CombatTime() > (0 + 0)) and v86.ShadowDance:CooldownUp() and (v86.Vanish:TimeSinceLastCast() > (1772 - (1730 + 31)))) then
						local v251 = 1667 - (728 + 939);
						while true do
							if ((v251 == (10 - 7)) or ((7995 - 4053) < (2598 - 1464))) then
								if ((v86.ShadowDance:IsCastable() and v36 and v9.Cast(v88.ShadowDance, true)) or ((3761 - (138 + 930)) == (4545 + 428))) then
									return "Opener ShadowDance";
								end
								break;
							end
							if (((1678 + 468) == (1840 + 306)) and ((0 - 0) == v251)) then
								if (v12:StealthUp(true, true) or ((4010 - (459 + 1307)) == (5094 - (474 + 1396)))) then
									if (v9.Cast(v86.Shadowstrike) or ((8563 - 3659) <= (1796 + 120))) then
										return "Opener SS";
									end
								end
								if (((1 + 89) <= (3050 - 1985)) and v86.SymbolsofDeath:IsCastable() and v12:BuffDown(v86.SymbolsofDeath)) then
									if (((609 + 4193) == (16030 - 11228)) and v9.Cast(v86.SymbolsofDeath, true)) then
										return "Opener SymbolsofDeath";
									end
								end
								v251 = 4 - 3;
							end
							if ((v251 == (592 - (562 + 29))) or ((1944 + 336) <= (1930 - (374 + 1045)))) then
								if ((v86.ShadowBlades:IsCastable() and v12:BuffDown(v86.ShadowBlades)) or ((1327 + 349) <= (1437 - 974))) then
									if (((4507 - (448 + 190)) == (1250 + 2619)) and v9.Cast(v86.ShadowBlades, true)) then
										return "Opener ShadowBlades";
									end
								end
								if (((523 + 635) <= (1703 + 910)) and v86.ShurikenStorm:IsCastable() and (v96 >= (7 - 5))) then
									if (v9.Cast(v86.ShurikenStorm) or ((7345 - 4981) <= (3493 - (1307 + 187)))) then
										return "Opener Shuriken Tornado";
									end
								end
								v251 = 7 - 5;
							end
							if ((v251 == (4 - 2)) or ((15091 - 10169) < (877 - (232 + 451)))) then
								if (((v86.Gloomblade:TimeSinceLastCast() > (3 + 0)) and (v96 <= (1 + 0))) or ((2655 - (510 + 54)) < (62 - 31))) then
									if (v9.Cast(v86.Gloomblade) or ((2466 - (13 + 23)) >= (9496 - 4624))) then
										return "Opener Gloomblade";
									end
								end
								if ((v13:DebuffDown(v86.Rupture) and (v96 <= (1 - 0)) and (v105 > (0 - 0))) or ((5858 - (830 + 258)) < (6120 - 4385))) then
									if (v9.Cast(v86.Rupture) or ((2778 + 1661) <= (2000 + 350))) then
										return "Opener Rupture";
									end
								end
								v251 = 1444 - (860 + 581);
							end
						end
					end
					v98 = v128();
					v225 = 3 - 2;
				end
				if ((v225 == (4 + 0)) or ((4720 - (237 + 4)) < (10495 - 6029))) then
					v98 = v130(v107);
					if (((6444 - 3897) > (2322 - 1097)) and v98) then
						return "Build: " .. v98;
					end
					if (((3824 + 847) > (1536 + 1138)) and v36) then
						local v252 = 0 - 0;
						while true do
							if (((0 + 0) == v252) or ((2011 + 1685) < (4753 - (85 + 1341)))) then
								if ((v86.ArcaneTorrent:IsReady() and v92 and (v12:EnergyDeficitPredicted() >= ((25 - 10) + v12:EnergyRegen()))) or ((12827 - 8285) == (3342 - (45 + 327)))) then
									if (((474 - 222) <= (2479 - (444 + 58))) and v25(v86.ArcaneTorrent, v37)) then
										return "Cast Arcane Torrent";
									end
								end
								if ((v86.ArcanePulse:IsReady() and v92) or ((625 + 811) == (650 + 3125))) then
									if (v25(v86.ArcanePulse, v37) or ((791 + 827) < (2695 - 1765))) then
										return "Cast Arcane Pulse";
									end
								end
								v252 = 1733 - (64 + 1668);
							end
							if (((6696 - (1227 + 746)) > (12765 - 8612)) and (v252 == (1 - 0))) then
								if (v86.LightsJudgment:IsReady() or ((4148 - (415 + 79)) >= (120 + 4534))) then
									if (((1442 - (142 + 349)) <= (641 + 855)) and v25(v86.LightsJudgment, v37)) then
										return "Cast Lights Judgment";
									end
								end
								if (v86.BagofTricks:IsReady() or ((2386 - 650) == (284 + 287))) then
									if (v25(v86.BagofTricks, v37) or ((632 + 264) > (12987 - 8218))) then
										return "Cast Bag of Tricks";
									end
								end
								break;
							end
						end
					end
					v225 = 1869 - (1710 + 154);
				end
			end
		end
	end
	local function v132()
		v9.Print("Subtlety Rogue Work in Progress.");
	end
	v9.SetAPL(579 - (200 + 118), v131, v132);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

