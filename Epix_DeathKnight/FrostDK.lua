local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 0 - 0;
	local v7;
	while true do
		if (((2460 - 1966) <= (125 + 3227)) and (v6 == (3 - 2))) then
			return v7(v0, ...);
		end
		if ((v6 == (0 + 0)) or ((1604 + 2056) <= (6127 - 4062))) then
			v7 = v1[v5];
			if (not v7 or ((2250 + 1860) > (8047 - 3671))) then
				return v2(v5, v0, ...);
			end
			v6 = 1 + 0;
		end
	end
end
v1["Epix_DeathKnight_FrostDK.lua"] = function(...)
	local v8, v9 = ...;
	local v10 = EpicDBC.DBC;
	local v11 = EpicLib;
	local v12 = EpicCache;
	local v13 = v11.Utils;
	local v14 = v11.Unit;
	local v15 = v14.Player;
	local v16 = v14.Target;
	local v17 = v11.Spell;
	local v18 = v11.MultiSpell;
	local v19 = v11.Item;
	local v20 = v11.Pet;
	local v21 = v11.Macro;
	local v22 = v11.Commons.Everyone.num;
	local v23 = v11.Commons.Everyone.bool;
	local v24 = math.min;
	local v25 = math.abs;
	local v26 = math.max;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30 = v11.Cast;
	local v31 = table.insert;
	local v32 = GetTime;
	local v33 = strsplit;
	local v34 = GetInventoryItemLink;
	local v35;
	local v36;
	local v37;
	local v38;
	local v39 = 0 + 0;
	local v40;
	local v41 = 0 + 0;
	local v42;
	local v43;
	local v44;
	local v45;
	local v46 = 0 + 0;
	local v47 = 0 + 0;
	local v48;
	local v49;
	local v50;
	local v51;
	local v52;
	local v53;
	local v54;
	local v55;
	local v56;
	local v57 = 433 - (153 + 280);
	local v58;
	local v59;
	local v60;
	local v61;
	local v62;
	local v63;
	local function v64()
		v35 = EpicSettings.Settings['UseRacials'];
		v37 = EpicSettings.Settings['UseHealingPotion'];
		v38 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v39 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v40 = EpicSettings.Settings['UseHealthstone'];
		v41 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v42 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
		v43 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v44 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v46 = EpicSettings.Settings['UseDeathStrikeHP'] or (0 - 0);
		v47 = EpicSettings.Settings['UseDarkSuccorHP'] or (0 + 0);
		v48 = EpicSettings.Settings['UseAMSAMZOffensively'];
		v49 = EpicSettings.Settings['AntiMagicShellGCD'];
		v50 = EpicSettings.Settings['AntiMagicZoneGCD'];
		v51 = EpicSettings.Settings['DeathAndDecayGCD'];
		v52 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
		v53 = EpicSettings.Settings['SacrificialPactGCD'];
		v54 = EpicSettings.Settings['MindFreezeOffGCD'];
		v55 = EpicSettings.Settings['RacialsOffGCD'];
		v56 = EpicSettings.Settings['DisableBoSPooling'];
		v57 = EpicSettings.Settings['AMSAbsorbPercent'] or (667 - (89 + 578));
		v58 = EpicSettings.Settings['BreathOfSindragosaGCD'];
		v59 = EpicSettings.Settings['FrostStrikeGCD'];
		v60 = EpicSettings.Settings['FrostwyrmsFuryGCD'];
		v61 = EpicSettings.Settings['HornOfWinterGCD'];
		v62 = EpicSettings.Settings['HypothermicPresenceGCD'];
		v63 = EpicSettings.Settings['PillarOfFrostGCD'];
	end
	local v65 = v17.DeathKnight.Frost;
	local v66 = v19.DeathKnight.Frost;
	local v67 = v21.DeathKnight.Frost;
	local v68 = {v66.AlgetharPuzzleBox:ID()};
	local v69 = v11.Commons.Everyone;
	local v70;
	local v71;
	local v72;
	local v73 = v65.GatheringStorm:IsAvailable() or v65.Everfrost:IsAvailable();
	local v74 = ((v57 > (122 - 63)) and (1074 - (572 + 477))) or (7 + 38);
	local v75, v76;
	local v77, v78;
	local v79;
	local v80;
	local v81;
	local v82;
	local v83;
	local v84;
	local v85;
	local v86;
	local v87;
	local v88;
	local v89;
	local v90 = 6668 + 4443;
	local v91 = 1327 + 9784;
	local v92 = v11.GhoulTable;
	local v93, v94, v95;
	local v96, v97, v98;
	local v99;
	v11:RegisterForEvent(function()
		local v147 = 86 - (84 + 2);
		while true do
			if ((v147 == (0 - 0)) or ((1175 + 455) > (5040 - (497 + 345)))) then
				v90 = 285 + 10826;
				v91 = 1879 + 9232;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v11:RegisterForEvent(function()
		v73 = v65.GatheringStorm:IsAvailable() or v65.Everfrost:IsAvailable();
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local v100 = {{v65.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	local v101 = v34("player", 59 - 43) or "";
	local v102 = v34("player", 16 + 1) or "";
	local v103, v103, v104 = v33(":", v101);
	local v103, v103, v105 = v33(":", v102);
	local v71 = (v104 == "3370") or (v105 == "3370");
	local v72 = (v104 == "3368") or (v105 == "3368");
	local v106 = (v104 == "6243") or (v105 == "6243");
	local v107 = IsEquippedItemType("Two-Hand");
	local v108 = v15:GetEquipment();
	local v109 = (v108[35 - 22] and v19(v108[10 + 3])) or v19(489 - (457 + 32));
	local v110 = (v108[6 + 8] and v19(v108[1416 - (832 + 570)])) or v19(0 + 0);
	v11:RegisterForEvent(function()
		v101 = v34("player", 5 + 11) or "";
		v102 = v34("player", 59 - 42) or "";
		v103, v103, v104 = v33(":", v101);
		v103, v103, v105 = v33(":", v102);
		v71 = (v104 == "3370") or (v105 == "3370");
		v72 = (v104 == "3368") or (v105 == "3368");
		v107 = IsEquippedItemType("Two-Hand");
		v108 = v15:GetEquipment();
		v109 = (v108[7 + 6] and v19(v108[809 - (588 + 208)])) or v19(0 - 0);
		v110 = (v108[1814 - (884 + 916)] and v19(v108[28 - 14])) or v19(0 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v111()
		return (v15:HealthPercentage() < v46) or ((v15:HealthPercentage() < v47) and v15:BuffUp(v65.DeathStrikeBuff));
	end
	local function v112(v148)
		return v148:DebuffRemains(v65.MarkofFyralathDebuff);
	end
	local function v113(v149)
		return ((v149:DebuffStack(v65.RazoriceDebuff) + (654 - (232 + 421))) / (v149:DebuffRemains(v65.RazoriceDebuff) + (1890 - (1569 + 320)))) * v22(v71);
	end
	local function v114(v150)
		return (v150:DebuffDown(v65.FrostFeverDebuff));
	end
	local function v115()
		v74 = ((v57 > (15 + 44)) and (6 + 24)) or (151 - 106);
		if (((1659 - (316 + 289)) == (2758 - 1704)) and v65.HowlingBlast:IsReady() and not v16:IsInRange(1 + 7)) then
			if (v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast)) or ((2129 - (666 + 787)) >= (2067 - (360 + 65)))) then
				return "howling_blast precombat 2";
			end
		end
		if (((3866 + 270) > (2651 - (79 + 175))) and v65.RemorselessWinter:IsReady() and v16:IsInRange(12 - 4)) then
			if (v30(v65.RemorselessWinter) or ((3383 + 951) == (13011 - 8766))) then
				return "remorseless_winter precombat 4";
			end
		end
	end
	local function v116()
		local v151 = 0 - 0;
		local v152;
		while true do
			if ((v151 == (900 - (503 + 396))) or ((4457 - (92 + 89)) <= (5879 - 2848))) then
				v152 = v69.HandleBottomTrinket(v68, v29, 21 + 19, nil);
				if (v152 or ((2831 + 1951) <= (4695 - 3496))) then
					return v152;
				end
				break;
			end
			if ((v151 == (0 + 0)) or ((11090 - 6226) < (1660 + 242))) then
				v152 = v69.HandleTopTrinket(v68, v29, 20 + 20, nil);
				if (((14737 - 9898) >= (462 + 3238)) and v152) then
					return v152;
				end
				v151 = 1 - 0;
			end
		end
	end
	local function v117()
		local v153 = 1244 - (485 + 759);
		while true do
			if ((v153 == (8 - 4)) or ((2264 - (442 + 747)) > (3053 - (832 + 303)))) then
				if (((1342 - (88 + 858)) <= (1160 + 2644)) and v29 and v65.ArcaneTorrent:IsReady() and (v15:RunicPowerDeficit() > (21 + 4))) then
					if (v30(v65.ArcaneTorrent, v55) or ((172 + 3997) == (2976 - (766 + 23)))) then
						return "arcane_torrent aoe 20";
					end
				end
				break;
			end
			if (((6941 - 5535) == (1922 - 516)) and (v153 == (7 - 4))) then
				if (((5196 - 3665) < (5344 - (1036 + 37))) and v65.FrostStrike:IsReady() and not v89 and not v65.GlacialAdvance:IsAvailable()) then
					if (((451 + 184) == (1236 - 601)) and v30(v65.FrostStrike, v59, nil, not v16:IsSpellInRange(v65.FrostStrike))) then
						return "frost_strike aoe 16";
					end
				end
				if (((2654 + 719) <= (5036 - (641 + 839))) and v65.HornofWinter:IsCastable() and (v15:Rune() < (915 - (910 + 3))) and (v15:RunicPowerDeficit() > (63 - 38))) then
					if (v30(v65.HornofWinter, v61) or ((4975 - (1466 + 218)) < (1508 + 1772))) then
						return "horn_of_winter aoe 18";
					end
				end
				v153 = 1152 - (556 + 592);
			end
			if (((1560 + 2826) >= (1681 - (329 + 479))) and (v153 == (854 - (174 + 680)))) then
				if (((3164 - 2243) <= (2283 - 1181)) and v65.HowlingBlast:IsReady() and (v15:BuffUp(v65.RimeBuff) or v16:DebuffDown(v65.FrostFeverDebuff))) then
					if (((3360 + 1346) >= (1702 - (396 + 343))) and v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast))) then
						return "howling_blast aoe 2";
					end
				end
				if ((v65.GlacialAdvance:IsReady() and not v89 and v83) or ((85 + 875) <= (2353 - (29 + 1448)))) then
					if (v30(v65.GlacialAdvance, nil, nil, not v16:IsInRange(1489 - (135 + 1254))) or ((7782 - 5716) == (4351 - 3419))) then
						return "glacial_advance aoe 4";
					end
				end
				v153 = 1 + 0;
			end
			if (((6352 - (389 + 1138)) < (5417 - (102 + 472))) and (v153 == (1 + 0))) then
				if ((v65.Obliterate:IsReady() and v15:BuffUp(v65.KillingMachineBuff) and v65.CleavingStrikes:IsAvailable() and v15:BuffUp(v65.DeathAndDecayBuff) and not v85) or ((2150 + 1727) >= (4231 + 306))) then
					if (v69.CastTargetIf(v65.Obliterate, v93, "min", v112, nil, not v16:IsInMeleeRange(1550 - (320 + 1225))) or ((7681 - 3366) < (1057 + 669))) then
						return "obliterate aoe 8";
					end
				end
				if ((v65.GlacialAdvance:IsReady() and not v89) or ((5143 - (157 + 1307)) < (2484 - (821 + 1038)))) then
					if (v30(v65.GlacialAdvance, nil, nil, not v16:IsInRange(249 - 149)) or ((506 + 4119) < (1122 - 490))) then
						return "glacial_advance aoe 10";
					end
				end
				v153 = 1 + 1;
			end
			if ((v153 == (4 - 2)) or ((1109 - (834 + 192)) > (114 + 1666))) then
				if (((141 + 405) <= (24 + 1053)) and v65.Frostscythe:IsReady() and v85) then
					if (v30(v65.Frostscythe, nil, nil, not v16:IsInMeleeRange(12 - 4)) or ((1300 - (300 + 4)) > (1149 + 3152))) then
						return "frostscythe aoe 12";
					end
				end
				if (((10654 - 6584) > (1049 - (112 + 250))) and v65.Obliterate:IsReady() and not v85) then
					if (v69.CastTargetIf(v65.Obliterate, v93, "min", v112, nil, not v16:IsInMeleeRange(2 + 3)) or ((1643 - 987) >= (1908 + 1422))) then
						return "obliterate aoe 14";
					end
				end
				v153 = 2 + 1;
			end
		end
	end
	local function v118()
		local v154 = 0 + 0;
		while true do
			if ((v154 == (2 + 1)) or ((1852 + 640) <= (1749 - (1001 + 413)))) then
				if (((9637 - 5315) >= (3444 - (244 + 638))) and v65.HowlingBlast:IsReady() and (v15:BuffUp(v65.RimeBuff))) then
					if (v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast)) or ((4330 - (627 + 66)) >= (11233 - 7463))) then
						return "howling_blast breath 24";
					end
				end
				if ((v65.ArcaneTorrent:IsReady() and (v15:RunicPower() < (662 - (512 + 90)))) or ((4285 - (1665 + 241)) > (5295 - (373 + 344)))) then
					if (v30(v65.ArcaneTorrent, v55) or ((218 + 265) > (197 + 546))) then
						return "arcane_torrent breath 26";
					end
				end
				break;
			end
			if (((6472 - 4018) > (977 - 399)) and ((1100 - (35 + 1064)) == v154)) then
				if (((677 + 253) < (9537 - 5079)) and v65.Frostscythe:IsReady() and v85 and (v15:BuffUp(v65.KillingMachineBuff) or (v15:RunicPower() > (1 + 44)))) then
					if (((1898 - (298 + 938)) <= (2231 - (233 + 1026))) and v30(v65.Frostscythe, nil, nil, not v16:IsInMeleeRange(1674 - (636 + 1030)))) then
						return "frostscythe breath 8";
					end
				end
				if (((2235 + 2135) == (4269 + 101)) and v65.Obliterate:IsReady() and ((v15:RunicPowerDeficit() > (12 + 28)) or v15:BuffUp(v65.PillarofFrostBuff))) then
					if (v69.CastTargetIf(v65.Obliterate, v93, "max", v113, nil, not v16:IsInMeleeRange(1 + 4)) or ((4983 - (55 + 166)) <= (167 + 694))) then
						return "obliterate breath 10";
					end
				end
				if ((v65.DeathAndDecay:IsReady() and v51 and (v15:RunicPower() < (4 + 32)) and (v15:RuneTimeToX(7 - 5) > (v15:RunicPower() / (315 - (36 + 261))))) or ((2468 - 1056) == (5632 - (34 + 1334)))) then
					if (v30(v67.DaDPlayer, nil, nil, not v16:IsSpellInRange(v65.DeathAndDecay)) or ((1218 + 1950) < (1673 + 480))) then
						return "death_and_decay breath 16";
					end
				end
				v154 = 1285 - (1035 + 248);
			end
			if ((v154 == (21 - (20 + 1))) or ((2593 + 2383) < (1651 - (134 + 185)))) then
				if (((5761 - (549 + 584)) == (5313 - (314 + 371))) and v65.HowlingBlast:IsReady() and v82 and (v15:RunicPower() > (((154 - 109) - (v22(v65.RageoftheFrozenChampion:IsAvailable()) * (976 - (478 + 490)))) + ((3 + 2) * v22(v15:BuffUp(v65.RuneofHysteriaBuff)))))) then
					if (v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast)) or ((1226 - (786 + 386)) == (1279 - 884))) then
						return "howling_blast breath 2";
					end
				end
				if (((1461 - (1055 + 324)) == (1422 - (1093 + 247))) and v65.HornofWinter:IsReady() and (v15:Rune() < (2 + 0)) and (v15:RunicPowerDeficit() > (3 + 22 + ((19 - 14) * v22(v15:BuffUp(v65.RuneofHysteriaBuff)))))) then
					if (v30(v65.HornofWinter, v61) or ((1971 - 1390) < (802 - 520))) then
						return "horn_of_winter breath 4";
					end
				end
				if ((v65.Obliterate:IsReady() and v15:BuffUp(v65.KillingMachineBuff) and not v85) or ((11581 - 6972) < (888 + 1607))) then
					if (((4437 - 3285) == (3970 - 2818)) and v69.CastTargetIf(v65.Obliterate, v98, "max", v113, nil, not v16:IsInMeleeRange(4 + 1))) then
						return "obliterate breath 8";
					end
				end
				v154 = 2 - 1;
			end
			if (((2584 - (364 + 324)) <= (9380 - 5958)) and (v154 == (4 - 2))) then
				if ((v65.RemorselessWinter:IsReady() and (v15:RunicPower() < (12 + 24)) and (v15:RuneTimeToX(8 - 6) > (v15:RunicPower() / (28 - 10)))) or ((3006 - 2016) > (2888 - (1249 + 19)))) then
					if (v30(v65.RemorselessWinter, nil, nil, not v16:IsInMeleeRange(8 + 0)) or ((3413 - 2536) > (5781 - (686 + 400)))) then
						return "remorseless_winter breath 18";
					end
				end
				if (((2112 + 579) >= (2080 - (73 + 156))) and v65.HowlingBlast:IsReady() and (v15:RunicPower() < (1 + 35)) and (v15:RuneTimeToX(813 - (721 + 90)) > (v15:RunicPower() / (1 + 17)))) then
					if (v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast)) or ((9691 - 6706) >= (5326 - (224 + 246)))) then
						return "howling_blast breath 20";
					end
				end
				if (((6927 - 2651) >= (2200 - 1005)) and v65.Obliterate:IsReady() and (v15:RunicPowerDeficit() > (5 + 20))) then
					if (((77 + 3155) <= (3445 + 1245)) and v69.CastTargetIf(v65.Obliterate, v93, "max", v113, nil, not v16:IsInMeleeRange(9 - 4))) then
						return "obliterate breath 18";
					end
				end
				v154 = 9 - 6;
			end
		end
	end
	local function v119()
		if ((v65.Frostscythe:IsReady() and v15:BuffUp(v65.KillingMachineBuff) and v85) or ((1409 - (203 + 310)) >= (5139 - (1238 + 755)))) then
			if (((214 + 2847) >= (4492 - (709 + 825))) and v30(v65.Frostscythe, nil, nil, not v16:IsInMeleeRange(14 - 6))) then
				return "frostscythe breath_oblit 2";
			end
		end
		if (((4642 - 1455) >= (1508 - (196 + 668))) and v65.Obliterate:IsReady() and (v15:BuffUp(v65.KillingMachineBuff))) then
			if (((2542 - 1898) <= (1457 - 753)) and v69.CastTargetIf(v65.Obliterate, v93, "max", v113, nil, not v16:IsInMeleeRange(838 - (171 + 662)))) then
				return "obliterate breath_oblit 4";
			end
		end
		if (((1051 - (4 + 89)) > (3319 - 2372)) and v65.HowlingBlast:IsReady() and (v15:BuffUp(v65.RimeBuff))) then
			if (((1636 + 2856) >= (11656 - 9002)) and v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast))) then
				return "howling_blast breath_oblit 6";
			end
		end
		if (((1350 + 2092) >= (2989 - (35 + 1451))) and v65.HowlingBlast:IsReady() and (v15:BuffDown(v65.KillingMachineBuff))) then
			if (v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast)) or ((4623 - (28 + 1425)) <= (3457 - (941 + 1052)))) then
				return "howling_blast breath_oblit 8";
			end
		end
		if ((v65.HornofWinter:IsReady() and (v15:RunicPowerDeficit() > (24 + 1))) or ((6311 - (822 + 692)) == (6264 - 1876))) then
			if (((260 + 291) <= (978 - (45 + 252))) and v30(v65.HornofWinter, v61)) then
				return "horn_of_winter breath_oblit 10";
			end
		end
		if (((3243 + 34) > (141 + 266)) and v65.ArcaneTorrent:IsReady() and (v15:RunicPowerDeficit() > (48 - 28))) then
			if (((5128 - (114 + 319)) >= (2031 - 616)) and v30(v65.ArcaneTorrent, v55)) then
				return "arcane_torrent breath_oblit 12";
			end
		end
	end
	local function v120()
		if ((v65.ChainsofIce:IsReady() and (v91 < v15:GCD()) and ((v15:Rune() < (2 - 0)) or (v15:BuffDown(v65.KillingMachineBuff) and ((not v107 and (v15:BuffStack(v65.ColdHeartBuff) >= (3 + 1))) or (v107 and (v15:BuffStack(v65.ColdHeartBuff) > (11 - 3))))) or (v15:BuffUp(v65.KillingMachineBuff) and ((not v107 and (v15:BuffStack(v65.ColdHeartBuff) > (16 - 8))) or (v107 and (v15:BuffStack(v65.ColdHeartBuff) > (1973 - (556 + 1407)))))))) or ((4418 - (741 + 465)) <= (1409 - (170 + 295)))) then
			if (v30(v65.ChainsofIce, nil, nil, not v16:IsSpellInRange(v65.ChainsofIce)) or ((1632 + 1464) <= (1652 + 146))) then
				return "chains_of_ice cold_heart 2";
			end
		end
		if (((8708 - 5171) == (2933 + 604)) and v65.ChainsofIce:IsReady() and not v65.Obliteration:IsAvailable() and v15:BuffUp(v65.PillarofFrostBuff) and (v15:BuffStack(v65.ColdHeartBuff) >= (7 + 3)) and ((v15:BuffRemains(v65.PillarofFrostBuff) < (v15:GCD() * (1 + 0 + v22(v65.FrostwyrmsFury:IsAvailable() and v65.FrostwyrmsFury:IsReady())))) or (v15:BuffUp(v65.UnholyStrengthBuff) and (v15:BuffRemains(v65.UnholyStrengthBuff) < v15:GCD())))) then
			if (((5067 - (957 + 273)) >= (420 + 1150)) and v30(v65.ChainsofIce, nil, not v16:IsSpellInRange(v65.ChainsofIce))) then
				return "chains_of_ice cold_heart 4";
			end
		end
		if ((v65.ChainsofIce:IsReady() and not v65.Obliteration:IsAvailable() and v72 and v15:BuffDown(v65.PillarofFrostBuff) and (v65.PillarofFrost:CooldownRemains() > (7 + 8)) and (((v15:BuffStack(v65.ColdHeartBuff) >= (38 - 28)) and v15:BuffUp(v65.UnholyStrengthBuff)) or (v15:BuffStack(v65.ColdHeartBuff) >= (34 - 21)))) or ((9010 - 6060) == (18875 - 15063))) then
			if (((6503 - (389 + 1391)) >= (1455 + 863)) and v30(v65.ChainsofIce, nil, not v16:IsSpellInRange(v65.ChainsofIce))) then
				return "chains_of_ice cold_heart 6";
			end
		end
		if ((v65.ChainsofIce:IsReady() and not v65.Obliteration:IsAvailable() and not v72 and (v15:BuffStack(v65.ColdHeartBuff) >= (2 + 8)) and v15:BuffDown(v65.PillarofFrostBuff) and (v65.PillarofFrost:CooldownRemains() > (45 - 25))) or ((2978 - (783 + 168)) > (9571 - 6719))) then
			if (v30(v65.ChainsofIce, nil, not v16:IsSpellInRange(v65.ChainsofIce)) or ((1118 + 18) > (4628 - (309 + 2)))) then
				return "chains_of_ice cold_heart 8";
			end
		end
		if (((14580 - 9832) == (5960 - (1090 + 122))) and v65.ChainsofIce:IsReady() and v65.Obliteration:IsAvailable() and v15:BuffDown(v65.PillarofFrostBuff) and (((v15:BuffStack(v65.ColdHeartBuff) >= (5 + 9)) and (v15:BuffUp(v65.UnholyStrengthBuff))) or (v15:BuffStack(v65.ColdHeartBuff) >= (63 - 44)) or ((v65.PillarofFrost:CooldownRemains() < (3 + 0)) and (v15:BuffStack(v65.ColdHeartBuff) >= (1132 - (628 + 490)))))) then
			if (((670 + 3066) <= (11735 - 6995)) and v30(v65.ChainsofIce, nil, not v16:IsSpellInRange(v65.ChainsofIce))) then
				return "chains_of_ice cold_heart 10";
			end
		end
	end
	local function v121()
		local v155 = 0 - 0;
		while true do
			if ((v155 == (775 - (431 + 343))) or ((6846 - 3456) <= (8852 - 5792))) then
				if ((v65.AbominationLimb:IsCastable() and v65.BreathofSindragosa:IsAvailable() and (v81 or v80)) or ((790 + 209) > (345 + 2348))) then
					if (((2158 - (556 + 1139)) < (616 - (6 + 9))) and v30(v65.AbominationLimb, nil, not v16:IsInRange(4 + 16))) then
						return "abomination_limb_talent cooldowns 12";
					end
				end
				if ((v65.AbominationLimb:IsCastable() and not v65.BreathofSindragosa:IsAvailable() and not v65.Obliteration:IsAvailable() and (v81 or v80)) or ((1119 + 1064) < (856 - (28 + 141)))) then
					if (((1762 + 2787) == (5614 - 1065)) and v30(v65.AbominationLimb, nil, not v16:IsInRange(15 + 5))) then
						return "abomination_limb_talent cooldowns 14";
					end
				end
				if (((5989 - (486 + 831)) == (12157 - 7485)) and v65.ChillStreak:IsReady() and v15:HasTier(109 - 78, 1 + 1) and (v15:BuffRemains(v65.ChillingRageBuff) < (9 - 6))) then
					if (v30(v65.ChillStreak, nil, nil, not v16:IsSpellInRange(v65.ChillStreak)) or ((4931 - (668 + 595)) < (356 + 39))) then
						return "chill_streak cooldowns 16";
					end
				end
				if ((v65.ChillStreak:IsReady() and not v15:HasTier(7 + 24, 5 - 3) and (v94 >= (292 - (23 + 267))) and ((v15:BuffDown(v65.DeathAndDecayBuff) and v65.CleavingStrikes:IsAvailable()) or not v65.CleavingStrikes:IsAvailable() or (v94 <= (1949 - (1129 + 815))))) or ((4553 - (371 + 16)) == (2205 - (1326 + 424)))) then
					if (v30(v65.ChillStreak, nil, nil, not v16:IsSpellInRange(v65.ChillStreak)) or ((8425 - 3976) == (9731 - 7068))) then
						return "chill_streak cooldowns 16";
					end
				end
				v155 = 120 - (88 + 30);
			end
			if (((771 - (720 + 51)) == v155) or ((9514 - 5237) < (4765 - (421 + 1355)))) then
				if ((v65.EmpowerRuneWeapon:IsCastable() and ((v65.Obliteration:IsAvailable() and v15:BuffDown(v65.EmpowerRuneWeaponBuff) and (v15:Rune() < (9 - 3)) and (((v65.PillarofFrost:CooldownRemains() < (4 + 3)) and v15:BloodlustUp()) or (((v94 >= (1085 - (286 + 797))) or v80) and v65.PillarofFrost:CooldownUp()))) or (v91 < (73 - 53)))) or ((1441 - 571) >= (4588 - (397 + 42)))) then
					if (((691 + 1521) < (3983 - (24 + 776))) and v30(v65.EmpowerRuneWeapon, v52)) then
						return "empower_rune_weapon cooldowns 4";
					end
				end
				if (((7157 - 2511) > (3777 - (222 + 563))) and v65.EmpowerRuneWeapon:IsCastable() and ((v15:BuffUp(v65.BreathofSindragosa) and v15:BuffDown(v65.EmpowerRuneWeaponBuff) and (v11.CombatTime() < (22 - 12)) and v15:BloodlustUp()) or ((v15:RunicPower() < (51 + 19)) and (v15:Rune() < (193 - (23 + 167))) and ((v65.BreathofSindragosa:CooldownRemains() > v74) or (v65.EmpowerRuneWeapon:FullRechargeTime() < (1808 - (690 + 1108))))))) then
					if (((518 + 916) < (2562 + 544)) and v30(v65.EmpowerRuneWeapon, v52)) then
						return "empower_rune_weapon cooldowns 6";
					end
				end
				if (((1634 - (40 + 808)) < (498 + 2525)) and v65.EmpowerRuneWeapon:IsCastable() and not v65.BreathofSindragosa:IsAvailable() and not v65.Obliteration:IsAvailable() and v15:BuffDown(v65.EmpowerRuneWeaponBuff) and (v15:Rune() < (19 - 14)) and ((v65.PillarofFrostBuff:CooldownRemains() < (7 + 0)) or v15:BuffUp(v65.PillarofFrostBuff) or not v65.PillarofFrost:IsAvailable())) then
					if (v30(v65.EmpowerRuneWeapon, v52) or ((1292 + 1150) < (41 + 33))) then
						return "empower_rune_weapon cooldowns 8";
					end
				end
				if (((5106 - (47 + 524)) == (2944 + 1591)) and v65.AbominationLimb:IsCastable() and ((v65.Obliteration:IsAvailable() and v15:BuffDown(v65.PillarofFrostBuff) and (v65.PillarofFrost:CooldownRemains() < (8 - 5)) and (v81 or v80)) or (v91 < (22 - 7)))) then
					if (v30(v65.AbominationLimb, nil, not v16:IsInRange(45 - 25)) or ((4735 - (1165 + 561)) <= (63 + 2042))) then
						return "abomination_limb_talent cooldowns 10";
					end
				end
				v155 = 3 - 2;
			end
			if (((699 + 1131) < (4148 - (341 + 138))) and (v155 == (1 + 1))) then
				if ((v65.PillarofFrost:IsCastable() and ((v65.Obliteration:IsAvailable() and (v81 or v80) and (v15:BuffUp(v65.EmpowerRuneWeaponBuff) or (v65.EmpowerRuneWeapon:CooldownRemains() > (0 - 0)))) or (v91 < (338 - (89 + 237))))) or ((4600 - 3170) >= (7603 - 3991))) then
					if (((3564 - (581 + 300)) >= (3680 - (855 + 365))) and v30(v65.PillarofFrost, v63)) then
						return "pillar_of_frost cooldowns 18";
					end
				end
				if ((v65.PillarofFrost:IsCastable() and ((v65.BreathofSindragosa:IsAvailable() and (v81 or v80) and ((not v65.Icecap:IsAvailable() and ((v15:RunicPower() > (166 - 96)) or (v65.BreathofSindragosa:CooldownRemains() > (14 + 26)))) or (v65.Icecap:IsAvailable() and (v65.BreathofSindragosa:CooldownRemains() > (1240 - (1030 + 205)))))) or v15:BuffUp(v65.BreathofSindragosa))) or ((1694 + 110) >= (3047 + 228))) then
					if (v30(v65.PillarofFrost, v63) or ((1703 - (156 + 130)) > (8245 - 4616))) then
						return "pillar_of_frost cooldowns 22";
					end
				end
				if (((8081 - 3286) > (822 - 420)) and v65.PillarofFrost:IsCastable() and v65.Icecap:IsAvailable() and not v65.Obliteration:IsAvailable() and not v65.BreathofSindragosa:IsAvailable() and (v81 or v80)) then
					if (((1269 + 3544) > (2079 + 1486)) and v30(v65.PillarofFrost, v63)) then
						return "pillar_of_frost cooldowns 22";
					end
				end
				if (((3981 - (10 + 59)) == (1107 + 2805)) and v65.BreathofSindragosa:IsReady() and v15:BuffDown(v65.BreathofSindragosa) and (((v15:RunicPower() > (246 - 196)) and v65.EmpowerRuneWeapon:CooldownUp()) or ((v15:RunicPower() > (1223 - (671 + 492))) and (v65.EmpowerRuneWeapon:CooldownRemains() < (24 + 6))) or ((v15:RunicPower() > (1295 - (369 + 846))) and (v65.EmpowerRuneWeapon:CooldownRemains() > (8 + 22)))) and (v81 or v80 or (v91 < (26 + 4)))) then
					if (((4766 - (1036 + 909)) <= (3836 + 988)) and v30(v65.BreathofSindragosa, v58, nil, not v16:IsInRange(19 - 7))) then
						return "breath_of_sindragosa cooldowns 26";
					end
				end
				v155 = 206 - (11 + 192);
			end
			if (((879 + 859) <= (2370 - (135 + 40))) and (v155 == (9 - 5))) then
				if (((25 + 16) <= (6648 - 3630)) and v65.SoulReaper:IsReady() and (v91 > (7 - 2)) and ((v16:TimeToX(211 - (50 + 126)) < (13 - 8)) or (v16:HealthPercentage() <= (8 + 27))) and (v94 <= (1415 - (1233 + 180))) and ((v65.Obliteration:IsAvailable() and ((v15:BuffUp(v65.PillarofFrostBuff) and v15:BuffDown(v65.KillingMachineBuff) and (v15:Rune() > (971 - (522 + 447)))) or v15:BuffDown(v65.PillarofFrostBuff))) or (v65.BreathofSindragosa:IsAvailable() and ((v15:BuffUp(v65.BreathofSindragosa) and (v15:RunicPower() > (1471 - (107 + 1314)))) or v15:BuffDown(v65.BreathofSindragosa))) or (not v65.BreathofSindragosa:IsAvailable() and not v65.Obliteration:IsAvailable()))) then
					if (((996 + 1149) <= (12505 - 8401)) and v30(v65.SoulReaper, nil, nil, not v16:IsInMeleeRange(3 + 2))) then
						return "soul_reaper cooldowns 36";
					end
				end
				if (((5339 - 2650) < (19169 - 14324)) and v65.DeathAndDecay:IsReady() and v51 and v15:BuffDown(v65.DeathAndDecayBuff) and v81 and ((v15:BuffUp(v65.PillarofFrostBuff) and (v15:BuffRemains(v65.PillarofFrostBuff) > (1915 - (716 + 1194))) and (v15:BuffRemains(v65.PillarofFrostBuff) < (1 + 10))) or (v15:BuffDown(v65.PillarofFrostBuff) and (v65.PillarofFrost:CooldownRemains() > (2 + 8))) or (v91 < (514 - (74 + 429)))) and ((v94 > (9 - 4)) or (v65.CleavingStrikes:IsAvailable() and (v94 >= (1 + 1))))) then
					if (v30(v67.DaDPlayer) or ((5314 - 2992) > (1856 + 766))) then
						return "death_and_decay cooldowns 38";
					end
				end
				break;
			end
			if ((v155 == (8 - 5)) or ((11210 - 6676) == (2515 - (279 + 154)))) then
				if ((v65.FrostwyrmsFury:IsCastable() and (((v94 == (779 - (454 + 324))) and ((v65.PillarofFrost:IsAvailable() and (v15:BuffRemains(v65.PillarofFrostBuff) < (v15:GCD() * (2 + 0))) and v15:BuffUp(v65.PillarofFrostBuff) and not v65.Obliteration:IsAvailable()) or not v65.PillarofFrost:IsAvailable())) or (v91 < (20 - (12 + 5))))) or ((848 + 723) > (4757 - 2890))) then
					if (v30(v65.FrostwyrmsFury, v60, nil, not v16:IsInRange(15 + 25)) or ((3747 - (277 + 816)) >= (12802 - 9806))) then
						return "frostwyrms_fury cooldowns 28";
					end
				end
				if (((5161 - (1058 + 125)) > (395 + 1709)) and v65.FrostwyrmsFury:IsCastable() and (v94 >= (977 - (815 + 160))) and v65.PillarofFrost:IsAvailable() and v15:BuffUp(v65.PillarofFrostBuff) and (v15:BuffRemains(v65.PillarofFrostBuff) < (v15:GCD() * (8 - 6)))) then
					if (((7109 - 4114) > (368 + 1173)) and v30(v65.FrostwyrmsFury, v60, nil, not v16:IsInRange(116 - 76))) then
						return "frostwyrms_fury cooldowns 30";
					end
				end
				if (((5147 - (41 + 1857)) > (2846 - (1222 + 671))) and v65.FrostwyrmsFury:IsCastable() and v65.Obliteration:IsAvailable() and ((v65.PillarofFrost:IsAvailable() and v15:BuffUp(v65.PillarofFrostBuff) and not v107) or (v15:BuffDown(v65.PillarofFrostBuff) and v107 and v65.PillarofFrost:CooldownDown()) or not v65.PillarofFrost:IsAvailable()) and ((v15:BuffRemains(v65.PillarofFrostBuff) < v15:GCD()) or (v15:BuffUp(v65.UnholyStrengthBuff) and (v15:BuffRemains(v65.UnholyStrengthBuff) < v15:GCD()))) and ((v16:DebuffStack(v65.RazoriceDebuff) == (12 - 7)) or (not v71 and not v65.GlacialAdvance:IsAvailable()))) then
					if (v30(v65.FrostwyrmsFury, v60, nil, not v16:IsInRange(57 - 17)) or ((4455 - (229 + 953)) > (6347 - (1111 + 663)))) then
						return "frostwyrms_fury cooldowns 30";
					end
				end
				if (v65.RaiseDead:IsCastable() or ((4730 - (874 + 705)) < (180 + 1104))) then
					if (v30(v65.RaiseDead, nil) or ((1263 + 587) == (3177 - 1648))) then
						return "raise_dead cooldowns 32";
					end
				end
				v155 = 1 + 3;
			end
		end
	end
	local function v122()
		if (((1500 - (642 + 37)) < (485 + 1638)) and v48 and v29) then
			if (((145 + 757) < (5837 - 3512)) and v65.AntiMagicShell:IsCastable() and (v15:RunicPowerDeficit() > (494 - (233 + 221))) and ((46 - 26) < v11.CombatTime())) then
				if (((756 + 102) <= (4503 - (718 + 823))) and v30(v65.AntiMagicShell, v49)) then
					return "antimagic_shell high_prio_actions 2";
				end
			end
			if ((v65.AntiMagicZone:IsCastable() and (v15:RunicPowerDeficit() > (45 + 25)) and v65.Assimilation:IsAvailable() and (v15:BuffUp(v65.BreathofSindragosa) or v65.BreathofSindragosa:CooldownUp() or (not v65.BreathofSindragosa:IsAvailable() and v15:BuffDown(v65.PillarofFrostBuff)))) or ((4751 - (266 + 539)) < (3646 - 2358))) then
				if (v30(v65.AntiMagicZone, v49) or ((4467 - (636 + 589)) == (1345 - 778))) then
					return "antimagic_zone high_prio_actions 4";
				end
			end
		end
		if ((v65.HowlingBlast:IsReady() and v16:DebuffDown(v65.FrostFeverDebuff) and (v94 >= (3 - 1)) and (not v65.Obliteration:IsAvailable() or (v65.Obliteration:IsAvailable() and (v65.PillarofFrost:CooldownDown() or (v15:BuffUp(v65.PillarofFrostBuff) and v15:BuffDown(v65.KillingMachineBuff)))))) or ((672 + 175) >= (459 + 804))) then
			if (v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast)) or ((3268 - (657 + 358)) == (4900 - 3049))) then
				return "howling_blast high_prio_actions 6";
			end
		end
		if ((v65.GlacialAdvance:IsReady() and (v94 >= (4 - 2)) and v83 and v65.Obliteration:IsAvailable() and v65.BreathofSindragosa:IsAvailable() and v15:BuffDown(v65.PillarofFrostBuff) and v15:BuffDown(v65.BreathofSindragosa) and (v65.BreathofSindragosa:CooldownRemains() > v87)) or ((3274 - (1151 + 36)) > (2291 + 81))) then
			if (v30(v65.GlacialAdvance, nil, nil, not v16:IsInRange(27 + 73)) or ((13274 - 8829) < (5981 - (1552 + 280)))) then
				return "glacial_advance high_prio_actions 8";
			end
		end
		if ((v65.GlacialAdvance:IsReady() and (v94 >= (836 - (64 + 770))) and v83 and v65.BreathofSindragosa:IsAvailable() and v15:BuffDown(v65.BreathofSindragosa) and (v65.BreathofSindragosa:CooldownRemains() > v87)) or ((1235 + 583) == (192 - 107))) then
			if (((112 + 518) < (3370 - (157 + 1086))) and v30(v65.GlacialAdvance, nil, nil, not v16:IsInRange(200 - 100))) then
				return "glacial_advance high_prio_actions 10";
			end
		end
		if ((v65.GlacialAdvance:IsReady() and (v94 >= (8 - 6)) and v83 and not v65.BreathofSindragosa:IsAvailable() and v65.Obliteration:IsAvailable() and v15:BuffDown(v65.PillarofFrostBuff)) or ((2972 - 1034) == (3431 - 917))) then
			if (((5074 - (599 + 220)) >= (109 - 54)) and v30(v65.GlacialAdvance, nil, nil, not v16:IsInRange(2031 - (1813 + 118)))) then
				return "glacial_advance high_prio_actions 12";
			end
		end
		if (((2193 + 806) > (2373 - (841 + 376))) and v65.FrostStrike:IsReady() and (v94 == (1 - 0)) and v83 and v65.Obliteration:IsAvailable() and v65.BreathofSindragosa:IsAvailable() and v15:BuffDown(v65.PillarofFrostBuff) and v15:BuffDown(v65.BreathofSindragosa) and (v65.BreathofSindragosa:CooldownRemains() > v87)) then
			if (((546 + 1804) > (3152 - 1997)) and v30(v65.FrostStrike, v59, nil, not v16:IsSpellInRange(v65.FrostStrike))) then
				return "frost_strike high_prio_actions 14";
			end
		end
		if (((4888 - (464 + 395)) <= (12454 - 7601)) and v65.FrostStrike:IsReady() and (v94 == (1 + 0)) and v83 and v65.BreathofSindragosa:IsAvailable() and v15:BuffDown(v65.BreathofSindragosa) and (v65.BreathofSindragosa:CooldownRemains() > v87)) then
			if (v30(v65.FrostStrike, v59, nil, not v16:IsSpellInRange(v65.FrostStrike)) or ((1353 - (467 + 370)) > (7096 - 3662))) then
				return "frost_strike high_prio_actions 16";
			end
		end
		if (((2970 + 1076) >= (10397 - 7364)) and v65.FrostStrike:IsReady() and (v94 == (1 + 0)) and v83 and not v65.BreathofSindragosa:IsAvailable() and v65.Obliteration:IsAvailable() and v15:BuffDown(v65.PillarofFrostBuff)) then
			if (v30(v65.FrostStrike, v59, nil, not v16:IsSpellInRange(v65.FrostStrike)) or ((6325 - 3606) <= (1967 - (150 + 370)))) then
				return "frost_strike high_prio_actions 18";
			end
		end
		if ((v65.RemorselessWinter:IsReady() and (v73 or v81)) or ((5416 - (74 + 1208)) < (9656 - 5730))) then
			if (v30(v65.RemorselessWinter, nil, nil, not v16:IsInMeleeRange(37 - 29)) or ((117 + 47) >= (3175 - (14 + 376)))) then
				return "remorseless_winter high_prio_actions 20";
			end
		end
	end
	local function v123()
		local v156 = 0 - 0;
		while true do
			if ((v156 == (1 + 0)) or ((462 + 63) == (2012 + 97))) then
				if (((96 - 63) == (25 + 8)) and v65.GlacialAdvance:IsReady() and (v15:BuffStack(v65.KillingMachineBuff) < (80 - (23 + 55))) and (v15:BuffRemains(v65.PillarofFrostBuff) < v15:GCD()) and v15:BuffDown(v65.DeathAndDecayBuff)) then
					if (((7237 - 4183) <= (2680 + 1335)) and v30(v65.GlacialAdvance, nil, nil, not v16:IsInRange(90 + 10))) then
						return "glacial_advance obliteration 6";
					end
				end
				if (((2900 - 1029) < (1064 + 2318)) and v65.Frostscythe:IsReady() and v15:BuffUp(v65.KillingMachineBuff) and (v85 or ((v94 > (904 - (652 + 249))) and v15:BuffDown(v65.DeathAndDecayBuff) and v66.Fyralath:IsEquipped() and ((v66.Fyralath:CooldownRemains() < (7 - 4)) or v16:DebuffDown(v65.MarkofFyralathDebuff))))) then
					if (((3161 - (708 + 1160)) <= (5879 - 3713)) and v30(v65.Frostscythe, nil, nil, not v16:IsInMeleeRange(14 - 6))) then
						return "frostscythe obliteration 8";
					end
				end
				v156 = 29 - (10 + 17);
			end
			if ((v156 == (1 + 1)) or ((4311 - (1400 + 332)) < (235 - 112))) then
				if ((v65.Obliterate:IsReady() and v15:BuffUp(v65.KillingMachineBuff) and not v85) or ((2754 - (242 + 1666)) >= (1014 + 1354))) then
					if (v66.Fyralath:IsEquipped() or ((1471 + 2541) <= (2862 + 496))) then
						if (((2434 - (850 + 90)) <= (5262 - 2257)) and v69.CastTargetIf(v65.Obliterate, v93, "min", v112, nil, not v16:IsInMeleeRange(1395 - (360 + 1030)))) then
							return "obliterate (fyralath) obliteration 10";
						end
					elseif (v69.CastTargetIf(v65.Obliterate, v93, "max", v113, nil, not v16:IsInMeleeRange(5 + 0)) or ((8780 - 5669) == (2935 - 801))) then
						return "obliterate obliteration 10";
					end
				end
				if (((4016 - (909 + 752)) == (3578 - (109 + 1114))) and v65.HowlingBlast:IsReady() and v15:BuffDown(v65.KillingMachineBuff) and (v16:DebuffDown(v65.FrostFeverDebuff) or (v15:BuffUp(v65.RimeBuff) and v15:HasTier(54 - 24, 1 + 1) and not v83))) then
					if (v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast)) or ((830 - (6 + 236)) <= (273 + 159))) then
						return "howling_blast obliteration 12";
					end
				end
				v156 = 3 + 0;
			end
			if (((11312 - 6515) >= (6803 - 2908)) and (v156 == (1136 - (1076 + 57)))) then
				if (((589 + 2988) == (4266 - (579 + 110))) and v65.GlacialAdvance:IsReady() and v15:BuffDown(v65.KillingMachineBuff) and ((not v71 and (not v65.Avalanche:IsAvailable() or (v16:DebuffStack(v65.RazoriceDebuff) < (1 + 4)) or (v16:DebuffRemains(v65.RazoriceDebuff) < (v15:GCD() * (3 + 0))))) or ((v83 or (v15:Rune() < (2 + 0))) and (v94 > (408 - (174 + 233)))))) then
					if (((10597 - 6803) > (6481 - 2788)) and v30(v65.GlacialAdvance, nil, nil, not v16:IsInRange(45 + 55))) then
						return "glacial_advance obliteration 14";
					end
				end
				if ((v65.FrostStrike:IsReady() and v15:BuffDown(v65.KillingMachineBuff) and ((v15:Rune() < (1176 - (663 + 511))) or v83 or ((v16:DebuffStack(v65.RazoriceDebuff) == (5 + 0)) and v65.ShatteringBlade:IsAvailable())) and not v89 and (not v65.GlacialAdvance:IsAvailable() or (v95 == (1 + 0)))) or ((3930 - 2655) == (2483 + 1617))) then
					local v167 = 0 - 0;
					while true do
						if ((v167 == (0 - 0)) or ((760 + 831) >= (6967 - 3387))) then
							if (((701 + 282) <= (166 + 1642)) and v66.Fyralath:IsEquipped()) then
								if (v69.CastTargetIf(v65.FrostStrike, v93, "min", v112, nil, not v16:IsInMeleeRange(727 - (478 + 244)), v59) or ((2667 - (440 + 77)) <= (545 + 652))) then
									return "frost_strike (fyralath) obliteration 16";
								end
							elseif (((13794 - 10025) >= (2729 - (655 + 901))) and v69.CastTargetIf(v65.FrostStrike, v93, "max", v113, nil, not v16:IsInMeleeRange(1 + 4))) then
								return "frost_strike obliteration 18";
							end
							if (((1137 + 348) == (1003 + 482)) and v65.HowlingBlast:IsReady() and v15:BuffUp(v65.RimeBuff) and v15:BuffDown(v65.KillingMachineBuff)) then
								if (v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast)) or ((13354 - 10039) <= (4227 - (695 + 750)))) then
									return "howling_blast obliteration 18";
								end
							end
							v167 = 3 - 2;
						end
						if ((v167 == (2 - 0)) or ((3523 - 2647) >= (3315 - (285 + 66)))) then
							if ((v29 and v65.ArcaneTorrent:IsReady() and (v15:Rune() < (2 - 1)) and (v15:RunicPower() < (1340 - (682 + 628)))) or ((360 + 1872) > (2796 - (176 + 123)))) then
								if (v30(v65.ArcaneTorrent, v55) or ((883 + 1227) <= (241 + 91))) then
									return "arcane_torrent obliteration 28";
								end
							end
							if (((3955 - (239 + 30)) > (863 + 2309)) and v65.GlacialAdvance:IsReady() and not v89 and (v94 >= (2 + 0))) then
								if (v30(v65.GlacialAdvance, nil, nil, not v16:IsInRange(176 - 76)) or ((13958 - 9484) < (1135 - (306 + 9)))) then
									return "glacial_advance obliteration 26";
								end
							end
							v167 = 10 - 7;
						end
						if (((745 + 3534) >= (1769 + 1113)) and (v167 == (2 + 1))) then
							if ((v65.FrostStrike:IsReady() and not v89 and (not v65.GlacialAdvance:IsAvailable() or (v94 == (2 - 1)))) or ((3404 - (1140 + 235)) >= (2241 + 1280))) then
								if (v66.Fyralath:IsEquipped() or ((1868 + 169) >= (1192 + 3450))) then
									if (((1772 - (33 + 19)) < (1610 + 2848)) and v69.CastTargetIf(v65.FrostStrike, v93, "min", v112, nil, not v16:IsInMeleeRange(14 - 9), v59)) then
										return "frost_strike (fyralath) obliteration 28";
									end
								elseif (v69.CastTargetIf(v65.FrostStrike, v93, "max", v113, nil, not v16:IsInMeleeRange(3 + 2), v59) or ((854 - 418) > (2833 + 188))) then
									return "frost_strike obliteration 28";
								end
							end
							if (((1402 - (586 + 103)) <= (78 + 769)) and v65.HowlingBlast:IsReady() and (v15:BuffUp(v65.RimeBuff))) then
								if (((6631 - 4477) <= (5519 - (1309 + 179))) and v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast))) then
									return "howling_blast obliteration 30";
								end
							end
							v167 = 6 - 2;
						end
						if (((2009 + 2606) == (12393 - 7778)) and (v167 == (1 + 0))) then
							if ((v65.FrostStrike:IsReady() and v15:BuffDown(v65.KillingMachineBuff) and not v89 and (not v65.GlacialAdvance:IsAvailable() or (v94 == (1 - 0)))) or ((7552 - 3762) == (1109 - (295 + 314)))) then
								if (((218 - 129) < (2183 - (1300 + 662))) and v66.Fyralath:IsEquipped()) then
									if (((6449 - 4395) >= (3176 - (1178 + 577))) and v69.CastTargetIf(v65.FrostStrike, v93, "min", v112, nil, not v16:IsInMeleeRange(3 + 2), v59)) then
										return "frost_strike (fyralath) obliteration 20";
									end
								elseif (((2045 - 1353) < (4463 - (851 + 554))) and v69.CastTargetIf(v65.FrostStrike, v93, "max", v113, nil, not v16:IsInMeleeRange(5 + 0), v59)) then
									return "frost_strike obliteration 20";
								end
							end
							if ((v65.HowlingBlast:IsReady() and v15:BuffDown(v65.KillingMachineBuff) and (v15:RunicPower() < (83 - 53))) or ((7066 - 3812) == (1957 - (115 + 187)))) then
								if (v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast)) or ((993 + 303) == (4649 + 261))) then
									return "howling_blast obliteration 22";
								end
							end
							v167 = 7 - 5;
						end
						if (((4529 - (160 + 1001)) == (2947 + 421)) and ((3 + 1) == v167)) then
							if (((5410 - 2767) < (4173 - (237 + 121))) and v65.Obliterate:IsReady()) then
								if (((2810 - (525 + 372)) > (933 - 440)) and v66.Fyralath:IsEquipped()) then
									if (((15623 - 10868) > (3570 - (96 + 46))) and v69.CastTargetIf(v65.Obliterate, v93, "min", v112, nil, not v16:IsInMeleeRange(782 - (643 + 134)))) then
										return "obliterate (fyralath) obliteration 32";
									end
								elseif (((499 + 882) <= (5680 - 3311)) and v69.CastTargetIf(v65.Obliterate, v93, "max", v113, nil, not v16:IsInMeleeRange(18 - 13))) then
									return "obliterate obliteration 32";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v156 == (0 + 0)) or ((9504 - 4661) == (8347 - 4263))) then
				if (((5388 - (316 + 403)) > (242 + 121)) and v65.HowlingBlast:IsReady() and (v15:BuffStack(v65.KillingMachineBuff) < (5 - 3)) and (v15:BuffRemains(v65.PillarofFrostBuff) < v15:GCD()) and v15:BuffUp(v65.RimeBuff)) then
					if (v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast)) or ((679 + 1198) >= (7902 - 4764))) then
						return "howling_blast obliteration 4";
					end
				end
				if (((3361 + 1381) >= (1169 + 2457)) and v65.FrostStrike:IsReady() and ((v94 <= (3 - 2)) or not v65.GlacialAdvance:IsAvailable()) and (v15:BuffStack(v65.KillingMachineBuff) < (9 - 7)) and (v15:BuffRemains(v65.PillarofFrostBuff) < v15:GCD()) and v15:BuffDown(v65.DeathAndDecayBuff)) then
					if (v69.CastTargetIf(v65.FrostStrike, v93, "min", v112, nil, not v16:IsSpellInRange(v65.FrostStrike), v59) or ((9431 - 4891) == (53 + 863))) then
						return "frost_strike obliteration 4";
					end
				end
				v156 = 1 - 0;
			end
		end
	end
	local function v124()
		local v157 = 0 + 0;
		while true do
			if ((v157 == (0 - 0)) or ((1173 - (12 + 5)) > (16876 - 12531))) then
				if (((4772 - 2535) < (9031 - 4782)) and v84) then
					if (v65.BloodFury:IsCastable() or ((6653 - 3970) < (5 + 18))) then
						if (((2670 - (1656 + 317)) <= (737 + 89)) and v30(v65.BloodFury, v55)) then
							return "blood_fury racials 2";
						end
					end
					if (((886 + 219) <= (3126 - 1950)) and v65.Berserking:IsCastable()) then
						if (((16629 - 13250) <= (4166 - (5 + 349))) and v30(v65.Berserking, v55)) then
							return "berserking racials 4";
						end
					end
					if (v65.ArcanePulse:IsCastable() or ((3742 - 2954) >= (2887 - (266 + 1005)))) then
						if (((1222 + 632) <= (11529 - 8150)) and v30(v65.ArcanePulse, v55, nil, not v16:IsInRange(9 - 1))) then
							return "arcane_pulse racials 6";
						end
					end
					if (((6245 - (561 + 1135)) == (5927 - 1378)) and v65.LightsJudgment:IsCastable()) then
						if (v30(v65.LightsJudgment, v55, nil, not v16:IsSpellInRange(v65.LightsJudgment)) or ((9933 - 6911) >= (4090 - (507 + 559)))) then
							return "lights_judgment racials 8";
						end
					end
					if (((12094 - 7274) > (6797 - 4599)) and v65.AncestralCall:IsCastable()) then
						if (v30(v65.AncestralCall, v55) or ((1449 - (212 + 176)) >= (5796 - (250 + 655)))) then
							return "ancestral_call racials 10";
						end
					end
					if (((3719 - 2355) <= (7815 - 3342)) and v65.Fireblood:IsCastable()) then
						if (v30(v65.Fireblood, v55) or ((5624 - 2029) <= (1959 - (1869 + 87)))) then
							return "fireblood racials 12";
						end
					end
				end
				if ((v65.BagofTricks:IsCastable() and v65.Obliteration:IsAvailable() and v15:BuffDown(v65.PillarofFrostBuff) and v15:BuffUp(v65.UnholyStrengthBuff)) or ((16204 - 11532) == (5753 - (484 + 1417)))) then
					if (((3341 - 1782) == (2612 - 1053)) and v30(v65.BagofTricks, v55, nil, not v16:IsInRange(813 - (48 + 725)))) then
						return "bag_of_tricks racials 14";
					end
				end
				v157 = 1 - 0;
			end
			if ((v157 == (2 - 1)) or ((1019 + 733) <= (2105 - 1317))) then
				if ((v65.BagofTricks:IsCastable() and not v65.Obliteration:IsAvailable() and v15:BuffUp(v65.PillarofFrostBuff) and ((v15:BuffUp(v65.UnholyStrengthBuff) and (v15:BuffRemains(v65.UnholyStrengthBuff) < (v15:GCD() * (1 + 2)))) or (v15:BuffRemains(v65.PillarofFrostBuff) < (v15:GCD() * (1 + 2))))) or ((4760 - (152 + 701)) == (1488 - (430 + 881)))) then
					if (((1329 + 2141) > (1450 - (557 + 338))) and v30(v65.BagofTricks, v55, nil, not v16:IsInRange(12 + 28))) then
						return "bag_of_tricks racials 16";
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v158 = 0 - 0;
		while true do
			if ((v158 == (13 - 9)) or ((2581 - 1609) == (1389 - 744))) then
				if (((3983 - (499 + 302)) >= (2981 - (39 + 827))) and v65.FrostStrike:IsReady() and not v89) then
					if (((10746 - 6853) < (9891 - 5462)) and v30(v65.FrostStrike, v59, nil, not v16:IsInMeleeRange(19 - 14))) then
						return "frost_strike single_target 28";
					end
				end
				break;
			end
			if ((v158 == (2 - 0)) or ((246 + 2621) < (5575 - 3670))) then
				if ((v65.FrostStrike:IsReady() and not v89 and (v83 or (v15:RunicPowerDeficit() < (4 + 21 + ((7 - 2) * v22(v15:BuffUp(v65.RuneofHysteriaBuff))))) or ((v16:DebuffStack(v65.RazoriceDebuff) == (109 - (103 + 1))) and v65.ShatteringBlade:IsAvailable()))) or ((2350 - (475 + 79)) >= (8757 - 4706))) then
					if (((5180 - 3561) <= (486 + 3270)) and v30(v65.FrostStrike, v59, nil, not v16:IsInMeleeRange(5 + 0))) then
						return "frost_strike single_target 14";
					end
				end
				if (((2107 - (1395 + 108)) == (1757 - 1153)) and v65.HowlingBlast:IsReady() and v82) then
					if (v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast)) or ((5688 - (7 + 1197)) == (393 + 507))) then
						return "howling_blast single_target 18";
					end
				end
				if ((v65.GlacialAdvance:IsReady() and not v89 and not v71 and ((v16:DebuffStack(v65.RazoriceDebuff) < (2 + 3)) or (v16:DebuffRemains(v65.RazoriceDebuff) < (v15:GCD() * (322 - (27 + 292)))))) or ((13066 - 8607) <= (1418 - 305))) then
					if (((15231 - 11599) > (6700 - 3302)) and v30(v65.GlacialAdvance, nil, nil, not v16:IsInRange(190 - 90))) then
						return "glacial_advance single_target 20";
					end
				end
				v158 = 142 - (43 + 96);
			end
			if (((16650 - 12568) <= (11116 - 6199)) and (v158 == (3 + 0))) then
				if (((1365 + 3467) >= (2739 - 1353)) and v65.Obliterate:IsReady() and not v88) then
					if (((53 + 84) == (256 - 119)) and v30(v65.Obliterate, nil, nil, not v16:IsInMeleeRange(2 + 3))) then
						return "obliterate single_target 22";
					end
				end
				if ((v65.HornofWinter:IsReady() and (v15:Rune() < (1 + 3)) and (v15:RunicPowerDeficit() > (1776 - (1414 + 337))) and (not v65.BreathofSindragosa:IsAvailable() or (v65.BreathofSindragosa:CooldownRemains() > (1985 - (1642 + 298))))) or ((4092 - 2522) >= (12462 - 8130))) then
					if (v30(v65.HornofWinter, v61) or ((12060 - 7996) <= (599 + 1220))) then
						return "horn_of_winter single_target 24";
					end
				end
				if ((v29 and v65.ArcaneTorrent:IsReady() and (v15:RunicPowerDeficit() > (16 + 4))) or ((5958 - (357 + 615)) < (1105 + 469))) then
					if (((10859 - 6433) > (148 + 24)) and v30(v65.ArcaneTorrent, v55)) then
						return "arcane_torrent single_target 26";
					end
				end
				v158 = 8 - 4;
			end
			if (((469 + 117) > (31 + 424)) and (v158 == (0 + 0))) then
				if (((2127 - (384 + 917)) == (1523 - (128 + 569))) and v65.FrostStrike:IsReady() and (v15:BuffStack(v65.KillingMachineBuff) < (1545 - (1407 + 136))) and (v15:RunicPowerDeficit() < ((1907 - (687 + 1200)) + ((1714 - (556 + 1154)) * v22(v15:BuffUp(v65.RuneofHysteriaBuff))))) and not v107) then
					if (v30(v65.FrostStrike, v59, nil, not v16:IsInMeleeRange(17 - 12)) or ((4114 - (9 + 86)) > (4862 - (275 + 146)))) then
						return "frost_strike single_target 2";
					end
				end
				if (((329 + 1688) < (4325 - (29 + 35))) and v65.HowlingBlast:IsReady() and v15:BuffUp(v65.RimeBuff) and v15:HasTier(132 - 102, 5 - 3) and (v15:BuffStack(v65.KillingMachineBuff) < (8 - 6))) then
					if (((3072 + 1644) > (1092 - (53 + 959))) and v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast))) then
						return "howling_blast single_target 6";
					end
				end
				if ((v65.Frostscythe:IsReady() and v15:BuffUp(v65.KillingMachineBuff) and v85) or ((3915 - (312 + 96)) == (5678 - 2406))) then
					if (v30(v65.Frostscythe, nil, nil, not v16:IsInMeleeRange(293 - (147 + 138))) or ((1775 - (813 + 86)) >= (2779 + 296))) then
						return "frostscythe single_target 8";
					end
				end
				v158 = 1 - 0;
			end
			if (((4844 - (18 + 474)) > (862 + 1692)) and (v158 == (3 - 2))) then
				if ((v65.Obliterate:IsReady() and (v15:BuffUp(v65.KillingMachineBuff))) or ((5492 - (860 + 226)) < (4346 - (121 + 182)))) then
					if (v30(v65.Obliterate, nil, nil, not v16:IsInMeleeRange(1 + 4)) or ((3129 - (988 + 252)) >= (383 + 3000))) then
						return "obliterate single_target 10";
					end
				end
				if (((593 + 1299) <= (4704 - (49 + 1921))) and v65.HowlingBlast:IsReady() and v15:BuffUp(v65.RimeBuff) and (v65.Icebreaker:TalentRank() == (892 - (223 + 667)))) then
					if (((1975 - (51 + 1)) < (3817 - 1599)) and v30(v65.HowlingBlast, nil, nil, not v16:IsSpellInRange(v65.HowlingBlast))) then
						return "howling_blast single_target 12";
					end
				end
				if (((4653 - 2480) > (1504 - (146 + 979))) and v65.HornofWinter:IsReady() and (v15:Rune() < (2 + 2)) and (v15:RunicPowerDeficit() > ((630 - (311 + 294)) + ((13 - 8) * v22(v15:BuffUp(v65.RuneofHysteriaBuff))))) and v65.Obliteration:IsAvailable() and v65.BreathofSindragosa:IsAvailable()) then
					if (v30(v65.HornofWinter, v61) or ((1098 + 1493) == (4852 - (496 + 947)))) then
						return "horn_of_winter single_target 12";
					end
				end
				v158 = 1360 - (1233 + 125);
			end
		end
	end
	local function v126()
		local v159 = 0 + 0;
		local v160;
		while true do
			if (((4050 + 464) > (632 + 2692)) and ((1647 - (963 + 682)) == v159)) then
				if (((v15:RunicPowerDeficit() > (9 + 1)) and (v65.BreathofSindragosa:CooldownRemains() < (1514 - (504 + 1000)))) or ((141 + 67) >= (4397 + 431))) then
					v87 = (((v65.BreathofSindragosa:CooldownRemains() + 1 + 0) / v160) / ((v15:Rune() + (1 - 0)) * (v15:RunicPower() + 18 + 2))) * (59 + 41);
				else
					v87 = 184 - (156 + 26);
				end
				v88 = (v15:Rune() < (3 + 1)) and v65.Obliteration:IsAvailable() and (v65.PillarofFrost:CooldownRemains() < v86);
				v89 = (v65.BreathofSindragosa:IsAvailable() and (v65.BreathofSindragosa:CooldownRemains() < v87)) or (v65.Obliteration:IsAvailable() and (v15:RunicPower() < (54 - 19)) and (v65.PillarofFrost:CooldownRemains() < v86));
				break;
			end
			if ((v159 == (165 - (149 + 15))) or ((2543 - (890 + 70)) > (3684 - (39 + 78)))) then
				v83 = (v65.UnleashedFrenzy:IsAvailable() and ((v15:BuffRemains(v65.UnleashedFrenzyBuff) < (v160 * (485 - (14 + 468)))) or (v15:BuffStack(v65.UnleashedFrenzyBuff) < (6 - 3)))) or (v65.IcyTalons:IsAvailable() and ((v15:BuffRemains(v65.IcyTalonsBuff) < (v160 * (8 - 5))) or (v15:BuffStack(v65.IcyTalonsBuff) < (2 + 1))));
				v84 = (v65.PillarofFrost:IsAvailable() and v15:BuffUp(v65.PillarofFrostBuff) and ((v65.Obliteration:IsAvailable() and (v15:BuffRemains(v65.PillarofFrostBuff) > (7 + 3))) or not v65.Obliteration:IsAvailable())) or (not v65.PillarofFrost:IsAvailable() and v15:BuffUp(v65.EmpowerRuneWeaponBuff)) or (not v65.PillarofFrost:IsAvailable() and not v65.EmpowerRuneWeapon:IsAvailable()) or ((v94 >= (1 + 1)) and v15:BuffUp(v65.PillarofFrostBuff));
				v85 = v65.Frostscythe:IsAvailable() and (v15:BuffUp(v65.KillingMachineBuff) or (v94 >= (2 + 1))) and ((not v65.ImprovedObliterate:IsAvailable() and not v65.FrigidExecutioner:IsAvailable()) or not v65.CleavingStrikes:IsAvailable() or (v65.CleavingStrikes:IsAvailable() and ((v94 > (3 + 5)) or (v15:BuffDown(v65.DeathAndDecayBuff) and (v94 > (7 - 3))))));
				if (((v15:RunicPower() < (35 + 0)) and (v15:Rune() < (6 - 4)) and (v65.PillarofFrost:CooldownRemains() < (1 + 9))) or ((1364 - (12 + 39)) == (739 + 55))) then
					v86 = (((v65.PillarofFrost:CooldownRemains() + (2 - 1)) / v160) / ((v15:Rune() + (10 - 7)) * (v15:RunicPower() + 2 + 3))) * (53 + 47);
				else
					v86 = 7 - 4;
				end
				v159 = 2 + 0;
			end
			if (((15339 - 12165) > (4612 - (1596 + 114))) and (v159 == (0 - 0))) then
				v160 = v15:GCD() + (713.25 - (164 + 549));
				v80 = (v94 == (1439 - (1059 + 379))) or not v28;
				v81 = (v94 >= (2 - 0)) and v28;
				v82 = v15:BuffUp(v65.RimeBuff) and (v65.RageoftheFrozenChampion:IsAvailable() or v65.Avalanche:IsAvailable() or v65.Icebreaker:IsAvailable());
				v159 = 1 + 0;
			end
		end
	end
	local function v127()
		local v161 = 0 + 0;
		while true do
			if (((4512 - (145 + 247)) <= (3496 + 764)) and (v161 == (1 + 0))) then
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				v161 = 5 - 3;
			end
			if ((v161 == (1 + 2)) or ((761 + 122) > (7757 - 2979))) then
				if (v28 or ((4340 - (254 + 466)) >= (5451 - (544 + 16)))) then
					v94 = #v93;
				else
					v94 = 2 - 1;
				end
				if (((4886 - (294 + 334)) > (1190 - (236 + 17))) and (v69.TargetIsValid() or v15:AffectingCombat())) then
					v90 = v11.BossFightRemains();
					v91 = v90;
					if ((v91 == (4790 + 6321)) or ((3791 + 1078) < (3411 - 2505))) then
						v91 = v11.FightRemains(v93, false);
					end
				end
				v161 = 18 - 14;
			end
			if ((v161 == (0 + 0)) or ((1009 + 216) > (5022 - (413 + 381)))) then
				v64();
				v27 = EpicSettings.Toggles['ooc'];
				v161 = 1 + 0;
			end
			if (((7077 - 3749) > (5813 - 3575)) and (v161 == (1974 - (582 + 1388)))) then
				if (((6540 - 2701) > (1006 + 399)) and v69.TargetIsValid()) then
					if (not v15:AffectingCombat() or ((1657 - (326 + 38)) <= (1499 - 992))) then
						local v169 = v115();
						if (v169 or ((4134 - 1238) < (1425 - (47 + 573)))) then
							return v169;
						end
					end
					if (((817 + 1499) == (9836 - 7520)) and v65.DeathStrike:IsReady() and not v70) then
						if (v30(v65.DeathStrike, nil, nil, not v16:IsInMeleeRange(8 - 3)) or ((4234 - (1269 + 395)) == (2025 - (76 + 416)))) then
							return "death_strike low hp or proc";
						end
					end
					v126();
					local v168 = v122();
					if (v168 or ((1326 - (319 + 124)) == (3337 - 1877))) then
						return v168;
					end
					if (v29 or ((5626 - (564 + 443)) <= (2765 - 1766))) then
						local v170 = v121();
						if (v170 or ((3868 - (337 + 121)) > (12060 - 7944))) then
							return v170;
						end
					end
					if (v29 or ((3007 - 2104) >= (4970 - (1261 + 650)))) then
						local v171 = v124();
						if (v171 or ((1683 + 2293) < (4553 - 1696))) then
							return v171;
						end
						local v171 = v116();
						if (((6747 - (772 + 1045)) > (326 + 1981)) and v171) then
							return v171;
						end
					end
					if ((v65.ColdHeart:IsAvailable() and (v15:BuffDown(v65.KillingMachineBuff) or v65.BreathofSindragosa:IsAvailable()) and ((v16:DebuffStack(v65.RazoriceDebuff) == (149 - (102 + 42))) or (not v71 and not v65.GlacialAdvance:IsAvailable() and not v65.Avalanche:IsAvailable()) or (v91 <= (v15:GCD() + (1844.5 - (1524 + 320)))))) or ((5316 - (1049 + 221)) < (1447 - (18 + 138)))) then
						local v172 = v120();
						if (v172 or ((10380 - 6139) == (4647 - (67 + 1035)))) then
							return v172;
						end
					end
					if ((v15:BuffUp(v65.BreathofSindragosa) and v65.Obliteration:IsAvailable() and v15:BuffUp(v65.PillarofFrostBuff)) or ((4396 - (136 + 212)) > (17983 - 13751))) then
						local v173 = 0 + 0;
						local v174;
						while true do
							if ((v173 == (1 + 0)) or ((3354 - (240 + 1364)) >= (4555 - (1050 + 32)))) then
								if (((11304 - 8138) == (1873 + 1293)) and v30(v65.Pool)) then
									return "pool for BreathOblit()";
								end
								break;
							end
							if (((2818 - (331 + 724)) < (301 + 3423)) and (v173 == (644 - (269 + 375)))) then
								v174 = v119();
								if (((782 - (267 + 458)) <= (847 + 1876)) and v174) then
									return v174;
								end
								v173 = 1 - 0;
							end
						end
					end
					if ((v15:BuffUp(v65.BreathofSindragosa) and (not v65.Obliteration:IsAvailable() or (v65.Obliteration:IsAvailable() and v15:BuffDown(v65.PillarofFrostBuff)))) or ((2888 - (667 + 151)) == (1940 - (1410 + 87)))) then
						local v175 = 1897 - (1504 + 393);
						local v176;
						while true do
							if ((v175 == (0 - 0)) or ((7017 - 4312) == (2189 - (461 + 335)))) then
								v176 = v118();
								if (v176 or ((589 + 4012) < (1822 - (1730 + 31)))) then
									return v176;
								end
								v175 = 1668 - (728 + 939);
							end
							if ((v175 == (3 - 2)) or ((2819 - 1429) >= (10869 - 6125))) then
								if (v30(v65.Pool) or ((3071 - (138 + 930)) > (3504 + 330))) then
									return "pool for Breath()";
								end
								break;
							end
						end
					end
					if ((v65.Obliteration:IsAvailable() and v15:BuffUp(v65.PillarofFrostBuff) and v15:BuffDown(v65.BreathofSindragosa)) or ((122 + 34) > (3354 + 559))) then
						local v177 = 0 - 0;
						local v178;
						while true do
							if (((1961 - (459 + 1307)) == (2065 - (474 + 1396))) and (v177 == (1 - 0))) then
								if (((2910 + 195) >= (6 + 1790)) and v30(v65.Pool)) then
									return "pool for Obliteration()";
								end
								break;
							end
							if (((12543 - 8164) >= (271 + 1860)) and (v177 == (0 - 0))) then
								v178 = v123();
								if (((16764 - 12920) >= (2634 - (562 + 29))) and v178) then
									return v178;
								end
								v177 = 1 + 0;
							end
						end
					end
					if (((v94 >= (1421 - (374 + 1045))) and v28) or ((2558 + 674) <= (8480 - 5749))) then
						local v179 = 638 - (448 + 190);
						local v180;
						while true do
							if (((1584 + 3321) == (2215 + 2690)) and (v179 == (0 + 0))) then
								v180 = v117();
								if (v180 or ((15902 - 11766) >= (13706 - 9295))) then
									return v180;
								end
								break;
							end
						end
					end
					if ((v94 == (1495 - (1307 + 187))) or not v28 or ((11730 - 8772) == (9405 - 5388))) then
						local v181 = 0 - 0;
						local v182;
						while true do
							if (((1911 - (232 + 451)) >= (777 + 36)) and (v181 == (0 + 0))) then
								v182 = v125();
								if (v182 or ((4019 - (510 + 54)) > (8159 - 4109))) then
									return v182;
								end
								break;
							end
						end
					end
					if (((279 - (13 + 23)) == (472 - 229)) and v11.CastAnnotated(v65.Pool, false, "WAIT")) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if ((v161 == (2 - 0)) or ((492 - 221) > (2660 - (830 + 258)))) then
				v70 = not v111();
				v93 = v15:GetEnemiesInMeleeRange(17 - 12);
				v161 = 2 + 1;
			end
		end
	end
	local function v128()
		local v162 = 0 + 0;
		while true do
			if (((4180 - (860 + 581)) < (12146 - 8853)) and (v162 == (0 + 0))) then
				v64();
				v11.Print("Frost DK rotation by Epic. Work in progress Gojira");
				break;
			end
		end
	end
	v11.SetAPL(492 - (237 + 4), v127, v128);
end;
return v1["Epix_DeathKnight_FrostDK.lua"](...);

