local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((2009 + 2160) >= (2983 - (588 + 208))) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_DeathKnight_FrostDK.lua"] = function(...)
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
	local v18 = v9.Pet;
	local v19 = v9.Macro;
	local v20 = v9.Commons.Everyone.num;
	local v21 = v9.Commons.Everyone.bool;
	local v22 = math.min;
	local v23 = math.abs;
	local v24 = math.max;
	local v25 = false;
	local v26 = false;
	local v27 = false;
	local v28 = v9.Cast;
	local v29 = table.insert;
	local v30 = GetTime;
	local v31 = strsplit;
	local v32 = GetInventoryItemLink;
	local v33;
	local v34;
	local v35;
	local v36;
	local v37 = 0 - 0;
	local v38;
	local v39 = 1800 - (884 + 916);
	local v40;
	local v41;
	local v42;
	local v43;
	local v44 = 0 - 0;
	local v45 = 0 + 0;
	local v46;
	local v47;
	local v48;
	local v49;
	local v50;
	local v51;
	local v52;
	local v53;
	local v54;
	local v55 = 653 - (232 + 421);
	local v56;
	local v57;
	local v58;
	local v59;
	local v60;
	local v61;
	local function v62()
		local v127 = 1889 - (1569 + 320);
		while true do
			if (((345 + 1061) == (268 + 1138)) and (v127 == (9 - 6))) then
				v44 = EpicSettings.Settings['UseDeathStrikeHP'] or (605 - (316 + 289));
				v45 = EpicSettings.Settings['UseDarkSuccorHP'] or (0 - 0);
				v46 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v127 = 1 + 3;
			end
			if (((2984 - (666 + 787)) < (4696 - (360 + 65))) and (v127 == (6 + 0))) then
				v53 = EpicSettings.Settings['RacialsOffGCD'];
				v54 = EpicSettings.Settings['DisableBoSPooling'];
				v55 = EpicSettings.Settings['AMSAbsorbPercent'] or (254 - (79 + 175));
				v127 = 10 - 3;
			end
			if (((496 + 139) == (1946 - 1311)) and (v127 == (3 - 1))) then
				v40 = EpicSettings.Settings['InterruptWithStun'] or (899 - (503 + 396));
				v41 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (181 - (92 + 89));
				v42 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v127 = 2 + 1;
			end
			if (((1997 + 1376) <= (13925 - 10369)) and (v127 == (1 + 6))) then
				v56 = EpicSettings.Settings['BreathOfSindragosaGCD'];
				v57 = EpicSettings.Settings['FrostStrikeGCD'];
				v58 = EpicSettings.Settings['FrostwyrmsFuryGCD'];
				v127 = 17 - 9;
			end
			if (((5 + 0) == v127) or ((1572 + 1719) < (9989 - 6709))) then
				v50 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v51 = EpicSettings.Settings['SacrificialPactGCD'];
				v52 = EpicSettings.Settings['MindFreezeOffGCD'];
				v127 = 1 + 5;
			end
			if (((6688 - 2302) >= (2117 - (485 + 759))) and (v127 == (18 - 10))) then
				v59 = EpicSettings.Settings['HornOfWinterGCD'];
				v60 = EpicSettings.Settings['HypothermicPresenceGCD'];
				v61 = EpicSettings.Settings['PillarOfFrostGCD'];
				break;
			end
			if (((2110 - (442 + 747)) <= (2237 - (832 + 303))) and ((946 - (88 + 858)) == v127)) then
				v33 = EpicSettings.Settings['UseRacials'];
				v35 = EpicSettings.Settings['UseHealingPotion'];
				v36 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v127 = 1 + 0;
			end
			if (((194 + 4512) >= (1752 - (766 + 23))) and (v127 == (19 - 15))) then
				v47 = EpicSettings.Settings['AntiMagicShellGCD'];
				v48 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v49 = EpicSettings.Settings['DeathAndDecayGCD'];
				v127 = 6 - 1;
			end
			if ((v127 == (2 - 1)) or ((3258 - 2298) <= (1949 - (1036 + 37)))) then
				v37 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v38 = EpicSettings.Settings['UseHealthstone'];
				v39 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v127 = 2 + 0;
			end
		end
	end
	local v63 = v15.DeathKnight.Frost;
	local v64 = v17.DeathKnight.Frost;
	local v65 = v19.DeathKnight.Frost;
	local v66 = {v64.AlgetharPuzzleBox:ID()};
	local v67 = v9.Commons.Everyone;
	local v68;
	local v69;
	local v70;
	local v71 = v63.GatheringStorm:IsAvailable() or v63.Everfrost:IsAvailable();
	local v72 = ((v55 > (972 - (910 + 3))) and (63 - 38)) or (1729 - (1466 + 218));
	local v73, v74;
	local v75, v76;
	local v77;
	local v78;
	local v79;
	local v80;
	local v81;
	local v82;
	local v83;
	local v84;
	local v85;
	local v86;
	local v87;
	local v88 = 5107 + 6004;
	local v89 = 12259 - (556 + 592);
	local v90 = v9.GhoulTable;
	local v91, v92, v93;
	local v94, v95, v96;
	local v97;
	v9:RegisterForEvent(function()
		v88 = 3952 + 7159;
		v89 = 11919 - (329 + 479);
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v71 = v63.GatheringStorm:IsAvailable() or v63.Everfrost:IsAvailable();
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local v98 = {{v63.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	local v99 = v32("player", 755 - (396 + 343)) or "";
	local v100 = v32("player", 2 + 15) or "";
	local v101, v101, v102 = v31(":", v99);
	local v101, v101, v103 = v31(":", v100);
	local v69 = (v102 == "3370") or (v103 == "3370");
	local v70 = (v102 == "3368") or (v103 == "3368");
	local v104 = (v102 == "6243") or (v103 == "6243");
	local v105 = IsEquippedItemType("Two-Hand");
	local v106 = v13:GetEquipment();
	local v107 = (v106[1490 - (29 + 1448)] and v17(v106[1402 - (135 + 1254)])) or v17(0 - 0);
	local v108 = (v106[65 - 51] and v17(v106[10 + 4])) or v17(1527 - (389 + 1138));
	v9:RegisterForEvent(function()
		v99 = v32("player", 590 - (102 + 472)) or "";
		v100 = v32("player", 17 + 0) or "";
		v101, v101, v102 = v31(":", v99);
		v101, v101, v103 = v31(":", v100);
		v69 = (v102 == "3370") or (v103 == "3370");
		v70 = (v102 == "3368") or (v103 == "3368");
		v105 = IsEquippedItemType("Two-Hand");
		v106 = v13:GetEquipment();
		v107 = (v106[8 + 5] and v17(v106[13 + 0])) or v17(1545 - (320 + 1225));
		v108 = (v106[24 - 10] and v17(v106[9 + 5])) or v17(1464 - (157 + 1307));
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v109()
		return (v13:HealthPercentage() < v44) or ((v13:HealthPercentage() < v45) and v13:BuffUp(v63.DeathStrikeBuff));
	end
	local function v110(v128)
		return v128:DebuffRemains(v63.MarkofFyralathDebuff);
	end
	local function v111(v129)
		return ((v129:DebuffStack(v63.RazoriceDebuff) + (1860 - (821 + 1038))) / (v129:DebuffRemains(v63.RazoriceDebuff) + (2 - 1))) * v20(v69);
	end
	local function v112(v130)
		return (v130:DebuffDown(v63.FrostFeverDebuff));
	end
	local function v113()
		v72 = ((v55 > (7 + 52)) and (53 - 23)) or (17 + 28);
		if ((v63.HowlingBlast:IsReady() and not v14:IsInRange(19 - 11)) or ((3092 - (834 + 192)) == (60 + 872))) then
			if (((1239 + 3586) < (104 + 4739)) and v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast))) then
				return "howling_blast precombat 2";
			end
		end
		if ((v63.RemorselessWinter:IsReady() and v14:IsInRange(12 - 4)) or ((4181 - (300 + 4)) >= (1212 + 3325))) then
			if (v28(v63.RemorselessWinter) or ((11295 - 6980) < (2088 - (112 + 250)))) then
				return "remorseless_winter precombat 4";
			end
		end
	end
	local function v114()
		local v131 = 0 + 0;
		local v132;
		while true do
			if (((0 - 0) == v131) or ((2108 + 1571) < (324 + 301))) then
				v132 = v67.HandleTopTrinket(v66, v27, 30 + 10, nil);
				if (v132 or ((2294 + 2331) < (470 + 162))) then
					return v132;
				end
				v131 = 1415 - (1001 + 413);
			end
			if (((2 - 1) == v131) or ((965 - (244 + 638)) > (2473 - (627 + 66)))) then
				v132 = v67.HandleBottomTrinket(v66, v27, 119 - 79, nil);
				if (((1148 - (512 + 90)) <= (2983 - (1665 + 241))) and v132) then
					return v132;
				end
				break;
			end
		end
	end
	local function v115()
		if ((v63.HowlingBlast:IsReady() and (v13:BuffUp(v63.RimeBuff) or v14:DebuffDown(v63.FrostFeverDebuff))) or ((1713 - (373 + 344)) > (1940 + 2361))) then
			if (((1077 + 2993) > (1812 - 1125)) and v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast))) then
				return "howling_blast aoe 2";
			end
		end
		if ((v63.GlacialAdvance:IsReady() and not v87 and v81) or ((1109 - 453) >= (4429 - (35 + 1064)))) then
			if (v28(v63.GlacialAdvance, nil, nil, not v14:IsInRange(73 + 27)) or ((5331 - 2839) <= (2 + 333))) then
				return "glacial_advance aoe 4";
			end
		end
		if (((5558 - (298 + 938)) >= (3821 - (233 + 1026))) and v63.Obliterate:IsReady() and v13:BuffUp(v63.KillingMachineBuff) and v63.CleavingStrikes:IsAvailable() and v13:BuffUp(v63.DeathAndDecayBuff) and not v83) then
			if (v67.CastTargetIf(v63.Obliterate, v91, "min", v110, nil, not v14:IsInMeleeRange(1671 - (636 + 1030))) or ((1860 + 1777) >= (3683 + 87))) then
				return "obliterate aoe 8";
			end
		end
		if ((v63.GlacialAdvance:IsReady() and not v87) or ((707 + 1672) > (310 + 4268))) then
			if (v28(v63.GlacialAdvance, nil, nil, not v14:IsInRange(321 - (55 + 166))) or ((94 + 389) > (75 + 668))) then
				return "glacial_advance aoe 10";
			end
		end
		if (((9371 - 6917) > (875 - (36 + 261))) and v63.Frostscythe:IsReady() and v83) then
			if (((1626 - 696) < (5826 - (34 + 1334))) and v28(v63.Frostscythe, nil, nil, not v14:IsInMeleeRange(4 + 4))) then
				return "frostscythe aoe 12";
			end
		end
		if (((515 + 147) <= (2255 - (1035 + 248))) and v63.Obliterate:IsReady() and not v83) then
			if (((4391 - (20 + 1)) == (2277 + 2093)) and v67.CastTargetIf(v63.Obliterate, v91, "min", v110, nil, not v14:IsInMeleeRange(324 - (134 + 185)))) then
				return "obliterate aoe 14";
			end
		end
		if ((v63.FrostStrike:IsReady() and not v87 and not v63.GlacialAdvance:IsAvailable()) or ((5895 - (549 + 584)) <= (1546 - (314 + 371)))) then
			if (v28(v63.FrostStrike, v57, nil, not v14:IsSpellInRange(v63.FrostStrike)) or ((4847 - 3435) == (5232 - (478 + 490)))) then
				return "frost_strike aoe 16";
			end
		end
		if ((v63.HornofWinter:IsCastable() and (v13:Rune() < (2 + 0)) and (v13:RunicPowerDeficit() > (1197 - (786 + 386)))) or ((10261 - 7093) < (3532 - (1055 + 324)))) then
			if (v28(v63.HornofWinter, v59) or ((6316 - (1093 + 247)) < (1184 + 148))) then
				return "horn_of_winter aoe 18";
			end
		end
		if (((487 + 4141) == (18373 - 13745)) and v27 and v63.ArcaneTorrent:IsReady() and (v13:RunicPowerDeficit() > (84 - 59))) then
			if (v28(v63.ArcaneTorrent, v53) or ((153 - 99) == (992 - 597))) then
				return "arcane_torrent aoe 20";
			end
		end
	end
	local function v116()
		local v133 = 0 + 0;
		while true do
			if (((315 - 233) == (282 - 200)) and (v133 == (0 + 0))) then
				if ((v63.HowlingBlast:IsReady() and v80 and (v13:RunicPower() > (((115 - 70) - (v20(v63.RageoftheFrozenChampion:IsAvailable()) * (696 - (364 + 324)))) + ((13 - 8) * v20(v13:BuffUp(v63.RuneofHysteriaBuff)))))) or ((1394 - 813) < (94 + 188))) then
					if (v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast)) or ((19285 - 14676) < (3995 - 1500))) then
						return "howling_blast breath 2";
					end
				end
				if (((3498 - 2346) == (2420 - (1249 + 19))) and v63.HornofWinter:IsReady() and (v13:Rune() < (2 + 0)) and (v13:RunicPowerDeficit() > ((97 - 72) + ((1091 - (686 + 400)) * v20(v13:BuffUp(v63.RuneofHysteriaBuff)))))) then
					if (((1488 + 408) <= (3651 - (73 + 156))) and v28(v63.HornofWinter, v59)) then
						return "horn_of_winter breath 4";
					end
				end
				if ((v63.Obliterate:IsReady() and v13:BuffUp(v63.KillingMachineBuff) and not v83) or ((5 + 985) > (2431 - (721 + 90)))) then
					if (v67.CastTargetIf(v63.Obliterate, v96, "max", v111, nil, not v14:IsInMeleeRange(1 + 4)) or ((2847 - 1970) > (5165 - (224 + 246)))) then
						return "obliterate breath 8";
					end
				end
				v133 = 1 - 0;
			end
			if (((4954 - 2263) >= (336 + 1515)) and (v133 == (1 + 1))) then
				if ((v63.RemorselessWinter:IsReady() and (v13:RunicPower() < (27 + 9)) and (v13:RuneTimeToX(3 - 1) > (v13:RunicPower() / (59 - 41)))) or ((3498 - (203 + 310)) >= (6849 - (1238 + 755)))) then
					if (((299 + 3977) >= (2729 - (709 + 825))) and v28(v63.RemorselessWinter, nil, nil, not v14:IsInMeleeRange(14 - 6))) then
						return "remorseless_winter breath 18";
					end
				end
				if (((4707 - 1475) <= (5554 - (196 + 668))) and v63.HowlingBlast:IsReady() and (v13:RunicPower() < (142 - 106)) and (v13:RuneTimeToX(3 - 1) > (v13:RunicPower() / (851 - (171 + 662))))) then
					if (v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast)) or ((989 - (4 + 89)) >= (11026 - 7880))) then
						return "howling_blast breath 20";
					end
				end
				if (((1115 + 1946) >= (12992 - 10034)) and v63.Obliterate:IsReady() and (v13:RunicPowerDeficit() > (10 + 15))) then
					if (((4673 - (35 + 1451)) >= (2097 - (28 + 1425))) and v67.CastTargetIf(v63.Obliterate, v91, "max", v111, nil, not v14:IsInMeleeRange(1998 - (941 + 1052)))) then
						return "obliterate breath 18";
					end
				end
				v133 = 3 + 0;
			end
			if (((2158 - (822 + 692)) <= (1004 - 300)) and (v133 == (1 + 0))) then
				if (((1255 - (45 + 252)) > (937 + 10)) and v63.Frostscythe:IsReady() and v83 and (v13:BuffUp(v63.KillingMachineBuff) or (v13:RunicPower() > (16 + 29)))) then
					if (((10931 - 6439) >= (3087 - (114 + 319))) and v28(v63.Frostscythe, nil, nil, not v14:IsInMeleeRange(11 - 3))) then
						return "frostscythe breath 8";
					end
				end
				if (((4410 - 968) >= (959 + 544)) and v63.Obliterate:IsReady() and ((v13:RunicPowerDeficit() > (59 - 19)) or v13:BuffUp(v63.PillarofFrostBuff))) then
					if (v67.CastTargetIf(v63.Obliterate, v91, "max", v111, nil, not v14:IsInMeleeRange(10 - 5)) or ((5133 - (556 + 1407)) <= (2670 - (741 + 465)))) then
						return "obliterate breath 10";
					end
				end
				if ((v63.DeathAndDecay:IsReady() and (v13:RunicPower() < (501 - (170 + 295))) and (v13:RuneTimeToX(2 + 0) > (v13:RunicPower() / (17 + 1)))) or ((11810 - 7013) == (3638 + 750))) then
					if (((354 + 197) <= (386 + 295)) and v28(v65.DaDPlayer, v49, nil, not v14:IsSpellInRange(v63.DeathAndDecay))) then
						return "death_and_decay breath 16";
					end
				end
				v133 = 1232 - (957 + 273);
			end
			if (((877 + 2400) > (163 + 244)) and (v133 == (11 - 8))) then
				if (((12372 - 7677) >= (4322 - 2907)) and v63.HowlingBlast:IsReady() and (v13:BuffUp(v63.RimeBuff))) then
					if (v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast)) or ((15904 - 12692) <= (2724 - (389 + 1391)))) then
						return "howling_blast breath 24";
					end
				end
				if ((v63.ArcaneTorrent:IsReady() and (v13:RunicPower() < (38 + 22))) or ((323 + 2773) <= (4093 - 2295))) then
					if (((4488 - (783 + 168)) == (11870 - 8333)) and v28(v63.ArcaneTorrent, v53)) then
						return "arcane_torrent breath 26";
					end
				end
				break;
			end
		end
	end
	local function v117()
		local v134 = 0 + 0;
		while true do
			if (((4148 - (309 + 2)) >= (4821 - 3251)) and (v134 == (1212 - (1090 + 122)))) then
				if ((v63.Frostscythe:IsReady() and v13:BuffUp(v63.KillingMachineBuff) and v83) or ((957 + 1993) == (12802 - 8990))) then
					if (((3233 + 1490) >= (3436 - (628 + 490))) and v28(v63.Frostscythe, nil, nil, not v14:IsInMeleeRange(2 + 6))) then
						return "frostscythe breath_oblit 2";
					end
				end
				if ((v63.Obliterate:IsReady() and (v13:BuffUp(v63.KillingMachineBuff))) or ((5018 - 2991) > (13033 - 10181))) then
					if (v67.CastTargetIf(v63.Obliterate, v91, "max", v111, nil, not v14:IsInMeleeRange(779 - (431 + 343))) or ((2294 - 1158) > (12488 - 8171))) then
						return "obliterate breath_oblit 4";
					end
				end
				v134 = 1 + 0;
			end
			if (((608 + 4140) == (6443 - (556 + 1139))) and (v134 == (16 - (6 + 9)))) then
				if (((685 + 3051) <= (2429 + 2311)) and v63.HowlingBlast:IsReady() and (v13:BuffUp(v63.RimeBuff))) then
					if (v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast)) or ((3559 - (28 + 141)) <= (1186 + 1874))) then
						return "howling_blast breath_oblit 6";
					end
				end
				if ((v63.HowlingBlast:IsReady() and (v13:BuffDown(v63.KillingMachineBuff))) or ((1232 - 233) > (1908 + 785))) then
					if (((1780 - (486 + 831)) < (1563 - 962)) and v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast))) then
						return "howling_blast breath_oblit 8";
					end
				end
				v134 = 6 - 4;
			end
			if ((v134 == (1 + 1)) or ((6902 - 4719) < (1950 - (668 + 595)))) then
				if (((4094 + 455) == (918 + 3631)) and v63.HornofWinter:IsReady() and (v13:RunicPowerDeficit() > (68 - 43))) then
					if (((4962 - (23 + 267)) == (6616 - (1129 + 815))) and v28(v63.HornofWinter, v59)) then
						return "horn_of_winter breath_oblit 10";
					end
				end
				if ((v63.ArcaneTorrent:IsReady() and (v13:RunicPowerDeficit() > (407 - (371 + 16)))) or ((5418 - (1326 + 424)) < (747 - 352))) then
					if (v28(v63.ArcaneTorrent, v53) or ((15223 - 11057) == (573 - (88 + 30)))) then
						return "arcane_torrent breath_oblit 12";
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v135 = 771 - (720 + 51);
		while true do
			if ((v135 == (4 - 2)) or ((6225 - (421 + 1355)) == (4393 - 1730))) then
				if ((v63.ChainsofIce:IsReady() and v63.Obliteration:IsAvailable() and v13:BuffDown(v63.PillarofFrostBuff) and (((v13:BuffStack(v63.ColdHeartBuff) >= (7 + 7)) and (v13:BuffUp(v63.UnholyStrengthBuff))) or (v13:BuffStack(v63.ColdHeartBuff) >= (1102 - (286 + 797))) or ((v63.PillarofFrost:CooldownRemains() < (10 - 7)) and (v13:BuffStack(v63.ColdHeartBuff) >= (23 - 9))))) or ((4716 - (397 + 42)) < (934 + 2055))) then
					if (v28(v63.ChainsofIce, nil, not v14:IsSpellInRange(v63.ChainsofIce)) or ((1670 - (24 + 776)) >= (6391 - 2242))) then
						return "chains_of_ice cold_heart 10";
					end
				end
				break;
			end
			if (((2997 - (222 + 563)) < (7013 - 3830)) and (v135 == (1 + 0))) then
				if (((4836 - (23 + 167)) > (4790 - (690 + 1108))) and v63.ChainsofIce:IsReady() and not v63.Obliteration:IsAvailable() and v70 and v13:BuffDown(v63.PillarofFrostBuff) and (v63.PillarofFrost:CooldownRemains() > (6 + 9)) and (((v13:BuffStack(v63.ColdHeartBuff) >= (9 + 1)) and v13:BuffUp(v63.UnholyStrengthBuff)) or (v13:BuffStack(v63.ColdHeartBuff) >= (861 - (40 + 808))))) then
					if (((237 + 1197) < (11877 - 8771)) and v28(v63.ChainsofIce, nil, not v14:IsSpellInRange(v63.ChainsofIce))) then
						return "chains_of_ice cold_heart 6";
					end
				end
				if (((752 + 34) < (1600 + 1423)) and v63.ChainsofIce:IsReady() and not v63.Obliteration:IsAvailable() and not v70 and (v13:BuffStack(v63.ColdHeartBuff) >= (6 + 4)) and v13:BuffDown(v63.PillarofFrostBuff) and (v63.PillarofFrost:CooldownRemains() > (591 - (47 + 524)))) then
					if (v28(v63.ChainsofIce, nil, not v14:IsSpellInRange(v63.ChainsofIce)) or ((1585 + 857) < (202 - 128))) then
						return "chains_of_ice cold_heart 8";
					end
				end
				v135 = 2 - 0;
			end
			if (((10342 - 5807) == (6261 - (1165 + 561))) and (v135 == (0 + 0))) then
				if ((v63.ChainsofIce:IsReady() and (v89 < v13:GCD()) and ((v13:Rune() < (6 - 4)) or (v13:BuffDown(v63.KillingMachineBuff) and ((not v105 and (v13:BuffStack(v63.ColdHeartBuff) >= (2 + 2))) or (v105 and (v13:BuffStack(v63.ColdHeartBuff) > (487 - (341 + 138)))))) or (v13:BuffUp(v63.KillingMachineBuff) and ((not v105 and (v13:BuffStack(v63.ColdHeartBuff) > (3 + 5))) or (v105 and (v13:BuffStack(v63.ColdHeartBuff) > (20 - 10))))))) or ((3335 - (89 + 237)) <= (6771 - 4666))) then
					if (((3852 - 2022) < (4550 - (581 + 300))) and v28(v63.ChainsofIce, nil, nil, not v14:IsSpellInRange(v63.ChainsofIce))) then
						return "chains_of_ice cold_heart 2";
					end
				end
				if ((v63.ChainsofIce:IsReady() and not v63.Obliteration:IsAvailable() and v13:BuffUp(v63.PillarofFrostBuff) and (v13:BuffStack(v63.ColdHeartBuff) >= (1230 - (855 + 365))) and ((v13:BuffRemains(v63.PillarofFrostBuff) < (v13:GCD() * ((2 - 1) + v20(v63.FrostwyrmsFury:IsAvailable() and v63.FrostwyrmsFury:IsReady())))) or (v13:BuffUp(v63.UnholyStrengthBuff) and (v13:BuffRemains(v63.UnholyStrengthBuff) < v13:GCD())))) or ((467 + 963) >= (4847 - (1030 + 205)))) then
					if (((2519 + 164) >= (2289 + 171)) and v28(v63.ChainsofIce, nil, not v14:IsSpellInRange(v63.ChainsofIce))) then
						return "chains_of_ice cold_heart 4";
					end
				end
				v135 = 287 - (156 + 130);
			end
		end
	end
	local function v119()
		if ((v63.EmpowerRuneWeapon:IsCastable() and ((v63.Obliteration:IsAvailable() and v13:BuffDown(v63.EmpowerRuneWeaponBuff) and (v13:Rune() < (13 - 7)) and (((v63.PillarofFrost:CooldownRemains() < (11 - 4)) and v13:BloodlustUp()) or (((v92 >= (3 - 1)) or v78) and v63.PillarofFrost:CooldownUp()))) or (v89 < (6 + 14)))) or ((1052 + 752) >= (3344 - (10 + 59)))) then
			if (v28(v63.EmpowerRuneWeapon, v50) or ((401 + 1016) > (17871 - 14242))) then
				return "empower_rune_weapon cooldowns 4";
			end
		end
		if (((5958 - (671 + 492)) > (321 + 81)) and v63.EmpowerRuneWeapon:IsCastable() and ((v13:BuffUp(v63.BreathofSindragosa) and v13:BuffDown(v63.EmpowerRuneWeaponBuff) and (v9.CombatTime() < (1225 - (369 + 846))) and v13:BloodlustUp()) or ((v13:RunicPower() < (19 + 51)) and (v13:Rune() < (3 + 0)) and ((v63.BreathofSindragosa:CooldownRemains() > v72) or (v63.EmpowerRuneWeapon:FullRechargeTime() < (1955 - (1036 + 909))))))) then
			if (((3827 + 986) > (5985 - 2420)) and v28(v63.EmpowerRuneWeapon, v50)) then
				return "empower_rune_weapon cooldowns 6";
			end
		end
		if (((4115 - (11 + 192)) == (1977 + 1935)) and v63.EmpowerRuneWeapon:IsCastable() and not v63.BreathofSindragosa:IsAvailable() and not v63.Obliteration:IsAvailable() and v13:BuffDown(v63.EmpowerRuneWeaponBuff) and (v13:Rune() < (180 - (135 + 40))) and ((v63.PillarofFrostBuff:CooldownRemains() < (16 - 9)) or v13:BuffUp(v63.PillarofFrostBuff) or not v63.PillarofFrost:IsAvailable())) then
			if (((1701 + 1120) <= (10627 - 5803)) and v28(v63.EmpowerRuneWeapon, v50)) then
				return "empower_rune_weapon cooldowns 8";
			end
		end
		if (((2605 - 867) <= (2371 - (50 + 126))) and v63.AbominationLimb:IsCastable() and ((v63.Obliteration:IsAvailable() and v13:BuffDown(v63.PillarofFrostBuff) and (v63.PillarofFrost:CooldownRemains() < (8 - 5)) and (v79 or v78)) or (v89 < (4 + 11)))) then
			if (((1454 - (1233 + 180)) <= (3987 - (522 + 447))) and v28(v63.AbominationLimb, nil, not v14:IsInRange(1441 - (107 + 1314)))) then
				return "abomination_limb_talent cooldowns 10";
			end
		end
		if (((996 + 1149) <= (12505 - 8401)) and v63.AbominationLimb:IsCastable() and v63.BreathofSindragosa:IsAvailable() and (v79 or v78)) then
			if (((1143 + 1546) < (9621 - 4776)) and v28(v63.AbominationLimb, nil, not v14:IsInRange(79 - 59))) then
				return "abomination_limb_talent cooldowns 12";
			end
		end
		if ((v63.AbominationLimb:IsCastable() and not v63.BreathofSindragosa:IsAvailable() and not v63.Obliteration:IsAvailable() and (v79 or v78)) or ((4232 - (716 + 1194)) > (45 + 2577))) then
			if (v28(v63.AbominationLimb, nil, not v14:IsInRange(3 + 17)) or ((5037 - (74 + 429)) == (4016 - 1934))) then
				return "abomination_limb_talent cooldowns 14";
			end
		end
		if ((v63.ChillStreak:IsReady() and v13:HasTier(16 + 15, 4 - 2) and (v13:BuffRemains(v63.ChillingRageBuff) < (3 + 0))) or ((4843 - 3272) > (4615 - 2748))) then
			if (v28(v63.ChillStreak, nil, nil, not v14:IsSpellInRange(v63.ChillStreak)) or ((3087 - (279 + 154)) >= (3774 - (454 + 324)))) then
				return "chill_streak cooldowns 16";
			end
		end
		if (((3130 + 848) > (2121 - (12 + 5))) and v63.ChillStreak:IsReady() and not v13:HasTier(17 + 14, 4 - 2) and (v92 >= (1 + 1)) and ((v13:BuffDown(v63.DeathAndDecayBuff) and v63.CleavingStrikes:IsAvailable()) or not v63.CleavingStrikes:IsAvailable() or (v92 <= (1098 - (277 + 816))))) then
			if (((12797 - 9802) > (2724 - (1058 + 125))) and v28(v63.ChillStreak, nil, nil, not v14:IsSpellInRange(v63.ChillStreak))) then
				return "chill_streak cooldowns 16";
			end
		end
		if (((610 + 2639) > (1928 - (815 + 160))) and v63.PillarofFrost:IsCastable() and ((v63.Obliteration:IsAvailable() and (v79 or v78) and (v13:BuffUp(v63.EmpowerRuneWeaponBuff) or (v63.EmpowerRuneWeapon:CooldownRemains() > (0 - 0)))) or (v89 < (28 - 16)))) then
			if (v28(v63.PillarofFrost, v61) or ((781 + 2492) > (13367 - 8794))) then
				return "pillar_of_frost cooldowns 18";
			end
		end
		if ((v63.PillarofFrost:IsCastable() and ((v63.BreathofSindragosa:IsAvailable() and (v79 or v78) and ((not v63.Icecap:IsAvailable() and ((v13:RunicPower() > (1968 - (41 + 1857))) or (v63.BreathofSindragosa:CooldownRemains() > (1933 - (1222 + 671))))) or (v63.Icecap:IsAvailable() and (v63.BreathofSindragosa:CooldownRemains() > (12 - 7))))) or v13:BuffUp(v63.BreathofSindragosa))) or ((4529 - 1378) < (2466 - (229 + 953)))) then
			if (v28(v63.PillarofFrost, v61) or ((3624 - (1111 + 663)) == (3108 - (874 + 705)))) then
				return "pillar_of_frost cooldowns 22";
			end
		end
		if (((115 + 706) < (1449 + 674)) and v63.PillarofFrost:IsCastable() and v63.Icecap:IsAvailable() and not v63.Obliteration:IsAvailable() and not v63.BreathofSindragosa:IsAvailable() and (v79 or v78)) then
			if (((1874 - 972) < (66 + 2259)) and v28(v63.PillarofFrost, v61)) then
				return "pillar_of_frost cooldowns 22";
			end
		end
		if (((1537 - (642 + 37)) <= (676 + 2286)) and v63.BreathofSindragosa:IsReady() and v13:BuffDown(v63.BreathofSindragosa) and (((v13:RunicPower() > (8 + 42)) and v63.EmpowerRuneWeapon:CooldownUp()) or ((v13:RunicPower() > (150 - 90)) and (v63.EmpowerRuneWeapon:CooldownRemains() < (484 - (233 + 221)))) or ((v13:RunicPower() > (184 - 104)) and (v63.EmpowerRuneWeapon:CooldownRemains() > (27 + 3)))) and (v79 or v78 or (v89 < (1571 - (718 + 823))))) then
			if (v28(v63.BreathofSindragosa, v56, nil, not v14:IsInRange(8 + 4)) or ((4751 - (266 + 539)) < (3646 - 2358))) then
				return "breath_of_sindragosa cooldowns 26";
			end
		end
		if ((v63.FrostwyrmsFury:IsCastable() and (((v92 == (1226 - (636 + 589))) and ((v63.PillarofFrost:IsAvailable() and (v13:BuffRemains(v63.PillarofFrostBuff) < (v13:GCD() * (4 - 2))) and v13:BuffUp(v63.PillarofFrostBuff) and not v63.Obliteration:IsAvailable()) or not v63.PillarofFrost:IsAvailable())) or (v89 < (5 - 2)))) or ((2570 + 672) == (206 + 361))) then
			if (v28(v63.FrostwyrmsFury, v58, nil, not v14:IsInRange(1055 - (657 + 358))) or ((2242 - 1395) >= (2877 - 1614))) then
				return "frostwyrms_fury cooldowns 28";
			end
		end
		if ((v63.FrostwyrmsFury:IsCastable() and (v92 >= (1189 - (1151 + 36))) and v63.PillarofFrost:IsAvailable() and v13:BuffUp(v63.PillarofFrostBuff) and (v13:BuffRemains(v63.PillarofFrostBuff) < (v13:GCD() * (2 + 0)))) or ((593 + 1660) == (5527 - 3676))) then
			if (v28(v63.FrostwyrmsFury, v58, nil, not v14:IsInRange(1872 - (1552 + 280))) or ((2921 - (64 + 770)) > (1611 + 761))) then
				return "frostwyrms_fury cooldowns 30";
			end
		end
		if ((v63.FrostwyrmsFury:IsCastable() and v63.Obliteration:IsAvailable() and ((v63.PillarofFrost:IsAvailable() and v13:BuffUp(v63.PillarofFrostBuff) and not v105) or (v13:BuffDown(v63.PillarofFrostBuff) and v105 and v63.PillarofFrost:CooldownDown()) or not v63.PillarofFrost:IsAvailable()) and ((v13:BuffRemains(v63.PillarofFrostBuff) < v13:GCD()) or (v13:BuffUp(v63.UnholyStrengthBuff) and (v13:BuffRemains(v63.UnholyStrengthBuff) < v13:GCD()))) and ((v14:DebuffStack(v63.RazoriceDebuff) == (11 - 6)) or (not v69 and not v63.GlacialAdvance:IsAvailable()))) or ((790 + 3655) < (5392 - (157 + 1086)))) then
			if (v28(v63.FrostwyrmsFury, v58, nil, not v14:IsInRange(80 - 40)) or ((7962 - 6144) == (129 - 44))) then
				return "frostwyrms_fury cooldowns 30";
			end
		end
		if (((859 - 229) < (2946 - (599 + 220))) and v63.RaiseDead:IsCastable()) then
			if (v28(v63.RaiseDead, nil) or ((3859 - 1921) == (4445 - (1813 + 118)))) then
				return "raise_dead cooldowns 32";
			end
		end
		if (((3111 + 1144) >= (1272 - (841 + 376))) and v63.SoulReaper:IsReady() and (v89 > (6 - 1)) and ((v14:TimeToX(9 + 26) < (13 - 8)) or (v14:HealthPercentage() <= (894 - (464 + 395)))) and (v92 <= (5 - 3)) and ((v63.Obliteration:IsAvailable() and ((v13:BuffUp(v63.PillarofFrostBuff) and v13:BuffDown(v63.KillingMachineBuff) and (v13:Rune() > (1 + 1))) or v13:BuffDown(v63.PillarofFrostBuff))) or (v63.BreathofSindragosa:IsAvailable() and ((v13:BuffUp(v63.BreathofSindragosa) and (v13:RunicPower() > (887 - (467 + 370)))) or v13:BuffDown(v63.BreathofSindragosa))) or (not v63.BreathofSindragosa:IsAvailable() and not v63.Obliteration:IsAvailable()))) then
			if (((6196 - 3197) > (849 + 307)) and v28(v63.SoulReaper, nil, nil, not v14:IsInMeleeRange(17 - 12))) then
				return "soul_reaper cooldowns 36";
			end
		end
		if (((367 + 1983) > (2687 - 1532)) and v63.DeathAndDecay:IsReady() and v13:BuffDown(v63.DeathAndDecayBuff) and v79 and ((v13:BuffUp(v63.PillarofFrostBuff) and (v13:BuffRemains(v63.PillarofFrostBuff) > (525 - (150 + 370))) and (v13:BuffRemains(v63.PillarofFrostBuff) < (1293 - (74 + 1208)))) or (v13:BuffDown(v63.PillarofFrostBuff) and (v63.PillarofFrost:CooldownRemains() > (24 - 14))) or (v89 < (52 - 41))) and ((v92 > (4 + 1)) or (v63.CleavingStrikes:IsAvailable() and (v92 >= (392 - (14 + 376)))))) then
			if (((6987 - 2958) <= (3141 + 1712)) and v28(v63.DeathAndDecay, v49)) then
				return "death_and_decay cooldowns 38";
			end
		end
	end
	local function v120()
		local v136 = 0 + 0;
		while true do
			if ((v136 == (2 + 0)) or ((1511 - 995) > (2584 + 850))) then
				if (((4124 - (23 + 55)) >= (7187 - 4154)) and v63.GlacialAdvance:IsReady() and (v92 >= (2 + 0)) and v81 and not v63.BreathofSindragosa:IsAvailable() and v63.Obliteration:IsAvailable() and v13:BuffDown(v63.PillarofFrostBuff)) then
					if (v28(v63.GlacialAdvance, nil, nil, not v14:IsInRange(90 + 10)) or ((4215 - 1496) <= (456 + 991))) then
						return "glacial_advance high_prio_actions 12";
					end
				end
				if ((v63.FrostStrike:IsReady() and (v92 == (902 - (652 + 249))) and v81 and v63.Obliteration:IsAvailable() and v63.BreathofSindragosa:IsAvailable() and v13:BuffDown(v63.PillarofFrostBuff) and v13:BuffDown(v63.BreathofSindragosa) and (v63.BreathofSindragosa:CooldownRemains() > v85)) or ((11063 - 6929) < (5794 - (708 + 1160)))) then
					if (v28(v63.FrostStrike, v57, nil, not v14:IsSpellInRange(v63.FrostStrike)) or ((445 - 281) >= (5077 - 2292))) then
						return "frost_strike high_prio_actions 14";
					end
				end
				v136 = 30 - (10 + 17);
			end
			if ((v136 == (1 + 2)) or ((2257 - (1400 + 332)) == (4044 - 1935))) then
				if (((1941 - (242 + 1666)) == (15 + 18)) and v63.FrostStrike:IsReady() and (v92 == (1 + 0)) and v81 and v63.BreathofSindragosa:IsAvailable() and v13:BuffDown(v63.BreathofSindragosa) and (v63.BreathofSindragosa:CooldownRemains() > v85)) then
					if (((2603 + 451) <= (4955 - (850 + 90))) and v28(v63.FrostStrike, v57, nil, not v14:IsSpellInRange(v63.FrostStrike))) then
						return "frost_strike high_prio_actions 16";
					end
				end
				if (((3276 - 1405) < (4772 - (360 + 1030))) and v63.FrostStrike:IsReady() and (v92 == (1 + 0)) and v81 and not v63.BreathofSindragosa:IsAvailable() and v63.Obliteration:IsAvailable() and v13:BuffDown(v63.PillarofFrostBuff)) then
					if (((3649 - 2356) <= (2979 - 813)) and v28(v63.FrostStrike, v57, nil, not v14:IsSpellInRange(v63.FrostStrike))) then
						return "frost_strike high_prio_actions 18";
					end
				end
				v136 = 1665 - (909 + 752);
			end
			if ((v136 == (1224 - (109 + 1114))) or ((4721 - 2142) < (48 + 75))) then
				if ((v63.GlacialAdvance:IsReady() and (v92 >= (244 - (6 + 236))) and v81 and v63.Obliteration:IsAvailable() and v63.BreathofSindragosa:IsAvailable() and v13:BuffDown(v63.PillarofFrostBuff) and v13:BuffDown(v63.BreathofSindragosa) and (v63.BreathofSindragosa:CooldownRemains() > v85)) or ((534 + 312) >= (1907 + 461))) then
					if (v28(v63.GlacialAdvance, nil, nil, not v14:IsInRange(235 - 135)) or ((7007 - 2995) <= (4491 - (1076 + 57)))) then
						return "glacial_advance high_prio_actions 8";
					end
				end
				if (((246 + 1248) <= (3694 - (579 + 110))) and v63.GlacialAdvance:IsReady() and (v92 >= (1 + 1)) and v81 and v63.BreathofSindragosa:IsAvailable() and v13:BuffDown(v63.BreathofSindragosa) and (v63.BreathofSindragosa:CooldownRemains() > v85)) then
					if (v28(v63.GlacialAdvance, nil, nil, not v14:IsInRange(89 + 11)) or ((1652 + 1459) == (2541 - (174 + 233)))) then
						return "glacial_advance high_prio_actions 10";
					end
				end
				v136 = 5 - 3;
			end
			if (((4133 - 1778) == (1048 + 1307)) and (v136 == (1174 - (663 + 511)))) then
				if ((v46 and v27) or ((525 + 63) <= (94 + 338))) then
					if (((14788 - 9991) >= (2359 + 1536)) and v63.AntiMagicShell:IsCastable() and (v13:RunicPowerDeficit() > (94 - 54)) and ((48 - 28) < v9.CombatTime())) then
						if (((1707 + 1870) == (6961 - 3384)) and v28(v63.AntiMagicShell, v47)) then
							return "antimagic_shell high_prio_actions 2";
						end
					end
					if (((2704 + 1090) > (338 + 3355)) and v63.AntiMagicZone:IsCastable() and (v13:RunicPowerDeficit() > (792 - (478 + 244))) and v63.Assimilation:IsAvailable() and (v13:BuffUp(v63.BreathofSindragosa) or v63.BreathofSindragosa:CooldownUp() or (not v63.BreathofSindragosa:IsAvailable() and v13:BuffDown(v63.PillarofFrostBuff)))) then
						if (v28(v63.AntiMagicZone, v47) or ((1792 - (440 + 77)) == (1865 + 2235))) then
							return "antimagic_zone high_prio_actions 4";
						end
					end
				end
				if ((v63.HowlingBlast:IsReady() and v14:DebuffDown(v63.FrostFeverDebuff) and (v92 >= (7 - 5)) and (not v63.Obliteration:IsAvailable() or (v63.Obliteration:IsAvailable() and (v63.PillarofFrost:CooldownDown() or (v13:BuffUp(v63.PillarofFrostBuff) and v13:BuffDown(v63.KillingMachineBuff)))))) or ((3147 - (655 + 901)) >= (664 + 2916))) then
					if (((753 + 230) <= (1221 + 587)) and v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast))) then
						return "howling_blast high_prio_actions 6";
					end
				end
				v136 = 3 - 2;
			end
			if ((v136 == (1449 - (695 + 750))) or ((7341 - 5191) <= (1847 - 650))) then
				if (((15157 - 11388) >= (1524 - (285 + 66))) and v63.RemorselessWinter:IsReady() and (v71 or v79)) then
					if (((3461 - 1976) == (2795 - (682 + 628))) and v28(v63.RemorselessWinter, nil, nil, not v14:IsInMeleeRange(2 + 6))) then
						return "remorseless_winter high_prio_actions 20";
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v137 = 299 - (176 + 123);
		while true do
			if ((v137 == (1 + 0)) or ((2405 + 910) <= (3051 - (239 + 30)))) then
				if ((v63.GlacialAdvance:IsReady() and (v13:BuffStack(v63.KillingMachineBuff) < (1 + 1)) and (v13:BuffRemains(v63.PillarofFrostBuff) < v13:GCD()) and v13:BuffDown(v63.DeathAndDecayBuff)) or ((842 + 34) >= (5245 - 2281))) then
					if (v28(v63.GlacialAdvance, nil, nil, not v14:IsInRange(311 - 211)) or ((2547 - (306 + 9)) > (8713 - 6216))) then
						return "glacial_advance obliteration 6";
					end
				end
				if ((v63.Frostscythe:IsReady() and v13:BuffUp(v63.KillingMachineBuff) and (v83 or ((v92 > (1 + 2)) and v13:BuffDown(v63.DeathAndDecayBuff) and v64.Fyralath:IsEquipped() and ((v64.Fyralath:CooldownRemains() < (2 + 1)) or v14:DebuffDown(v63.MarkofFyralathDebuff))))) or ((1016 + 1094) <= (949 - 617))) then
					if (((5061 - (1140 + 235)) > (2019 + 1153)) and v28(v63.Frostscythe, nil, nil, not v14:IsInMeleeRange(8 + 0))) then
						return "frostscythe obliteration 8";
					end
				end
				v137 = 1 + 1;
			end
			if (((55 - (33 + 19)) == v137) or ((1616 + 2858) < (2457 - 1637))) then
				if (((1885 + 2394) >= (5651 - 2769)) and v63.GlacialAdvance:IsReady() and v13:BuffDown(v63.KillingMachineBuff) and ((not v69 and (not v63.Avalanche:IsAvailable() or (v14:DebuffStack(v63.RazoriceDebuff) < (5 + 0)) or (v14:DebuffRemains(v63.RazoriceDebuff) < (v13:GCD() * (692 - (586 + 103)))))) or ((v81 or (v13:Rune() < (1 + 1))) and (v92 > (2 - 1))))) then
					if (v28(v63.GlacialAdvance, nil, nil, not v14:IsInRange(1588 - (1309 + 179))) or ((3662 - 1633) >= (1533 + 1988))) then
						return "glacial_advance obliteration 14";
					end
				end
				if ((v63.FrostStrike:IsReady() and v13:BuffDown(v63.KillingMachineBuff) and ((v13:Rune() < (5 - 3)) or v81 or ((v14:DebuffStack(v63.RazoriceDebuff) == (4 + 1)) and v63.ShatteringBlade:IsAvailable())) and not v87 and (not v63.GlacialAdvance:IsAvailable() or (v93 == (1 - 0)))) or ((4058 - 2021) >= (5251 - (295 + 314)))) then
					local v164 = 0 - 0;
					while true do
						if (((3682 - (1300 + 662)) < (13998 - 9540)) and (v164 == (1758 - (1178 + 577)))) then
							if ((v63.FrostStrike:IsReady() and not v87 and (not v63.GlacialAdvance:IsAvailable() or (v92 == (1 + 0)))) or ((1288 - 852) > (4426 - (851 + 554)))) then
								if (((631 + 82) <= (2348 - 1501)) and v64.Fyralath:IsEquipped()) then
									if (((4677 - 2523) <= (4333 - (115 + 187))) and v67.CastTargetIf(v63.FrostStrike, v91, "min", v110, nil, not v14:IsInMeleeRange(4 + 1), v57)) then
										return "frost_strike (fyralath) obliteration 28";
									end
								elseif (((4369 + 246) == (18186 - 13571)) and v67.CastTargetIf(v63.FrostStrike, v91, "max", v111, nil, not v14:IsInMeleeRange(1166 - (160 + 1001)), v57)) then
									return "frost_strike obliteration 28";
								end
							end
							if ((v63.HowlingBlast:IsReady() and (v13:BuffUp(v63.RimeBuff))) or ((3316 + 474) == (345 + 155))) then
								if (((181 - 92) < (579 - (237 + 121))) and v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast))) then
									return "howling_blast obliteration 30";
								end
							end
							v164 = 901 - (525 + 372);
						end
						if (((3893 - 1839) >= (4668 - 3247)) and ((142 - (96 + 46)) == v164)) then
							if (((1469 - (643 + 134)) < (1104 + 1954)) and v64.Fyralath:IsEquipped()) then
								if (v67.CastTargetIf(v63.FrostStrike, v91, "min", v110, nil, not v14:IsInMeleeRange(11 - 6), v57) or ((12080 - 8826) == (1588 + 67))) then
									return "frost_strike (fyralath) obliteration 16";
								end
							elseif (v67.CastTargetIf(v63.FrostStrike, v91, "max", v111, nil, not v14:IsInMeleeRange(9 - 4)) or ((2649 - 1353) == (5629 - (316 + 403)))) then
								return "frost_strike obliteration 18";
							end
							if (((2239 + 1129) == (9259 - 5891)) and v63.HowlingBlast:IsReady() and v13:BuffUp(v63.RimeBuff) and v13:BuffDown(v63.KillingMachineBuff)) then
								if (((956 + 1687) < (9607 - 5792)) and v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast))) then
									return "howling_blast obliteration 18";
								end
							end
							v164 = 1 + 0;
						end
						if (((617 + 1296) > (1708 - 1215)) and (v164 == (19 - 15))) then
							if (((9878 - 5123) > (197 + 3231)) and v63.Obliterate:IsReady()) then
								if (((2718 - 1337) <= (116 + 2253)) and v64.Fyralath:IsEquipped()) then
									if (v67.CastTargetIf(v63.Obliterate, v91, "min", v110, nil, not v14:IsInMeleeRange(14 - 9)) or ((4860 - (12 + 5)) == (15862 - 11778))) then
										return "obliterate (fyralath) obliteration 32";
									end
								elseif (((9961 - 5292) > (771 - 408)) and v67.CastTargetIf(v63.Obliterate, v91, "max", v111, nil, not v14:IsInMeleeRange(12 - 7))) then
									return "obliterate obliteration 32";
								end
							end
							break;
						end
						if (((1 + 1) == v164) or ((3850 - (1656 + 317)) >= (2797 + 341))) then
							if (((3800 + 942) >= (9641 - 6015)) and v27 and v63.ArcaneTorrent:IsReady() and (v13:Rune() < (4 - 3)) and (v13:RunicPower() < (384 - (5 + 349)))) then
								if (v28(v63.ArcaneTorrent, v53) or ((21564 - 17024) == (2187 - (266 + 1005)))) then
									return "arcane_torrent obliteration 28";
								end
							end
							if ((v63.GlacialAdvance:IsReady() and not v87 and (v92 >= (2 + 0))) or ((3944 - 2788) > (5720 - 1375))) then
								if (((3933 - (561 + 1135)) < (5536 - 1287)) and v28(v63.GlacialAdvance, nil, nil, not v14:IsInRange(328 - 228))) then
									return "glacial_advance obliteration 26";
								end
							end
							v164 = 1069 - (507 + 559);
						end
						if ((v164 == (2 - 1)) or ((8297 - 5614) < (411 - (212 + 176)))) then
							if (((1602 - (250 + 655)) <= (2252 - 1426)) and v63.FrostStrike:IsReady() and v13:BuffDown(v63.KillingMachineBuff) and not v87 and (not v63.GlacialAdvance:IsAvailable() or (v92 == (1 - 0)))) then
								if (((1728 - 623) <= (3132 - (1869 + 87))) and v64.Fyralath:IsEquipped()) then
									if (((11719 - 8340) <= (5713 - (484 + 1417))) and v67.CastTargetIf(v63.FrostStrike, v91, "min", v110, nil, not v14:IsInMeleeRange(10 - 5), v57)) then
										return "frost_strike (fyralath) obliteration 20";
									end
								elseif (v67.CastTargetIf(v63.FrostStrike, v91, "max", v111, nil, not v14:IsInMeleeRange(7 - 2), v57) or ((1561 - (48 + 725)) >= (2639 - 1023))) then
									return "frost_strike obliteration 20";
								end
							end
							if (((4974 - 3120) <= (1964 + 1415)) and v63.HowlingBlast:IsReady() and v13:BuffDown(v63.KillingMachineBuff) and (v13:RunicPower() < (80 - 50))) then
								if (((1274 + 3275) == (1326 + 3223)) and v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast))) then
									return "howling_blast obliteration 22";
								end
							end
							v164 = 855 - (152 + 701);
						end
					end
				end
				break;
			end
			if ((v137 == (1311 - (430 + 881))) or ((1158 + 1864) >= (3919 - (557 + 338)))) then
				if (((1425 + 3395) > (6193 - 3995)) and v63.HowlingBlast:IsReady() and (v13:BuffStack(v63.KillingMachineBuff) < (6 - 4)) and (v13:BuffRemains(v63.PillarofFrostBuff) < v13:GCD()) and v13:BuffUp(v63.RimeBuff)) then
					if (v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast)) or ((2818 - 1757) >= (10540 - 5649))) then
						return "howling_blast obliteration 4";
					end
				end
				if (((2165 - (499 + 302)) <= (5339 - (39 + 827))) and v63.FrostStrike:IsReady() and ((v92 <= (2 - 1)) or not v63.GlacialAdvance:IsAvailable()) and (v13:BuffStack(v63.KillingMachineBuff) < (4 - 2)) and (v13:BuffRemains(v63.PillarofFrostBuff) < v13:GCD()) and v13:BuffDown(v63.DeathAndDecayBuff)) then
					if (v67.CastTargetIf(v63.FrostStrike, v91, "min", v110, nil, not v14:IsSpellInRange(v63.FrostStrike), v57) or ((14278 - 10683) <= (3 - 0))) then
						return "frost_strike obliteration 4";
					end
				end
				v137 = 1 + 0;
			end
			if ((v137 == (5 - 3)) or ((748 + 3924) == (6094 - 2242))) then
				if (((1663 - (103 + 1)) == (2113 - (475 + 79))) and v63.Obliterate:IsReady() and v13:BuffUp(v63.KillingMachineBuff) and not v83) then
					if (v64.Fyralath:IsEquipped() or ((3787 - 2035) <= (2521 - 1733))) then
						if (v67.CastTargetIf(v63.Obliterate, v91, "min", v110, nil, not v14:IsInMeleeRange(1 + 4)) or ((3439 + 468) == (1680 - (1395 + 108)))) then
							return "obliterate (fyralath) obliteration 10";
						end
					elseif (((10097 - 6627) > (1759 - (7 + 1197))) and v67.CastTargetIf(v63.Obliterate, v91, "max", v111, nil, not v14:IsInMeleeRange(3 + 2))) then
						return "obliterate obliteration 10";
					end
				end
				if ((v63.HowlingBlast:IsReady() and v13:BuffDown(v63.KillingMachineBuff) and (v14:DebuffDown(v63.FrostFeverDebuff) or (v13:BuffUp(v63.RimeBuff) and v13:HasTier(11 + 19, 321 - (27 + 292)) and not v81))) or ((2847 - 1875) == (822 - 177))) then
					if (((13344 - 10162) >= (4170 - 2055)) and v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast))) then
						return "howling_blast obliteration 12";
					end
				end
				v137 = 5 - 2;
			end
		end
	end
	local function v122()
		if (((4032 - (43 + 96)) < (18066 - 13637)) and v82) then
			if (v63.BloodFury:IsCastable() or ((6481 - 3614) < (1581 + 324))) then
				if (v28(v63.BloodFury, v53) or ((508 + 1288) >= (8006 - 3955))) then
					return "blood_fury racials 2";
				end
			end
			if (((621 + 998) <= (7038 - 3282)) and v63.Berserking:IsCastable()) then
				if (((191 + 413) == (45 + 559)) and v28(v63.Berserking, v53)) then
					return "berserking racials 4";
				end
			end
			if (v63.ArcanePulse:IsCastable() or ((6235 - (1414 + 337)) == (2840 - (1642 + 298)))) then
				if (v28(v63.ArcanePulse, v53, nil, not v14:IsInRange(20 - 12)) or ((12827 - 8368) <= (3302 - 2189))) then
					return "arcane_pulse racials 6";
				end
			end
			if (((1196 + 2436) > (2644 + 754)) and v63.LightsJudgment:IsCastable()) then
				if (((5054 - (357 + 615)) <= (3452 + 1465)) and v28(v63.LightsJudgment, v53, nil, not v14:IsSpellInRange(v63.LightsJudgment))) then
					return "lights_judgment racials 8";
				end
			end
			if (((11856 - 7024) >= (1188 + 198)) and v63.AncestralCall:IsCastable()) then
				if (((293 - 156) == (110 + 27)) and v28(v63.AncestralCall, v53)) then
					return "ancestral_call racials 10";
				end
			end
			if (v63.Fireblood:IsCastable() or ((107 + 1463) >= (2723 + 1609))) then
				if (v28(v63.Fireblood, v53) or ((5365 - (384 + 917)) <= (2516 - (128 + 569)))) then
					return "fireblood racials 12";
				end
			end
		end
		if ((v63.BagofTricks:IsCastable() and v63.Obliteration:IsAvailable() and v13:BuffDown(v63.PillarofFrostBuff) and v13:BuffUp(v63.UnholyStrengthBuff)) or ((6529 - (1407 + 136)) < (3461 - (687 + 1200)))) then
			if (((6136 - (556 + 1154)) > (605 - 433)) and v28(v63.BagofTricks, v53, nil, not v14:IsInRange(135 - (9 + 86)))) then
				return "bag_of_tricks racials 14";
			end
		end
		if (((1007 - (275 + 146)) > (74 + 381)) and v63.BagofTricks:IsCastable() and not v63.Obliteration:IsAvailable() and v13:BuffUp(v63.PillarofFrostBuff) and ((v13:BuffUp(v63.UnholyStrengthBuff) and (v13:BuffRemains(v63.UnholyStrengthBuff) < (v13:GCD() * (67 - (29 + 35))))) or (v13:BuffRemains(v63.PillarofFrostBuff) < (v13:GCD() * (13 - 10))))) then
			if (((2467 - 1641) == (3646 - 2820)) and v28(v63.BagofTricks, v53, nil, not v14:IsInRange(27 + 13))) then
				return "bag_of_tricks racials 16";
			end
		end
	end
	local function v123()
		local v138 = 1012 - (53 + 959);
		while true do
			if (((409 - (312 + 96)) == v138) or ((6974 - 2955) > (4726 - (147 + 138)))) then
				if (((2916 - (813 + 86)) < (3851 + 410)) and v63.HowlingBlast:IsReady() and v13:BuffUp(v63.RimeBuff) and (v63.Icebreaker:TalentRank() == (3 - 1))) then
					if (((5208 - (18 + 474)) > (27 + 53)) and v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast))) then
						return "howling_blast single_target 12";
					end
				end
				if ((v63.HornofWinter:IsReady() and (v13:Rune() < (12 - 8)) and (v13:RunicPowerDeficit() > ((1111 - (860 + 226)) + ((308 - (121 + 182)) * v20(v13:BuffUp(v63.RuneofHysteriaBuff))))) and v63.Obliteration:IsAvailable() and v63.BreathofSindragosa:IsAvailable()) or ((432 + 3075) == (4512 - (988 + 252)))) then
					if (v28(v63.HornofWinter, v59) or ((99 + 777) >= (964 + 2111))) then
						return "horn_of_winter single_target 12";
					end
				end
				if (((6322 - (49 + 1921)) > (3444 - (223 + 667))) and v63.FrostStrike:IsReady() and not v87 and (v81 or (v13:RunicPowerDeficit() < ((77 - (51 + 1)) + ((8 - 3) * v20(v13:BuffUp(v63.RuneofHysteriaBuff))))) or ((v14:DebuffStack(v63.RazoriceDebuff) == (10 - 5)) and v63.ShatteringBlade:IsAvailable()))) then
					if (v28(v63.FrostStrike, v57, nil, not v14:IsInMeleeRange(1130 - (146 + 979))) or ((1244 + 3162) < (4648 - (311 + 294)))) then
						return "frost_strike single_target 14";
					end
				end
				if ((v63.HowlingBlast:IsReady() and v80) or ((5267 - 3378) >= (1433 + 1950))) then
					if (((3335 - (496 + 947)) <= (4092 - (1233 + 125))) and v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast))) then
						return "howling_blast single_target 18";
					end
				end
				v138 = 1 + 1;
			end
			if (((1726 + 197) < (422 + 1796)) and (v138 == (1645 - (963 + 682)))) then
				if (((1814 + 359) > (1883 - (504 + 1000))) and v63.FrostStrike:IsReady() and (v13:BuffStack(v63.KillingMachineBuff) < (2 + 0)) and (v13:RunicPowerDeficit() < (19 + 1 + ((1 + 3) * v20(v13:BuffUp(v63.RuneofHysteriaBuff))))) and not v105) then
					if (v28(v63.FrostStrike, v57, nil, not v14:IsInMeleeRange(7 - 2)) or ((2214 + 377) == (1983 + 1426))) then
						return "frost_strike single_target 2";
					end
				end
				if (((4696 - (156 + 26)) > (1915 + 1409)) and v63.HowlingBlast:IsReady() and v13:BuffUp(v63.RimeBuff) and v13:HasTier(46 - 16, 166 - (149 + 15)) and (v13:BuffStack(v63.KillingMachineBuff) < (962 - (890 + 70)))) then
					if (v28(v63.HowlingBlast, nil, nil, not v14:IsSpellInRange(v63.HowlingBlast)) or ((325 - (39 + 78)) >= (5310 - (14 + 468)))) then
						return "howling_blast single_target 6";
					end
				end
				if ((v63.Frostscythe:IsReady() and v13:BuffUp(v63.KillingMachineBuff) and v83) or ((3480 - 1897) > (9969 - 6402))) then
					if (v28(v63.Frostscythe, nil, nil, not v14:IsInMeleeRange(5 + 3)) or ((789 + 524) == (169 + 625))) then
						return "frostscythe single_target 8";
					end
				end
				if (((1434 + 1740) > (761 + 2141)) and v63.Obliterate:IsReady() and (v13:BuffUp(v63.KillingMachineBuff))) then
					if (((7886 - 3766) <= (4211 + 49)) and v28(v63.Obliterate, nil, nil, not v14:IsInMeleeRange(17 - 12))) then
						return "obliterate single_target 10";
					end
				end
				v138 = 1 + 0;
			end
			if ((v138 == (54 - (12 + 39))) or ((822 + 61) > (14789 - 10011))) then
				if ((v63.FrostStrike:IsReady() and not v87) or ((12892 - 9272) >= (1450 + 3441))) then
					if (((2242 + 2016) > (2375 - 1438)) and v28(v63.FrostStrike, v57, nil, not v14:IsInMeleeRange(4 + 1))) then
						return "frost_strike single_target 28";
					end
				end
				break;
			end
			if ((v138 == (9 - 7)) or ((6579 - (1596 + 114)) < (2365 - 1459))) then
				if ((v63.GlacialAdvance:IsReady() and not v87 and not v69 and ((v14:DebuffStack(v63.RazoriceDebuff) < (718 - (164 + 549))) or (v14:DebuffRemains(v63.RazoriceDebuff) < (v13:GCD() * (1441 - (1059 + 379)))))) or ((1521 - 296) > (2192 + 2036))) then
					if (((561 + 2767) > (2630 - (145 + 247))) and v28(v63.GlacialAdvance, nil, nil, not v14:IsInRange(83 + 17))) then
						return "glacial_advance single_target 20";
					end
				end
				if (((1774 + 2065) > (4165 - 2760)) and v63.Obliterate:IsReady() and not v86) then
					if (v28(v63.Obliterate, nil, nil, not v14:IsInMeleeRange(1 + 4)) or ((1114 + 179) <= (823 - 316))) then
						return "obliterate single_target 22";
					end
				end
				if ((v63.HornofWinter:IsReady() and (v13:Rune() < (724 - (254 + 466))) and (v13:RunicPowerDeficit() > (585 - (544 + 16))) and (not v63.BreathofSindragosa:IsAvailable() or (v63.BreathofSindragosa:CooldownRemains() > (143 - 98)))) or ((3524 - (294 + 334)) < (1058 - (236 + 17)))) then
					if (((999 + 1317) == (1803 + 513)) and v28(v63.HornofWinter, v59)) then
						return "horn_of_winter single_target 24";
					end
				end
				if ((v27 and v63.ArcaneTorrent:IsReady() and (v13:RunicPowerDeficit() > (75 - 55))) or ((12167 - 9597) == (790 + 743))) then
					if (v28(v63.ArcaneTorrent, v53) or ((728 + 155) == (2254 - (413 + 381)))) then
						return "arcane_torrent single_target 26";
					end
				end
				v138 = 1 + 2;
			end
		end
	end
	local function v124()
		local v139 = 0 - 0;
		local v140;
		while true do
			if ((v139 == (4 - 2)) or ((6589 - (582 + 1388)) <= (1701 - 702))) then
				if (((v13:RunicPowerDeficit() > (8 + 2)) and (v63.BreathofSindragosa:CooldownRemains() < (374 - (326 + 38)))) or ((10087 - 6677) > (5875 - 1759))) then
					v85 = (((v63.BreathofSindragosa:CooldownRemains() + (621 - (47 + 573))) / v140) / ((v13:Rune() + 1 + 0) * (v13:RunicPower() + (84 - 64)))) * (162 - 62);
				else
					v85 = 1666 - (1269 + 395);
				end
				v86 = (v13:Rune() < (496 - (76 + 416))) and v63.Obliteration:IsAvailable() and (v63.PillarofFrost:CooldownRemains() < v84);
				v87 = (v63.BreathofSindragosa:IsAvailable() and (v63.BreathofSindragosa:CooldownRemains() < v85)) or (v63.Obliteration:IsAvailable() and (v13:RunicPower() < (478 - (319 + 124))) and (v63.PillarofFrost:CooldownRemains() < v84));
				break;
			end
			if ((v139 == (0 - 0)) or ((1910 - (564 + 443)) >= (8468 - 5409))) then
				v140 = v13:GCD() + (458.25 - (337 + 121));
				v78 = (v92 == (2 - 1)) or not v26;
				v79 = (v92 >= (6 - 4)) and v26;
				v80 = v13:BuffUp(v63.RimeBuff) and (v63.RageoftheFrozenChampion:IsAvailable() or v63.Avalanche:IsAvailable() or v63.Icebreaker:IsAvailable());
				v139 = 1912 - (1261 + 650);
			end
			if (((1 + 0) == v139) or ((6335 - 2359) < (4674 - (772 + 1045)))) then
				v81 = (v63.UnleashedFrenzy:IsAvailable() and ((v13:BuffRemains(v63.UnleashedFrenzyBuff) < (v140 * (1 + 2))) or (v13:BuffStack(v63.UnleashedFrenzyBuff) < (147 - (102 + 42))))) or (v63.IcyTalons:IsAvailable() and ((v13:BuffRemains(v63.IcyTalonsBuff) < (v140 * (1847 - (1524 + 320)))) or (v13:BuffStack(v63.IcyTalonsBuff) < (1273 - (1049 + 221)))));
				v82 = (v63.PillarofFrost:IsAvailable() and v13:BuffUp(v63.PillarofFrostBuff) and ((v63.Obliteration:IsAvailable() and (v13:BuffRemains(v63.PillarofFrostBuff) > (166 - (18 + 138)))) or not v63.Obliteration:IsAvailable())) or (not v63.PillarofFrost:IsAvailable() and v13:BuffUp(v63.EmpowerRuneWeaponBuff)) or (not v63.PillarofFrost:IsAvailable() and not v63.EmpowerRuneWeapon:IsAvailable()) or ((v92 >= (4 - 2)) and v13:BuffUp(v63.PillarofFrostBuff));
				v83 = v63.Frostscythe:IsAvailable() and (v13:BuffUp(v63.KillingMachineBuff) or (v92 >= (1105 - (67 + 1035)))) and ((not v63.ImprovedObliterate:IsAvailable() and not v63.FrigidExecutioner:IsAvailable()) or not v63.CleavingStrikes:IsAvailable() or (v63.CleavingStrikes:IsAvailable() and ((v92 > (356 - (136 + 212))) or (v13:BuffDown(v63.DeathAndDecayBuff) and (v92 > (16 - 12))))));
				if (((3950 + 980) > (2127 + 180)) and (v13:RunicPower() < (1639 - (240 + 1364))) and (v13:Rune() < (1084 - (1050 + 32))) and (v63.PillarofFrost:CooldownRemains() < (35 - 25))) then
					v84 = (((v63.PillarofFrost:CooldownRemains() + 1 + 0) / v140) / ((v13:Rune() + (1058 - (331 + 724))) * (v13:RunicPower() + 1 + 4))) * (744 - (269 + 375));
				else
					v84 = 728 - (267 + 458);
				end
				v139 = 1 + 1;
			end
		end
	end
	local function v125()
		local v141 = 0 - 0;
		while true do
			if ((v141 == (819 - (667 + 151))) or ((5543 - (1410 + 87)) < (3188 - (1504 + 393)))) then
				v26 = EpicSettings.Toggles['aoe'];
				v27 = EpicSettings.Toggles['cds'];
				v141 = 5 - 3;
			end
			if ((v141 == (10 - 6)) or ((5037 - (461 + 335)) == (454 + 3091))) then
				if (v67.TargetIsValid() or ((5809 - (1730 + 31)) > (5899 - (728 + 939)))) then
					local v165 = 0 - 0;
					local v166;
					while true do
						if ((v165 == (1 - 0)) or ((4009 - 2259) >= (4541 - (138 + 930)))) then
							if (((2894 + 272) == (2476 + 690)) and v166) then
								return v166;
							end
							if (((1511 + 252) < (15206 - 11482)) and v27) then
								local v168 = 1766 - (459 + 1307);
								local v169;
								while true do
									if (((1927 - (474 + 1396)) <= (4754 - 2031)) and (v168 == (0 + 0))) then
										v169 = v119();
										if (v169 or ((7 + 2063) == (1268 - 825))) then
											return v169;
										end
										break;
									end
								end
							end
							if (v27 or ((343 + 2362) == (4650 - 3257))) then
								local v170 = v122();
								if (v170 or ((20065 - 15464) < (652 - (562 + 29)))) then
									return v170;
								end
								local v170 = v114();
								if (v170 or ((1186 + 204) >= (6163 - (374 + 1045)))) then
									return v170;
								end
							end
							if ((v63.ColdHeart:IsAvailable() and (v13:BuffDown(v63.KillingMachineBuff) or v63.BreathofSindragosa:IsAvailable()) and ((v14:DebuffStack(v63.RazoriceDebuff) == (4 + 1)) or (not v69 and not v63.GlacialAdvance:IsAvailable() and not v63.Avalanche:IsAvailable()) or (v89 <= (v13:GCD() + (0.5 - 0))))) or ((2641 - (448 + 190)) > (1238 + 2596))) then
								local v171 = 0 + 0;
								local v172;
								while true do
									if (((0 + 0) == v171) or ((599 - 443) > (12158 - 8245))) then
										v172 = v118();
										if (((1689 - (1307 + 187)) == (773 - 578)) and v172) then
											return v172;
										end
										break;
									end
								end
							end
							v165 = 4 - 2;
						end
						if (((9520 - 6415) >= (2479 - (232 + 451))) and (v165 == (2 + 0))) then
							if (((3869 + 510) >= (2695 - (510 + 54))) and v13:BuffUp(v63.BreathofSindragosa) and v63.Obliteration:IsAvailable() and v13:BuffUp(v63.PillarofFrostBuff)) then
								local v173 = v117();
								if (((7744 - 3900) >= (2079 - (13 + 23))) and v173) then
									return v173;
								end
								if (v28(v63.Pool) or ((6299 - 3067) <= (3923 - 1192))) then
									return "pool for BreathOblit()";
								end
							end
							if (((8911 - 4006) == (5993 - (830 + 258))) and v13:BuffUp(v63.BreathofSindragosa) and (not v63.Obliteration:IsAvailable() or (v63.Obliteration:IsAvailable() and v13:BuffDown(v63.PillarofFrostBuff)))) then
								local v174 = 0 - 0;
								local v175;
								while true do
									if ((v174 == (1 + 0)) or ((3519 + 617) >= (5852 - (860 + 581)))) then
										if (v28(v63.Pool) or ((10910 - 7952) == (3189 + 828))) then
											return "pool for Breath()";
										end
										break;
									end
									if (((1469 - (237 + 4)) >= (1910 - 1097)) and (v174 == (0 - 0))) then
										v175 = v116();
										if (v175 or ((6550 - 3095) > (3315 + 735))) then
											return v175;
										end
										v174 = 1 + 0;
									end
								end
							end
							if (((917 - 674) == (105 + 138)) and v63.Obliteration:IsAvailable() and v13:BuffUp(v63.PillarofFrostBuff) and v13:BuffDown(v63.BreathofSindragosa)) then
								local v176 = v121();
								if (v176 or ((148 + 123) > (2998 - (85 + 1341)))) then
									return v176;
								end
								if (((4673 - 1934) < (9299 - 6006)) and v28(v63.Pool)) then
									return "pool for Obliteration()";
								end
							end
							if (((v92 >= (374 - (45 + 327))) and v26) or ((7438 - 3496) < (1636 - (444 + 58)))) then
								local v177 = 0 + 0;
								local v178;
								while true do
									if ((v177 == (0 + 0)) or ((1317 + 1376) == (14411 - 9438))) then
										v178 = v115();
										if (((3878 - (64 + 1668)) == (4119 - (1227 + 746))) and v178) then
											return v178;
										end
										break;
									end
								end
							end
							v165 = 9 - 6;
						end
						if ((v165 == (0 - 0)) or ((2738 - (415 + 79)) == (83 + 3141))) then
							if (not v13:AffectingCombat() or ((5395 - (142 + 349)) <= (821 + 1095))) then
								local v179 = 0 - 0;
								local v180;
								while true do
									if (((45 + 45) <= (751 + 314)) and (v179 == (0 - 0))) then
										v180 = v113();
										if (((6666 - (1710 + 154)) == (5120 - (200 + 118))) and v180) then
											return v180;
										end
										break;
									end
								end
							end
							if ((v63.DeathStrike:IsReady() and not v68) or ((904 + 1376) <= (893 - 382))) then
								if (v28(v63.DeathStrike, nil, nil, not v14:IsInMeleeRange(7 - 2)) or ((1490 + 186) <= (458 + 5))) then
									return "death_strike low hp or proc";
								end
							end
							v124();
							v166 = v120();
							v165 = 1 + 0;
						end
						if (((618 + 3251) == (8381 - 4512)) and ((1253 - (363 + 887)) == v165)) then
							if (((2021 - 863) <= (12437 - 9824)) and ((v92 == (1 + 0)) or not v26)) then
								local v181 = v123();
								if (v181 or ((5531 - 3167) <= (1366 + 633))) then
									return v181;
								end
							end
							if (v9.CastAnnotated(v63.Pool, false, "WAIT") or ((6586 - (674 + 990)) < (56 + 138))) then
								return "Wait/Pool Resources";
							end
							break;
						end
					end
				end
				break;
			end
			if ((v141 == (2 + 1)) or ((3314 - 1223) < (1086 - (507 + 548)))) then
				if (v26 or ((3267 - (289 + 548)) >= (6690 - (821 + 997)))) then
					v92 = #v91;
				else
					v92 = 256 - (195 + 60);
				end
				if (v67.TargetIsValid() or v13:AffectingCombat() or ((1283 + 3487) < (3236 - (251 + 1250)))) then
					local v167 = 0 - 0;
					while true do
						if ((v167 == (1 + 0)) or ((5471 - (809 + 223)) <= (3429 - 1079))) then
							if ((v89 == (33367 - 22256)) or ((14809 - 10330) < (3289 + 1177))) then
								v89 = v9.FightRemains(v91, false);
							end
							break;
						end
						if (((1334 + 1213) > (1842 - (14 + 603))) and (v167 == (129 - (118 + 11)))) then
							v88 = v9.BossFightRemains();
							v89 = v88;
							v167 = 1 + 0;
						end
					end
				end
				v141 = 4 + 0;
			end
			if (((13612 - 8941) > (3623 - (551 + 398))) and (v141 == (2 + 0))) then
				v68 = not v109();
				v91 = v13:GetEnemiesInMeleeRange(2 + 3);
				v141 = 3 + 0;
			end
			if ((v141 == (0 - 0)) or ((8515 - 4819) < (1079 + 2248))) then
				v62();
				v25 = EpicSettings.Toggles['ooc'];
				v141 = 3 - 2;
			end
		end
	end
	local function v126()
		local v142 = 0 + 0;
		while true do
			if ((v142 == (89 - (40 + 49))) or ((17296 - 12754) == (3460 - (99 + 391)))) then
				v62();
				v9.Print("Frost DK rotation by Epic. Work in progress Gojira");
				break;
			end
		end
	end
	v9.SetAPL(208 + 43, v125, v126);
end;
return v0["Epix_DeathKnight_FrostDK.lua"]();

