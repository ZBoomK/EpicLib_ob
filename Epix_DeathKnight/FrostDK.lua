local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((9972 - 6272) == (4307 - (884 + 916)))) then
			return v6(...);
		end
		if (((9366 - 4892) >= (159 + 115)) and (v5 == (653 - (232 + 421)))) then
			v6 = v0[v4];
			if (not v6 or ((3783 - (1569 + 320)) <= (345 + 1061))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
	end
end
v0["Epix_DeathKnight_FrostDK.lua"] = function(...)
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
	local v18 = v10.Item;
	local v19 = v10.Pet;
	local v20 = v10.Macro;
	local v21 = v10.Commons.Everyone.num;
	local v22 = v10.Commons.Everyone.bool;
	local v23 = math.min;
	local v24 = math.abs;
	local v25 = math.max;
	local v26 = false;
	local v27 = false;
	local v28 = false;
	local v29 = v10.Cast;
	local v30 = table.insert;
	local v31 = GetTime;
	local v32 = strsplit;
	local v33 = GetInventoryItemLink;
	local v34;
	local v35;
	local v36;
	local v37;
	local v38 = 0 - 0;
	local v39;
	local v40 = 605 - (316 + 289);
	local v41;
	local v42;
	local v43;
	local v44;
	local v45 = 0 - 0;
	local v46 = 0 + 0;
	local v47;
	local v48;
	local v49;
	local v50;
	local v51;
	local v52;
	local v53;
	local v54;
	local v55;
	local v56 = 1453 - (666 + 787);
	local v57;
	local v58;
	local v59;
	local v60;
	local v61;
	local v62;
	local function v63()
		local v127 = 425 - (360 + 65);
		while true do
			if (((1470 + 102) >= (1785 - (79 + 175))) and (v127 == (9 - 3))) then
				v60 = EpicSettings.Settings['HornOfWinterGCD'];
				v61 = EpicSettings.Settings['HypothermicPresenceGCD'];
				v62 = EpicSettings.Settings['PillarOfFrostGCD'];
				break;
			end
			if ((v127 == (0 + 0)) or ((14366 - 9679) < (8746 - 4204))) then
				v34 = EpicSettings.Settings['UseRacials'];
				v36 = EpicSettings.Settings['UseHealingPotion'];
				v37 = EpicSettings.Settings['HealingPotionName'] or (899 - (503 + 396));
				v38 = EpicSettings.Settings['HealingPotionHP'] or (181 - (92 + 89));
				v127 = 1 - 0;
			end
			if (((1688 + 1603) > (987 + 680)) and (v127 == (15 - 11))) then
				v52 = EpicSettings.Settings['SacrificialPactGCD'];
				v53 = EpicSettings.Settings['MindFreezeOffGCD'];
				v54 = EpicSettings.Settings['RacialsOffGCD'];
				v55 = EpicSettings.Settings['DisableBoSPooling'];
				v127 = 1 + 4;
			end
			if ((v127 == (11 - 6)) or ((762 + 111) == (972 + 1062))) then
				v56 = EpicSettings.Settings['AMSAbsorbPercent'] or (0 - 0);
				v57 = EpicSettings.Settings['BreathOfSindragosaGCD'];
				v58 = EpicSettings.Settings['FrostStrikeGCD'];
				v59 = EpicSettings.Settings['FrostwyrmsFuryGCD'];
				v127 = 1 + 5;
			end
			if ((v127 == (4 - 1)) or ((4060 - (485 + 759)) < (25 - 14))) then
				v48 = EpicSettings.Settings['AntiMagicShellGCD'];
				v49 = EpicSettings.Settings['AntiMagicZoneGCD'];
				v50 = EpicSettings.Settings['DeathAndDecayGCD'];
				v51 = EpicSettings.Settings['EmpowerRuneWeaponGCD'];
				v127 = 1193 - (442 + 747);
			end
			if (((4834 - (832 + 303)) < (5652 - (88 + 858))) and ((1 + 1) == v127)) then
				v43 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v45 = EpicSettings.Settings['UseDeathStrikeHP'] or (0 + 0);
				v46 = EpicSettings.Settings['UseDarkSuccorHP'] or (789 - (766 + 23));
				v47 = EpicSettings.Settings['UseAMSAMZOffensively'];
				v127 = 14 - 11;
			end
			if (((3618 - 972) >= (2307 - 1431)) and (v127 == (3 - 2))) then
				v39 = EpicSettings.Settings['UseHealthstone'];
				v40 = EpicSettings.Settings['HealthstoneHP'] or (1073 - (1036 + 37));
				v41 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v42 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v127 = 2 + 0;
			end
		end
	end
	local v64 = v16.DeathKnight.Frost;
	local v65 = v18.DeathKnight.Frost;
	local v66 = v20.DeathKnight.Frost;
	local v67 = {v65.AlgetharPuzzleBox:ID()};
	local v68 = v10.Commons.Everyone;
	local v69;
	local v70;
	local v71;
	local v72 = v64.GatheringStorm:IsAvailable() or v64.Everfrost:IsAvailable();
	local v73 = ((v56 > (972 - (910 + 3))) and (63 - 38)) or (1729 - (1466 + 218));
	local v74, v75;
	local v76, v77;
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
	local v88;
	local v89 = 5107 + 6004;
	local v90 = 12259 - (556 + 592);
	local v91 = v10.GhoulTable;
	local v92, v93, v94;
	local v95, v96, v97;
	local v98;
	v10:RegisterForEvent(function()
		local v128 = 0 + 0;
		while true do
			if (((1422 - (329 + 479)) <= (4038 - (174 + 680))) and (v128 == (0 - 0))) then
				v89 = 23029 - 11918;
				v90 = 7933 + 3178;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v72 = v64.GatheringStorm:IsAvailable() or v64.Everfrost:IsAvailable();
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local v99 = {{v64.Asphyxiate,"Cast Asphyxiate (Interrupt)",function()
		return true;
	end}};
	local v100 = v33("player", 60 - 44) or "";
	local v101 = v33("player", 79 - 62) or "";
	local v102, v102, v103 = v32(":", v100);
	local v102, v102, v104 = v32(":", v101);
	local v70 = (v103 == "3370") or (v104 == "3370");
	local v71 = (v103 == "3368") or (v104 == "3368");
	local v105 = (v103 == "6243") or (v104 == "6243");
	local v106 = IsEquippedItemType("Two-Hand");
	local v107 = v14:GetEquipment();
	local v108 = (v107[9 + 4] and v18(v107[1540 - (389 + 1138)])) or v18(574 - (102 + 472));
	local v109 = (v107[14 + 0] and v18(v107[8 + 6])) or v18(0 + 0);
	v10:RegisterForEvent(function()
		v100 = v33("player", 1561 - (320 + 1225)) or "";
		v101 = v33("player", 29 - 12) or "";
		v102, v102, v103 = v32(":", v100);
		v102, v102, v104 = v32(":", v101);
		v70 = (v103 == "3370") or (v104 == "3370");
		v71 = (v103 == "3368") or (v104 == "3368");
		v106 = IsEquippedItemType("Two-Hand");
		v107 = v14:GetEquipment();
		v108 = (v107[8 + 5] and v18(v107[1477 - (157 + 1307)])) or v18(1859 - (821 + 1038));
		v109 = (v107[34 - 20] and v18(v107[2 + 12])) or v18(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local function v110()
		return (v14:HealthPercentage() < v45) or ((v14:HealthPercentage() < v46) and v14:BuffUp(v64.DeathStrikeBuff));
	end
	local function v111(v129)
		return ((v129:DebuffStack(v64.RazoriceDebuff) + 1 + 0) / (v129:DebuffRemains(v64.RazoriceDebuff) + (2 - 1))) * v21(v70);
	end
	local function v112(v130)
		return (v130:DebuffDown(v64.FrostFeverDebuff));
	end
	local function v113()
		local v131 = 1026 - (834 + 192);
		while true do
			if (((199 + 2927) == (803 + 2323)) and (v131 == (1 + 0))) then
				if ((v64.RemorselessWinter:IsReady() and v15:IsInRange(12 - 4)) or ((2491 - (300 + 4)) >= (1324 + 3630))) then
					if (v29(v64.RemorselessWinter) or ((10148 - 6271) == (3937 - (112 + 250)))) then
						return "remorseless_winter precombat 4";
					end
				end
				break;
			end
			if (((282 + 425) > (1583 - 951)) and (v131 == (0 + 0))) then
				v73 = ((v56 > (31 + 28)) and (19 + 6)) or (23 + 22);
				if ((v64.HowlingBlast:IsReady() and not v15:IsInRange(6 + 2)) or ((1960 - (1001 + 413)) >= (5984 - 3300))) then
					if (((2347 - (244 + 638)) <= (4994 - (627 + 66))) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return "howling_blast precombat 2";
					end
				end
				v131 = 2 - 1;
			end
		end
	end
	local function v114()
		local v132 = 602 - (512 + 90);
		local v133;
		while true do
			if (((3610 - (1665 + 241)) > (2142 - (373 + 344))) and (v132 == (0 + 0))) then
				v133 = v68.HandleTopTrinket(v67, v28, 11 + 29, nil);
				if (v133 or ((1812 - 1125) == (7164 - 2930))) then
					return v133;
				end
				v132 = 1100 - (35 + 1064);
			end
			if ((v132 == (1 + 0)) or ((7124 - 3794) < (6 + 1423))) then
				v133 = v68.HandleBottomTrinket(v67, v28, 1276 - (298 + 938), nil);
				if (((2406 - (233 + 1026)) >= (2001 - (636 + 1030))) and v133) then
					return v133;
				end
				break;
			end
		end
	end
	local function v115()
		if (((1757 + 1678) > (2049 + 48)) and v64.RemorselessWinter:IsReady()) then
			if (v29(v64.RemorselessWinter, nil, nil, not v15:IsInMeleeRange(3 + 5)) or ((255 + 3515) >= (4262 - (55 + 166)))) then
				return "remorseless_winter aoe 2";
			end
		end
		if ((v64.HowlingBlast:IsReady() and (v14:BuffUp(v64.RimeBuff) or v15:DebuffDown(v64.FrostFeverDebuff))) or ((735 + 3056) <= (163 + 1448))) then
			if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or ((17483 - 12905) <= (2305 - (36 + 261)))) then
				return "howling_blast aoe 4";
			end
		end
		if (((1967 - 842) <= (3444 - (34 + 1334))) and v64.GlacialAdvance:IsReady() and not v88 and v82) then
			if (v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(39 + 61)) or ((578 + 165) >= (5682 - (1035 + 248)))) then
				return "glacial_advance aoe 6";
			end
		end
		if (((1176 - (20 + 1)) < (872 + 801)) and v64.Obliterate:IsReady() and v14:BuffUp(v64.KillingMachineBuff) and v64.CleavingStrikes:IsAvailable() and v14:BuffUp(v64.DeathAndDecayBuff) and not v84) then
			if (v29(v64.Obliterate, nil, nil, not v15:IsInMeleeRange(324 - (134 + 185))) or ((3457 - (549 + 584)) <= (1263 - (314 + 371)))) then
				return "obliterate aoe 8";
			end
		end
		if (((12931 - 9164) == (4735 - (478 + 490))) and v64.GlacialAdvance:IsReady() and not v88) then
			if (((2167 + 1922) == (5261 - (786 + 386))) and v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(323 - 223))) then
				return "glacial_advance aoe 10";
			end
		end
		if (((5837 - (1055 + 324)) >= (3014 - (1093 + 247))) and v64.Frostscythe:IsReady() and v84) then
			if (((864 + 108) <= (150 + 1268)) and v29(v64.Frostscythe, nil, nil, not v15:IsInMeleeRange(31 - 23))) then
				return "frostscythe aoe 12";
			end
		end
		if ((v64.Obliterate:IsReady() and not v84) or ((16758 - 11820) < (13550 - 8788))) then
			if (v29(v64.Obliterate, nil, nil, not v15:IsInMeleeRange(12 - 7)) or ((891 + 1613) > (16426 - 12162))) then
				return "obliterate aoe 14";
			end
		end
		if (((7420 - 5267) == (1624 + 529)) and v64.FrostStrike:IsReady() and not v88 and not v64.GlacialAdvance:IsAvailable()) then
			if (v29(v64.FrostStrike, v58, nil, not v15:IsSpellInRange(v64.FrostStrike)) or ((1296 - 789) >= (3279 - (364 + 324)))) then
				return "frost_strike aoe 16";
			end
		end
		if (((12283 - 7802) == (10752 - 6271)) and v64.HornofWinter:IsCastable() and (v14:Rune() < (1 + 1)) and (v14:RunicPowerDeficit() > (104 - 79))) then
			if (v29(v64.HornofWinter, v60) or ((3728 - 1400) < (2104 - 1411))) then
				return "horn_of_winter aoe 18";
			end
		end
		if (((5596 - (1249 + 19)) == (3907 + 421)) and v28 and v64.ArcaneTorrent:IsReady() and (v14:RunicPowerDeficit() > (97 - 72))) then
			if (((2674 - (686 + 400)) >= (1046 + 286)) and v29(v64.ArcaneTorrent, v54)) then
				return "arcane_torrent aoe 20";
			end
		end
	end
	local function v116()
		local v134 = 229 - (73 + 156);
		while true do
			if (((0 + 0) == v134) or ((4985 - (721 + 90)) > (48 + 4200))) then
				if ((v64.RemorselessWinter:IsReady() and (v72 or v80)) or ((14890 - 10304) <= (552 - (224 + 246)))) then
					if (((6257 - 2394) == (7112 - 3249)) and v29(v64.RemorselessWinter, nil, nil, not v15:IsInMeleeRange(2 + 6))) then
						return "remorseless_winter breath 2";
					end
				end
				if ((v64.HowlingBlast:IsReady() and v81 and (v14:RunicPower() > ((2 + 43) - (v21(v64.RageoftheFrozenChampion:IsAvailable()) * (6 + 2))))) or ((560 - 278) <= (139 - 97))) then
					if (((5122 - (203 + 310)) >= (2759 - (1238 + 755))) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return "howling_blast breath 4";
					end
				end
				if ((v64.HornofWinter:IsReady() and (v14:Rune() < (1 + 1)) and (v14:RunicPowerDeficit() > (1559 - (709 + 825)))) or ((2122 - 970) == (3623 - 1135))) then
					if (((4286 - (196 + 668)) > (13226 - 9876)) and v29(v64.HornofWinter, v60)) then
						return "horn_of_winter breath 6";
					end
				end
				if (((1816 - 939) > (1209 - (171 + 662))) and v64.Obliterate:IsReady() and v14:BuffUp(v64.KillingMachineBuff) and not v84) then
					if (v68.CastTargetIf(v64.Obliterate, v97, "max", v111, nil, not v15:IsInMeleeRange(98 - (4 + 89))) or ((10928 - 7810) <= (674 + 1177))) then
						return "obliterate breath 8";
					end
				end
				v134 = 4 - 3;
			end
			if ((v134 == (2 + 1)) or ((1651 - (35 + 1451)) >= (4945 - (28 + 1425)))) then
				if (((5942 - (941 + 1052)) < (4657 + 199)) and v64.ArcaneTorrent:IsReady() and (v14:RunicPower() < (1574 - (822 + 692)))) then
					if (v29(v64.ArcaneTorrent, v54) or ((6103 - 1827) < (1421 + 1595))) then
						return "arcane_torrent breath 26";
					end
				end
				break;
			end
			if (((4987 - (45 + 252)) > (4082 + 43)) and (v134 == (1 + 1))) then
				if ((v64.RemorselessWinter:IsReady() and (v14:RunicPower() < (87 - 51)) and (v14:RuneTimeToX(435 - (114 + 319)) > (v14:RunicPower() / (25 - 7)))) or ((64 - 14) >= (572 + 324))) then
					if (v29(v64.RemorselessWinter, nil, nil, not v15:IsInMeleeRange(11 - 3)) or ((3591 - 1877) >= (4921 - (556 + 1407)))) then
						return "remorseless_winter breath 18";
					end
				end
				if ((v64.HowlingBlast:IsReady() and (v14:RunicPower() < (1242 - (741 + 465))) and (v14:RuneTimeToX(467 - (170 + 295)) > (v14:RunicPower() / (10 + 8)))) or ((1370 + 121) < (1585 - 941))) then
					if (((584 + 120) < (633 + 354)) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return "howling_blast breath 20";
					end
				end
				if (((2106 + 1612) > (3136 - (957 + 273))) and v64.Obliterate:IsReady() and (v14:RunicPowerDeficit() > (7 + 18))) then
					if (v68.CastTargetIf(v64.Obliterate, v97, "max", v111, nil, not v15:IsInMeleeRange(3 + 2)) or ((3650 - 2692) > (9579 - 5944))) then
						return "obliterate breath 22";
					end
				end
				if (((10693 - 7192) <= (22242 - 17750)) and v64.HowlingBlast:IsReady() and (v14:BuffUp(v64.RimeBuff))) then
					if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or ((5222 - (389 + 1391)) < (1599 + 949))) then
						return "howling_blast breath 24";
					end
				end
				v134 = 1 + 2;
			end
			if (((6545 - 3670) >= (2415 - (783 + 168))) and (v134 == (3 - 2))) then
				if ((v64.Frostscythe:IsReady() and v14:BuffUp(v64.KillingMachineBuff) and v84) or ((4719 + 78) >= (5204 - (309 + 2)))) then
					if (v29(v64.Frostscythe, nil, nil, not v15:IsInMeleeRange(24 - 16)) or ((1763 - (1090 + 122)) > (671 + 1397))) then
						return "frostscythe breath 10";
					end
				end
				if (((7099 - 4985) > (647 + 297)) and v64.Frostscythe:IsReady() and v84 and (v14:RunicPower() > (1163 - (628 + 490)))) then
					if (v29(v64.Frostscythe, nil, nil, not v15:IsInMeleeRange(2 + 6)) or ((5599 - 3337) >= (14148 - 11052))) then
						return "frostscythe breath 12";
					end
				end
				if ((v64.Obliterate:IsReady() and ((v14:RunicPowerDeficit() > (814 - (431 + 343))) or (v14:BuffUp(v64.PillarofFrostBuff) and (v14:RunicPowerDeficit() > (33 - 16))))) or ((6523 - 4268) >= (2795 + 742))) then
					if (v68.CastTargetIf(v64.Obliterate, v97, "max", v111, nil, not v15:IsInMeleeRange(1 + 4)) or ((5532 - (556 + 1139)) < (1321 - (6 + 9)))) then
						return "obliterate breath 14";
					end
				end
				if (((541 + 2409) == (1512 + 1438)) and v64.DeathAndDecay:IsReady() and (v14:RunicPower() < (205 - (28 + 141))) and (v14:RuneTimeToX(1 + 1) > (v14:RunicPower() / (21 - 3)))) then
					if (v29(v66.DaDPlayer, v50, nil, not v15:IsSpellInRange(v64.DeathAndDecay)) or ((3346 + 1377) < (4615 - (486 + 831)))) then
						return "death_and_decay breath 16";
					end
				end
				v134 = 5 - 3;
			end
		end
	end
	local function v117()
		local v135 = 0 - 0;
		while true do
			if (((215 + 921) >= (486 - 332)) and (v135 == (1264 - (668 + 595)))) then
				if ((v64.HowlingBlast:IsReady() and (v14:BuffUp(v64.RimeBuff))) or ((244 + 27) > (958 + 3790))) then
					if (((12926 - 8186) >= (3442 - (23 + 267))) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return "howling_blast breath_oblit 6";
					end
				end
				if ((v64.HowlingBlast:IsReady() and (v14:BuffDown(v64.KillingMachineBuff))) or ((4522 - (1129 + 815)) >= (3777 - (371 + 16)))) then
					if (((1791 - (1326 + 424)) <= (3145 - 1484)) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return "howling_blast breath_oblit 8";
					end
				end
				v135 = 7 - 5;
			end
			if (((719 - (88 + 30)) < (4331 - (720 + 51))) and (v135 == (0 - 0))) then
				if (((2011 - (421 + 1355)) < (1132 - 445)) and v64.Frostscythe:IsReady() and v14:BuffUp(v64.KillingMachineBuff) and v84) then
					if (((2235 + 2314) > (2236 - (286 + 797))) and v29(v64.Frostscythe, nil, nil, not v15:IsInMeleeRange(29 - 21))) then
						return "frostscythe breath_oblit 2";
					end
				end
				if ((v64.Obliterate:IsReady() and (v14:BuffUp(v64.KillingMachineBuff))) or ((7741 - 3067) < (5111 - (397 + 42)))) then
					if (((1146 + 2522) < (5361 - (24 + 776))) and v68.CastTargetIf(v64.Obliterate, v97, "max", v111, nil, not v15:IsInMeleeRange(7 - 2))) then
						return "obliterate breath_oblit 4";
					end
				end
				v135 = 786 - (222 + 563);
			end
			if ((v135 == (3 - 1)) or ((328 + 127) == (3795 - (23 + 167)))) then
				if ((v64.HornofWinter:IsReady() and (v14:RunicPowerDeficit() > (1823 - (690 + 1108)))) or ((961 + 1702) == (2732 + 580))) then
					if (((5125 - (40 + 808)) <= (737 + 3738)) and v29(v64.HornofWinter, v60)) then
						return "horn_of_winter breath_oblit 10";
					end
				end
				if ((v64.ArcaneTorrent:IsReady() and (v14:RunicPowerDeficit() > (76 - 56))) or ((832 + 38) == (630 + 559))) then
					if (((852 + 701) <= (3704 - (47 + 524))) and v29(v64.ArcaneTorrent, v54)) then
						return "arcane_torrent breath_oblit 12";
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v136 = 0 + 0;
		while true do
			if ((v136 == (5 - 3)) or ((3344 - 1107) >= (8007 - 4496))) then
				if ((v64.ChainsofIce:IsReady() and v64.Obliteration:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff) and (((v14:BuffStack(v64.ColdHeartBuff) >= (1740 - (1165 + 561))) and (v14:BuffUp(v64.UnholyStrengthBuff))) or (v14:BuffStack(v64.ColdHeartBuff) >= (1 + 18)) or ((v64.PillarofFrost:CooldownRemains() < (9 - 6)) and (v14:BuffStack(v64.ColdHeartBuff) >= (6 + 8))))) or ((1803 - (341 + 138)) > (816 + 2204))) then
					if (v29(v64.ChainsofIce, nil, not v15:IsSpellInRange(v64.ChainsofIce)) or ((6174 - 3182) == (2207 - (89 + 237)))) then
						return "chains_of_ice cold_heart 10";
					end
				end
				break;
			end
			if (((9991 - 6885) > (3212 - 1686)) and (v136 == (882 - (581 + 300)))) then
				if (((4243 - (855 + 365)) < (9192 - 5322)) and v64.ChainsofIce:IsReady() and not v64.Obliteration:IsAvailable() and v71 and v14:BuffDown(v64.PillarofFrostBuff) and (v64.PillarofFrost:CooldownRemains() > (5 + 10)) and (((v14:BuffStack(v64.ColdHeartBuff) >= (1245 - (1030 + 205))) and v14:BuffUp(v64.UnholyStrengthBuff)) or (v14:BuffStack(v64.ColdHeartBuff) >= (13 + 0)))) then
					if (((134 + 9) > (360 - (156 + 130))) and v29(v64.ChainsofIce, nil, not v15:IsSpellInRange(v64.ChainsofIce))) then
						return "chains_of_ice cold_heart 6";
					end
				end
				if (((40 - 22) < (3558 - 1446)) and v64.ChainsofIce:IsReady() and not v64.Obliteration:IsAvailable() and not v71 and (v14:BuffStack(v64.ColdHeartBuff) >= (20 - 10)) and v14:BuffDown(v64.PillarofFrostBuff) and (v64.PillarofFrost:CooldownRemains() > (6 + 14))) then
					if (((640 + 457) <= (1697 - (10 + 59))) and v29(v64.ChainsofIce, nil, not v15:IsSpellInRange(v64.ChainsofIce))) then
						return "chains_of_ice cold_heart 8";
					end
				end
				v136 = 1 + 1;
			end
			if (((22801 - 18171) == (5793 - (671 + 492))) and (v136 == (0 + 0))) then
				if (((4755 - (369 + 846)) > (711 + 1972)) and v64.ChainsofIce:IsReady() and (v90 < v14:GCD()) and ((v14:Rune() < (2 + 0)) or (v14:BuffDown(v64.KillingMachineBuff) and ((not v106 and (v14:BuffStack(v64.ColdHeartBuff) >= (1949 - (1036 + 909)))) or (v106 and (v14:BuffStack(v64.ColdHeartBuff) > (7 + 1))))) or (v14:BuffUp(v64.KillingMachineBuff) and ((not v106 and (v14:BuffStack(v64.ColdHeartBuff) > (13 - 5))) or (v106 and (v14:BuffStack(v64.ColdHeartBuff) > (213 - (11 + 192)))))))) then
					if (((2423 + 2371) >= (3450 - (135 + 40))) and v29(v64.ChainsofIce, nil, not v15:IsSpellInRange(v64.ChainsofIce))) then
						return "chains_of_ice cold_heart 2";
					end
				end
				if (((3595 - 2111) == (895 + 589)) and v64.ChainsofIce:IsReady() and not v64.Obliteration:IsAvailable() and v14:BuffUp(v64.PillarofFrostBuff) and (v14:BuffStack(v64.ColdHeartBuff) >= (22 - 12)) and ((v14:BuffRemains(v64.PillarofFrostBuff) < (v14:GCD() * ((1 - 0) + v21(v64.FrostwyrmsFury:IsAvailable() and v64.FrostwyrmsFury:IsReady())))) or (v14:BuffUp(v64.UnholyStrengthBuff) and (v14:BuffRemains(v64.UnholyStrengthBuff) < v14:GCD())))) then
					if (((1608 - (50 + 126)) < (9898 - 6343)) and v29(v64.ChainsofIce, nil, not v15:IsSpellInRange(v64.ChainsofIce))) then
						return "chains_of_ice cold_heart 4";
					end
				end
				v136 = 1 + 0;
			end
		end
	end
	local function v119()
		local v137 = 1413 - (1233 + 180);
		while true do
			if ((v137 == (973 - (522 + 447))) or ((2486 - (107 + 1314)) > (1661 + 1917))) then
				if ((v64.FrostwyrmsFury:IsCastable() and (((v94 == (2 - 1)) and ((v64.PillarofFrost:IsAvailable() and (v14:BuffRemains(v64.PillarofFrostBuff) < (v14:GCD() * (1 + 1))) and v14:BuffUp(v64.PillarofFrostBuff) and not v64.Obliteration:IsAvailable()) or not v64.PillarofFrost:IsAvailable())) or (v90 < (5 - 2)))) or ((18971 - 14176) < (3317 - (716 + 1194)))) then
					if (((32 + 1821) < (516 + 4297)) and v29(v64.FrostwyrmsFury, v59, nil, not v15:IsInRange(543 - (74 + 429)))) then
						return "frostwyrms_fury cooldowns 26";
					end
				end
				if ((v64.FrostwyrmsFury:IsCastable() and (v94 >= (3 - 1)) and v64.PillarofFrost:IsAvailable() and v14:BuffUp(v64.PillarofFrostBuff) and (v14:BuffRemains(v64.PillarofFrostBuff) < (v14:GCD() * (1 + 1)))) or ((6457 - 3636) < (1720 + 711))) then
					if (v29(v64.FrostwyrmsFury, v59, nil, not v15:IsInRange(123 - 83)) or ((7105 - 4231) < (2614 - (279 + 154)))) then
						return "frostwyrms_fury cooldowns 28";
					end
				end
				if ((v64.FrostwyrmsFury:IsCastable() and v64.Obliteration:IsAvailable() and ((v64.PillarofFrost:IsAvailable() and v14:BuffUp(v64.PillarofFrostBuff) and not v106) or (v14:BuffDown(v64.PillarofFrostBuff) and v106 and v64.PillarofFrost:CooldownDown()) or not v64.PillarofFrost:IsAvailable()) and ((v14:BuffRemains(v64.PillarofFrostBuff) < v14:GCD()) or (v14:BuffUp(v64.UnholyStrengthBuff) and (v14:BuffRemains(v64.UnholyStrengthBuff) < v14:GCD()))) and ((v15:DebuffStack(v64.RazoriceDebuff) == (783 - (454 + 324))) or (not v70 and not v64.GlacialAdvance:IsAvailable()))) or ((2116 + 573) <= (360 - (12 + 5)))) then
					if (v29(v64.FrostwyrmsFury, v59, nil, not v15:IsInRange(22 + 18)) or ((4761 - 2892) == (743 + 1266))) then
						return "frostwyrms_fury cooldowns 30";
					end
				end
				v137 = 1098 - (277 + 816);
			end
			if ((v137 == (12 - 9)) or ((4729 - (1058 + 125)) < (436 + 1886))) then
				if ((v64.PillarofFrost:IsCastable() and v64.BreathofSindragosa:IsAvailable() and (v80 or v79) and ((not v64.Icecap:IsAvailable() and ((v14:RunicPower() > (1045 - (815 + 160))) or (v64.BreathofSindragosa:CooldownRemains() > (171 - 131)))) or (v64.Icecap:IsAvailable() and ((v64.BreathofSindragosa:CooldownRemains() > (23 - 13)) or v14:BuffUp(v64.BreathofSindragosa))))) or ((497 + 1585) == (13952 - 9179))) then
					if (((5142 - (41 + 1857)) > (2948 - (1222 + 671))) and v29(v64.PillarofFrost, v62)) then
						return "pillar_of_frost cooldowns 20";
					end
				end
				if ((v64.PillarofFrost:IsCastable() and v64.Icecap:IsAvailable() and not v64.Obliteration:IsAvailable() and not v64.BreathofSindragosa:IsAvailable() and (v80 or v79)) or ((8562 - 5249) <= (2555 - 777))) then
					if (v29(v64.PillarofFrost, v62) or ((2603 - (229 + 953)) >= (3878 - (1111 + 663)))) then
						return "pillar_of_frost cooldowns 22";
					end
				end
				if (((3391 - (874 + 705)) <= (455 + 2794)) and v64.BreathofSindragosa:IsReady() and ((v14:BuffDown(v64.BreathofSindragosa) and (v14:RunicPower() > (41 + 19)) and (v80 or v79)) or (v90 < (62 - 32)))) then
					if (((46 + 1577) <= (2636 - (642 + 37))) and v29(v64.BreathofSindragosa, v57, nil, not v15:IsInRange(3 + 9))) then
						return "breath_of_sindragosa cooldowns 24";
					end
				end
				v137 = 1 + 3;
			end
			if (((11077 - 6665) == (4866 - (233 + 221))) and (v137 == (0 - 0))) then
				if (((1541 + 209) >= (2383 - (718 + 823))) and v64.EmpowerRuneWeapon:IsCastable() and ((v64.Obliteration:IsAvailable() and v14:BuffDown(v64.EmpowerRuneWeaponBuff) and (v14:Rune() < (4 + 2)) and (((v64.PillarofFrost:CooldownRemains() < (812 - (266 + 539))) and (v80 or v79)) or v14:BuffUp(v64.PillarofFrostBuff))) or (v90 < (56 - 36)))) then
					if (((5597 - (636 + 589)) > (4391 - 2541)) and v29(v64.EmpowerRuneWeapon, v51)) then
						return "empower_rune_weapon cooldowns 4";
					end
				end
				if (((478 - 246) < (651 + 170)) and v64.EmpowerRuneWeapon:IsCastable() and ((v14:BuffUp(v64.BreathofSindragosa) and v14:BuffDown(v64.EmpowerRuneWeaponBuff) and (v10.CombatTime() < (4 + 6)) and v14:BloodlustUp()) or ((v14:RunicPower() < (1085 - (657 + 358))) and (v14:Rune() < (7 - 4)) and ((v64.BreathofSindragosa:CooldownRemains() > v73) or (v64.EmpowerRuneWeapon:FullRechargeTime() < (22 - 12)))))) then
					if (((1705 - (1151 + 36)) < (872 + 30)) and v29(v64.EmpowerRuneWeapon, v51)) then
						return "empower_rune_weapon cooldowns 6";
					end
				end
				if (((788 + 2206) > (2562 - 1704)) and v64.EmpowerRuneWeapon:IsCastable() and not v64.BreathofSindragosa:IsAvailable() and not v64.Obliteration:IsAvailable() and v14:BuffDown(v64.EmpowerRuneWeaponBuff) and (v14:Rune() < (1837 - (1552 + 280))) and ((v64.PillarofFrost:CooldownRemains() < (841 - (64 + 770))) or v14:BuffUp(v64.PillarofFrostBuff) or not v64.PillarofFrost:IsAvailable())) then
					if (v29(v64.EmpowerRuneWeapon, v51) or ((2550 + 1205) <= (2077 - 1162))) then
						return "empower_rune_weapon cooldowns 8";
					end
				end
				v137 = 1 + 0;
			end
			if (((5189 - (157 + 1086)) > (7491 - 3748)) and (v137 == (8 - 6))) then
				if ((v64.ChillStreak:IsReady() and (v14:HasTier(47 - 16, 2 - 0))) or ((2154 - (599 + 220)) >= (6583 - 3277))) then
					if (((6775 - (1813 + 118)) > (1647 + 606)) and v29(v64.ChillStreak, nil, nil, not v15:IsSpellInRange(v64.ChillStreak))) then
						return "chill_streak cooldowns 15";
					end
				end
				if (((1669 - (841 + 376)) == (632 - 180)) and v64.ChillStreak:IsReady() and not v14:HasTier(8 + 23, 5 - 3) and (v94 >= (861 - (464 + 395))) and ((v14:BuffDown(v64.DeathAndDecayBuff) and v64.CleavingStrikes:IsAvailable()) or not v64.CleavingStrikes:IsAvailable() or (v94 <= (12 - 7)))) then
					if (v29(v64.ChillStreak, nil, nil, not v15:IsSpellInRange(v64.ChillStreak)) or ((2189 + 2368) < (2924 - (467 + 370)))) then
						return "chill_streak cooldowns 16";
					end
				end
				if (((8005 - 4131) == (2844 + 1030)) and v64.PillarofFrost:IsCastable() and ((v64.Obliteration:IsAvailable() and (v80 or v79) and (v14:BuffUp(v64.EmpowerRuneWeaponBuff) or (v64.EmpowerRuneWeapon:CooldownRemains() > (0 - 0)))) or (v90 < (2 + 10)))) then
					if (v29(v64.PillarofFrost, v62) or ((4508 - 2570) > (5455 - (150 + 370)))) then
						return "pillar_of_frost cooldowns 18";
					end
				end
				v137 = 1285 - (74 + 1208);
			end
			if ((v137 == (14 - 8)) or ((20179 - 15924) < (2436 + 987))) then
				if (((1844 - (14 + 376)) <= (4320 - 1829)) and v64.DeathAndDecay:IsReady() and v14:BuffDown(v64.DeathAndDecayBuff) and v80 and ((v14:BuffUp(v64.PillarofFrostBuff) and (v14:BuffRemains(v64.PillarofFrostBuff) > (4 + 1)) and (v14:BuffRemains(v64.PillarofFrostBuff) < (10 + 1))) or (v14:BuffDown(v64.PillarofFrostBuff) and (v64.PillarofFrost:CooldownRemains() > (10 + 0))) or (v90 < (32 - 21))) and ((v94 > (4 + 1)) or (v64.CleavingStrikes:IsAvailable() and (v94 >= (80 - (23 + 55)))))) then
					if (v29(v66.DaDPlayer, v50) or ((9851 - 5694) <= (1871 + 932))) then
						return "death_and_decay cooldowns 38";
					end
				end
				break;
			end
			if (((4358 + 495) >= (4623 - 1641)) and (v137 == (2 + 3))) then
				if (((5035 - (652 + 249)) > (8983 - 5626)) and v64.RaiseDead:IsCastable()) then
					if (v29(v64.RaiseDead, nil) or ((5285 - (708 + 1160)) < (6878 - 4344))) then
						return "raise_dead cooldowns 32";
					end
				end
				if ((v64.SoulReaper:IsReady() and (v90 > (9 - 4)) and ((v15:TimeToX(62 - (10 + 17)) < (2 + 3)) or (v15:HealthPercentage() <= (1767 - (1400 + 332)))) and (v94 <= (3 - 1)) and ((v64.Obliteration:IsAvailable() and ((v14:BuffUp(v64.PillarofFrostBuff) and v14:BuffDown(v64.KillingMachineBuff)) or v14:BuffDown(v64.PillarofFrostBuff))) or (v64.BreathofSindragosa:IsAvailable() and ((v14:BuffUp(v64.BreathofSindragosa) and (v14:RunicPower() > (1948 - (242 + 1666)))) or v14:BuffDown(v64.BreathofSindragosa))) or (not v64.BreathofSindragosa:IsAvailable() and not v64.Obliteration:IsAvailable()))) or ((1165 + 1557) <= (61 + 103))) then
					if (v29(v64.SoulReaper, nil, nil, not v15:IsInMeleeRange(5 + 0)) or ((3348 - (850 + 90)) < (3693 - 1584))) then
						return "soul_reaper cooldowns 34";
					end
				end
				if ((v64.SacrificialPact:IsReady() and not v64.GlacialAdvance:IsAvailable() and v14:BuffDown(v64.BreathofSindragosa) and (v91:GhoulRemains() < (v14:GCD() * (1392 - (360 + 1030)))) and (v94 > (3 + 0))) or ((92 - 59) == (2001 - 546))) then
					if (v29(v64.SacrificialPact, v52) or ((2104 - (909 + 752)) >= (5238 - (109 + 1114)))) then
						return "sacrificial_pact cooldowns 36";
					end
				end
				v137 = 10 - 4;
			end
			if (((1317 + 2065) > (408 - (6 + 236))) and (v137 == (1 + 0))) then
				if ((v64.AbominationLimb:IsCastable() and ((v64.Obliteration:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff) and (v64.PillarofFrost:CooldownRemains() < (3 + 0)) and (v80 or v79)) or (v90 < (27 - 15)))) or ((489 - 209) == (4192 - (1076 + 57)))) then
					if (((310 + 1571) > (1982 - (579 + 110))) and v29(v64.AbominationLimb, nil, not v15:IsInRange(2 + 18))) then
						return "abomination_limb_talent cooldowns 10";
					end
				end
				if (((2084 + 273) == (1251 + 1106)) and v64.AbominationLimb:IsCastable() and v64.BreathofSindragosa:IsAvailable() and (v80 or v79)) then
					if (((530 - (174 + 233)) == (343 - 220)) and v29(v64.AbominationLimb, nil, not v15:IsInRange(35 - 15))) then
						return "abomination_limb_talent cooldowns 12";
					end
				end
				if ((v64.AbominationLimb:IsCastable() and not v64.BreathofSindragosa:IsAvailable() and not v64.Obliteration:IsAvailable() and (v80 or v79)) or ((470 + 586) >= (4566 - (663 + 511)))) then
					if (v29(v64.AbominationLimb, nil, not v15:IsInRange(18 + 2)) or ((235 + 846) < (3314 - 2239))) then
						return "abomination_limb_talent cooldowns 14";
					end
				end
				v137 = 2 + 0;
			end
		end
	end
	local function v120()
		local v138 = 0 - 0;
		while true do
			if (((9 - 5) == v138) or ((501 + 548) >= (8626 - 4194))) then
				if ((v64.RemorselessWinter:IsReady() and not v64.BreathofSindragosa:IsAvailable() and not v64.Obliteration:IsAvailable() and v72) or ((3399 + 1369) <= (78 + 768))) then
					if (v29(v64.RemorselessWinter, nil, nil, not v15:IsInMeleeRange(730 - (478 + 244))) or ((3875 - (440 + 77)) <= (646 + 774))) then
						return "remorseless_winter high_prio_actions 20";
					end
				end
				if ((v64.RemorselessWinter:IsReady() and v64.Obliteration:IsAvailable() and (v94 >= (10 - 7)) and v80) or ((5295 - (655 + 901)) <= (558 + 2447))) then
					if (v29(v64.RemorselessWinter, nil, nil, not v15:IsInMeleeRange(7 + 1)) or ((1121 + 538) >= (8596 - 6462))) then
						return "remorseless_winter high_prio_actions 22";
					end
				end
				break;
			end
			if (((1446 - (695 + 750)) == v138) or ((11132 - 7872) < (3633 - 1278))) then
				if ((v64.GlacialAdvance:IsReady() and (v94 >= (7 - 5)) and v82 and v64.Obliteration:IsAvailable() and v64.BreathofSindragosa:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff) and v14:BuffDown(v64.BreathofSindragosa) and (v64.BreathofSindragosa:CooldownRemains() > v86)) or ((1020 - (285 + 66)) == (9844 - 5621))) then
					if (v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(1410 - (682 + 628))) or ((273 + 1419) < (887 - (176 + 123)))) then
						return "glacial_advance high_prio_actions 8";
					end
				end
				if ((v64.GlacialAdvance:IsReady() and (v94 >= (1 + 1)) and v82 and v64.BreathofSindragosa:IsAvailable() and v14:BuffDown(v64.BreathofSindragosa) and (v64.BreathofSindragosa:CooldownRemains() > v86)) or ((3480 + 1317) < (3920 - (239 + 30)))) then
					if (v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(28 + 72)) or ((4015 + 162) > (8584 - 3734))) then
						return "glacial_advance high_prio_actions 10";
					end
				end
				v138 = 5 - 3;
			end
			if ((v138 == (318 - (306 + 9))) or ((1395 - 995) > (194 + 917))) then
				if (((1872 + 1179) > (484 + 521)) and v64.FrostStrike:IsReady() and (v94 == (2 - 1)) and v82 and v64.BreathofSindragosa:IsAvailable() and v14:BuffDown(v64.BreathofSindragosa) and (v64.BreathofSindragosa:CooldownRemains() > v86)) then
					if (((5068 - (1140 + 235)) <= (2789 + 1593)) and v29(v64.FrostStrike, nil, nil, not v15:IsSpellInRange(v64.FrostStrike))) then
						return "frost_strike high_prio_actions 16";
					end
				end
				if ((v64.FrostStrike:IsReady() and (v94 == (1 + 0)) and v82 and not v64.BreathofSindragosa:IsAvailable() and v64.Obliteration:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff)) or ((843 + 2439) > (4152 - (33 + 19)))) then
					if (v29(v64.FrostStrike, nil, nil, not v15:IsSpellInRange(v64.FrostStrike)) or ((1293 + 2287) < (8524 - 5680))) then
						return "frost_strike high_prio_actions 18";
					end
				end
				v138 = 2 + 2;
			end
			if (((174 - 85) < (4211 + 279)) and (v138 == (691 - (586 + 103)))) then
				if ((v64.GlacialAdvance:IsReady() and (v94 >= (1 + 1)) and v82 and not v64.BreathofSindragosa:IsAvailable() and v64.Obliteration:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff)) or ((15340 - 10357) < (3296 - (1309 + 179)))) then
					if (((6912 - 3083) > (1641 + 2128)) and v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(268 - 168))) then
						return "glacial_advance high_prio_actions 12";
					end
				end
				if (((1122 + 363) <= (6169 - 3265)) and v64.FrostStrike:IsReady() and (v94 == (1 - 0)) and v82 and v64.Obliteration:IsAvailable() and v64.BreathofSindragosa:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff) and v14:BuffDown(v64.BreathofSindragosa) and (v64.BreathofSindragosa:CooldownRemains() > v86)) then
					if (((4878 - (295 + 314)) == (10485 - 6216)) and v29(v64.FrostStrike, nil, nil, not v15:IsSpellInRange(v64.FrostStrike))) then
						return "frost_strike high_prio_actions 14";
					end
				end
				v138 = 1965 - (1300 + 662);
			end
			if (((1215 - 828) <= (4537 - (1178 + 577))) and ((0 + 0) == v138)) then
				if ((v47 and v28) or ((5613 - 3714) <= (2322 - (851 + 554)))) then
					local v167 = 0 + 0;
					while true do
						if ((v167 == (0 - 0)) or ((9364 - 5052) <= (1178 - (115 + 187)))) then
							if (((1710 + 522) <= (2458 + 138)) and v64.AntiMagicShell:IsCastable() and (v14:RunicPowerDeficit() > (157 - 117))) then
								if (((3256 - (160 + 1001)) < (3225 + 461)) and v29(v64.AntiMagicShell, v48)) then
									return "antimagic_shell high_prio_actions 2";
								end
							end
							if ((v64.AntiMagicZone:IsCastable() and (v14:RunicPowerDeficit() > (49 + 21)) and v64.Assimilation:IsAvailable() and ((v14:BuffUp(v64.BreathofSindragosa) and (v64.EmpowerRuneWeapon:Charges() < (3 - 1))) or (not v64.BreathofSindragosa:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff)))) or ((1953 - (237 + 121)) >= (5371 - (525 + 372)))) then
								if (v29(v64.AntiMagicZone, v49) or ((8756 - 4137) < (9468 - 6586))) then
									return "antimagic_zone high_prio_actions 4";
								end
							end
							break;
						end
					end
				end
				if ((v64.HowlingBlast:IsReady() and v15:DebuffDown(v64.FrostFeverDebuff) and (v94 >= (144 - (96 + 46))) and (not v64.Obliteration:IsAvailable() or (v64.Obliteration:IsAvailable() and (v64.PillarofFrost:CooldownDown() or (v14:BuffUp(v64.PillarofFrostBuff) and v14:BuffDown(v64.KillingMachineBuff)))))) or ((1071 - (643 + 134)) >= (1744 + 3087))) then
					if (((4864 - 2835) <= (11449 - 8365)) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return "howling_blast high_prio_actions 6";
					end
				end
				v138 = 1 + 0;
			end
		end
	end
	local function v121()
		local v139 = 0 - 0;
		while true do
			if ((v139 == (1 - 0)) or ((2756 - (316 + 403)) == (1609 + 811))) then
				if (((12256 - 7798) > (1411 + 2493)) and v64.GlacialAdvance:IsReady() and (v14:BuffStack(v64.KillingMachineBuff) < (4 - 2)) and (v14:BuffRemains(v64.PillarofFrostBuff) < v14:GCD()) and v14:BuffDown(v64.DeathAndDecayBuff)) then
					if (((309 + 127) >= (40 + 83)) and v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(346 - 246))) then
						return "glacial_advance obliteration 8";
					end
				end
				if (((2387 - 1887) < (3772 - 1956)) and v64.Obliterate:IsReady() and v14:BuffUp(v64.KillingMachineBuff) and not v84) then
					if (((205 + 3369) == (7035 - 3461)) and v68.CastTargetIf(v64.Obliterate, v97, "max", v111, nil, not v15:IsInMeleeRange(1 + 4))) then
						return "obliterate obliteration 10";
					end
				end
				if (((650 - 429) < (407 - (12 + 5))) and v64.Frostscythe:IsReady() and v14:BuffUp(v64.KillingMachineBuff) and v84) then
					if (v29(v64.Frostscythe, nil, nil, not v15:IsInMeleeRange(30 - 22)) or ((4721 - 2508) <= (3020 - 1599))) then
						return "frostscythe obliteration 12";
					end
				end
				v139 = 4 - 2;
			end
			if (((621 + 2437) < (6833 - (1656 + 317))) and ((3 + 0) == v139)) then
				if ((v64.HowlingBlast:IsReady() and v14:BuffUp(v64.RimeBuff) and v14:BuffDown(v64.KillingMachineBuff)) or ((1039 + 257) >= (11821 - 7375))) then
					if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or ((6855 - 5462) > (4843 - (5 + 349)))) then
						return "howling_blast obliteration 20";
					end
				end
				if ((v64.GlacialAdvance:IsReady() and not v88 and v82 and v14:BuffDown(v64.KillingMachineBuff) and (v94 >= (9 - 7))) or ((5695 - (266 + 1005)) < (18 + 9))) then
					if (v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(341 - 241)) or ((2628 - 631) > (5511 - (561 + 1135)))) then
						return "glacial_advance obliteration 22";
					end
				end
				if (((4514 - 1049) > (6288 - 4375)) and v64.FrostStrike:IsReady() and v14:BuffDown(v64.KillingMachineBuff) and not v88 and (not v64.GlacialAdvance:IsAvailable() or (v94 == (1067 - (507 + 559))))) then
					if (((1839 - 1106) < (5625 - 3806)) and v29(v64.FrostStrike, v58, nil, not v15:IsInMeleeRange(393 - (212 + 176)))) then
						return "frost_strike obliteration 24";
					end
				end
				v139 = 909 - (250 + 655);
			end
			if ((v139 == (0 - 0)) or ((7679 - 3284) == (7439 - 2684))) then
				if ((v64.RemorselessWinter:IsReady() and ((v94 > (1959 - (1869 + 87))) or v64.GatheringStorm:IsAvailable())) or ((13155 - 9362) < (4270 - (484 + 1417)))) then
					if (v29(v64.RemorselessWinter, nil, nil, not v15:IsInMeleeRange(16 - 8)) or ((6844 - 2760) == (1038 - (48 + 725)))) then
						return "remorseless_winter obliteration 2";
					end
				end
				if (((7118 - 2760) == (11691 - 7333)) and v64.HowlingBlast:IsReady() and (v14:BuffStack(v64.KillingMachineBuff) < (2 + 0)) and (v14:BuffRemains(v64.PillarofFrostBuff) < v14:GCD()) and v14:BuffUp(v64.RimeBuff)) then
					if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or ((8386 - 5248) < (278 + 715))) then
						return "howling_blast obliteration 4";
					end
				end
				if (((971 + 2359) > (3176 - (152 + 701))) and v64.FrostStrike:IsReady() and (v14:BuffStack(v64.KillingMachineBuff) < (1313 - (430 + 881))) and (v14:BuffRemains(v64.PillarofFrostBuff) < v14:GCD()) and v14:BuffDown(v64.DeathAndDecayBuff)) then
					if (v29(v64.FrostStrike, v58, nil, not v15:IsInMeleeRange(2 + 3)) or ((4521 - (557 + 338)) == (1180 + 2809))) then
						return "frost_strike obliteration 6";
					end
				end
				v139 = 2 - 1;
			end
			if ((v139 == (13 - 9)) or ((2433 - 1517) == (5756 - 3085))) then
				if (((1073 - (499 + 302)) == (1138 - (39 + 827))) and v64.HowlingBlast:IsReady() and v14:BuffDown(v64.KillingMachineBuff) and (v14:RunicPower() < (68 - 43))) then
					if (((9489 - 5240) <= (19219 - 14380)) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return "howling_blast obliteration 26";
					end
				end
				if (((4263 - 1486) < (274 + 2926)) and v28 and v64.ArcaneTorrent:IsReady() and (v14:Rune() < (2 - 1)) and (v14:RunicPower() < (4 + 21))) then
					if (((150 - 55) < (2061 - (103 + 1))) and v29(v64.ArcaneTorrent, v54)) then
						return "arcane_torrent obliteration 28";
					end
				end
				if (((1380 - (475 + 79)) < (3711 - 1994)) and v64.GlacialAdvance:IsReady() and not v88 and (v94 >= (6 - 4))) then
					if (((185 + 1241) >= (973 + 132)) and v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(1603 - (1395 + 108)))) then
						return "glacial_advance obliteration 30";
					end
				end
				v139 = 14 - 9;
			end
			if (((3958 - (7 + 1197)) <= (1474 + 1905)) and ((2 + 3) == v139)) then
				if ((v64.FrostStrike:IsReady() and not v88 and (not v64.GlacialAdvance:IsAvailable() or (v94 == (320 - (27 + 292))))) or ((11507 - 7580) == (1801 - 388))) then
					if (v68.CastTargetIf(v64.FrostStrike, v97, "max", v111, nil, not v15:IsInMeleeRange(20 - 15)) or ((2275 - 1121) <= (1500 - 712))) then
						return "frost_strike obliteration 32";
					end
				end
				if ((v64.HowlingBlast:IsReady() and (v14:BuffUp(v64.RimeBuff))) or ((1782 - (43 + 96)) > (13783 - 10404))) then
					if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or ((6337 - 3534) > (3775 + 774))) then
						return "howling_blast obliteration 34";
					end
				end
				if (v64.Obliterate:IsReady() or ((63 + 157) >= (5972 - 2950))) then
					if (((1082 + 1740) == (5288 - 2466)) and v68.CastTargetIf(v64.Obliterate, v97, "max", v111, nil, not v15:IsInMeleeRange(2 + 3))) then
						return "obliterate obliteration 36";
					end
				end
				break;
			end
			if ((v139 == (1 + 1)) or ((2812 - (1414 + 337)) == (3797 - (1642 + 298)))) then
				if (((7194 - 4434) > (3923 - 2559)) and v64.HowlingBlast:IsReady() and v14:BuffDown(v64.KillingMachineBuff) and (v15:DebuffDown(v64.FrostFeverDebuff) or (v14:BuffUp(v64.RimeBuff) and v14:HasTier(89 - 59, 1 + 1) and not v82))) then
					if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or ((3814 + 1088) <= (4567 - (357 + 615)))) then
						return "howling_blast obliteration 14";
					end
				end
				if ((v64.GlacialAdvance:IsReady() and v14:BuffDown(v64.KillingMachineBuff) and ((not v70 and (not v64.Avalanche:IsAvailable() or (v15:DebuffStack(v64.RazoriceDebuff) < (4 + 1)) or (v15:DebuffRemains(v64.RazoriceDebuff) < (v14:GCD() * (6 - 3))))) or (v82 and (v93 > (1 + 0))))) or ((8254 - 4402) == (235 + 58))) then
					if (v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(7 + 93)) or ((980 + 579) == (5889 - (384 + 917)))) then
						return "glacial_advance obliteration 16";
					end
				end
				if ((v64.FrostStrike:IsReady() and v14:BuffDown(v64.KillingMachineBuff) and ((v14:Rune() < (699 - (128 + 569))) or v82 or ((v15:DebuffStack(v64.RazoriceDebuff) == (1548 - (1407 + 136))) and v64.ShatteringBlade:IsAvailable())) and not v88 and (not v64.GlacialAdvance:IsAvailable() or (v94 == (1888 - (687 + 1200))))) or ((6194 - (556 + 1154)) == (2772 - 1984))) then
					if (((4663 - (9 + 86)) >= (4328 - (275 + 146))) and v29(v64.FrostStrike, v58, nil, not v15:IsInMeleeRange(1 + 4))) then
						return "frost_strike obliteration 18";
					end
				end
				v139 = 67 - (29 + 35);
			end
		end
	end
	local function v122()
		if (((5522 - 4276) < (10364 - 6894)) and v83) then
			local v145 = 0 - 0;
			while true do
				if (((2650 + 1418) >= (1984 - (53 + 959))) and (v145 == (409 - (312 + 96)))) then
					if (((855 - 362) < (4178 - (147 + 138))) and v64.ArcanePulse:IsCastable()) then
						if (v29(v64.ArcanePulse, v54, nil, not v15:IsInRange(907 - (813 + 86))) or ((1332 + 141) >= (6172 - 2840))) then
							return "arcane_pulse racials 6";
						end
					end
					if (v64.LightsJudgment:IsCastable() or ((4543 - (18 + 474)) <= (391 + 766))) then
						if (((1971 - 1367) < (3967 - (860 + 226))) and v29(v64.LightsJudgment, v54, nil, not v15:IsSpellInRange(v64.LightsJudgment))) then
							return "lights_judgment racials 8";
						end
					end
					v145 = 305 - (121 + 182);
				end
				if ((v145 == (0 + 0)) or ((2140 - (988 + 252)) == (382 + 2995))) then
					if (((1397 + 3062) > (2561 - (49 + 1921))) and v64.BloodFury:IsCastable()) then
						if (((4288 - (223 + 667)) >= (2447 - (51 + 1))) and v29(v64.BloodFury, v54)) then
							return "blood_fury racials 2";
						end
					end
					if (v64.Berserking:IsCastable() or ((3757 - 1574) >= (6046 - 3222))) then
						if (((3061 - (146 + 979)) == (547 + 1389)) and v29(v64.Berserking, v54)) then
							return "berserking racials 4";
						end
					end
					v145 = 606 - (311 + 294);
				end
				if ((v145 == (5 - 3)) or ((2047 + 2785) < (5756 - (496 + 947)))) then
					if (((5446 - (1233 + 125)) > (1573 + 2301)) and v64.AncestralCall:IsCastable()) then
						if (((3887 + 445) == (824 + 3508)) and v29(v64.AncestralCall, v54)) then
							return "ancestral_call racials 10";
						end
					end
					if (((5644 - (963 + 682)) >= (2421 + 479)) and v64.Fireblood:IsCastable()) then
						if (v29(v64.Fireblood, v54) or ((4029 - (504 + 1000)) > (2737 + 1327))) then
							return "fireblood racials 12";
						end
					end
					break;
				end
			end
		end
		if (((3981 + 390) == (413 + 3958)) and v64.BagofTricks:IsCastable() and v64.Obliteration:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff) and v14:BuffUp(v64.UnholyStrengthBuff)) then
			if (v29(v64.BagofTricks, v54, nil, not v15:IsInRange(58 - 18)) or ((228 + 38) > (2900 + 2086))) then
				return "bag_of_tricks racials 14";
			end
		end
		if (((2173 - (156 + 26)) >= (533 + 392)) and v64.BagofTricks:IsCastable() and not v64.Obliteration:IsAvailable() and v14:BuffUp(v64.PillarofFrostBuff) and ((v14:BuffUp(v64.UnholyStrengthBuff) and (v14:BuffRemains(v64.UnholyStrengthBuff) < (v14:GCD() * (3 - 0)))) or (v14:BuffRemains(v64.PillarofFrostBuff) < (v14:GCD() * (167 - (149 + 15)))))) then
			if (((1415 - (890 + 70)) < (2170 - (39 + 78))) and v29(v64.BagofTricks, v54, nil, not v15:IsInRange(522 - (14 + 468)))) then
				return "bag_of_tricks racials 16";
			end
		end
	end
	local function v123()
		local v140 = 0 - 0;
		while true do
			if ((v140 == (8 - 5)) or ((427 + 399) == (2914 + 1937))) then
				if (((39 + 144) == (83 + 100)) and v64.GlacialAdvance:IsReady() and not v88 and not v70 and ((v15:DebuffStack(v64.RazoriceDebuff) < (2 + 3)) or (v15:DebuffRemains(v64.RazoriceDebuff) < (v14:GCD() * (5 - 2))))) then
					if (((1146 + 13) <= (6282 - 4494)) and v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(3 + 97))) then
						return "glacial_advance single_target 20";
					end
				end
				if ((v64.Obliterate:IsReady() and not v87) or ((3558 - (12 + 39)) > (4018 + 300))) then
					if (v29(v64.Obliterate, nil, nil, not v15:IsInMeleeRange(15 - 10)) or ((10951 - 7876) <= (879 + 2086))) then
						return "obliterate single_target 22";
					end
				end
				if (((719 + 646) <= (5099 - 3088)) and v64.HornofWinter:IsReady() and (v14:Rune() < (3 + 1)) and (v14:RunicPowerDeficit() > (120 - 95)) and (not v64.BreathofSindragosa:IsAvailable() or (v64.BreathofSindragosa:CooldownRemains() > (1755 - (1596 + 114))))) then
					if (v29(v64.HornofWinter, v60) or ((7247 - 4471) > (4288 - (164 + 549)))) then
						return "horn_of_winter single_target 24";
					end
				end
				v140 = 1442 - (1059 + 379);
			end
			if ((v140 == (1 - 0)) or ((1324 + 1230) == (810 + 3994))) then
				if (((2969 - (145 + 247)) == (2115 + 462)) and v64.Frostscythe:IsReady() and v14:BuffUp(v64.KillingMachineBuff) and v84) then
					if (v29(v64.Frostscythe, nil, nil, not v15:IsInMeleeRange(4 + 4)) or ((17 - 11) >= (363 + 1526))) then
						return "frostscythe single_target 8";
					end
				end
				if (((436 + 70) <= (3071 - 1179)) and v64.Obliterate:IsReady() and (v14:BuffUp(v64.KillingMachineBuff))) then
					if (v29(v64.Obliterate, nil, nil, not v15:IsInMeleeRange(725 - (254 + 466))) or ((2568 - (544 + 16)) > (7048 - 4830))) then
						return "obliterate single_target 10";
					end
				end
				if (((1007 - (294 + 334)) <= (4400 - (236 + 17))) and v64.HowlingBlast:IsReady() and v14:BuffUp(v64.RimeBuff) and (v64.Icebreaker:TalentRank() == (1 + 1))) then
					if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or ((3514 + 1000) <= (3799 - 2790))) then
						return "howling_blast single_target 12";
					end
				end
				v140 = 9 - 7;
			end
			if ((v140 == (2 + 0)) or ((2880 + 616) == (1986 - (413 + 381)))) then
				if ((v64.HornofWinter:IsReady() and (v14:Rune() < (1 + 3)) and (v14:RunicPowerDeficit() > (52 - 27)) and v64.Obliteration:IsAvailable() and v64.BreathofSindragosa:IsAvailable()) or ((539 - 331) == (4929 - (582 + 1388)))) then
					if (((7287 - 3010) >= (940 + 373)) and v29(v64.HornofWinter, v60)) then
						return "horn_of_winter single_target 14";
					end
				end
				if (((2951 - (326 + 38)) < (9389 - 6215)) and v64.FrostStrike:IsReady() and not v88 and (v82 or (v14:RunicPowerDeficit() < (35 - 10)) or ((v15:DebuffStack(v64.RazoriceDebuff) == (625 - (47 + 573))) and v64.ShatteringBlade:IsAvailable()))) then
					if (v29(v64.FrostStrike, v58, nil, not v15:IsInMeleeRange(2 + 3)) or ((17497 - 13377) <= (3567 - 1369))) then
						return "frost_strike single_target 16";
					end
				end
				if ((v64.HowlingBlast:IsReady() and v81) or ((3260 - (1269 + 395)) == (1350 - (76 + 416)))) then
					if (((3663 - (319 + 124)) == (7360 - 4140)) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return "howling_blast single_target 18";
					end
				end
				v140 = 1010 - (564 + 443);
			end
			if ((v140 == (10 - 6)) or ((1860 - (337 + 121)) > (10606 - 6986))) then
				if (((8574 - 6000) == (4485 - (1261 + 650))) and v28 and v64.ArcaneTorrent:IsReady() and (v14:RunicPowerDeficit() > (9 + 11))) then
					if (((2865 - 1067) < (4574 - (772 + 1045))) and v29(v64.ArcaneTorrent, v54)) then
						return "arcane_torrent single_target 26";
					end
				end
				if ((v64.FrostStrike:IsReady() and not v88) or ((54 + 323) > (2748 - (102 + 42)))) then
					if (((2412 - (1524 + 320)) < (2181 - (1049 + 221))) and v29(v64.FrostStrike, v58, nil, not v15:IsInMeleeRange(161 - (18 + 138)))) then
						return "frost_strike single_target 28";
					end
				end
				break;
			end
			if (((8040 - 4755) < (5330 - (67 + 1035))) and (v140 == (348 - (136 + 212)))) then
				if (((16640 - 12724) > (2667 + 661)) and v64.RemorselessWinter:IsReady() and (v72 or v80)) then
					if (((2305 + 195) < (5443 - (240 + 1364))) and v29(v64.RemorselessWinter, nil, nil, not v15:IsInMeleeRange(1090 - (1050 + 32)))) then
						return "remorseless_winter single_target 2";
					end
				end
				if (((1810 - 1303) == (300 + 207)) and v64.FrostStrike:IsReady() and (v14:BuffStack(v64.KillingMachineBuff) < (1057 - (331 + 724))) and (v14:RunicPowerDeficit() < (2 + 18)) and not v106) then
					if (((884 - (269 + 375)) <= (3890 - (267 + 458))) and v29(v64.FrostStrike, v58, nil, not v15:IsInMeleeRange(2 + 3))) then
						return "frost_strike single_target 4";
					end
				end
				if (((1603 - 769) >= (1623 - (667 + 151))) and v64.HowlingBlast:IsReady() and v14:BuffUp(v64.RimeBuff) and v14:HasTier(1527 - (1410 + 87), 1899 - (1504 + 393)) and (v14:BuffStack(v64.KillingMachineBuff) < (5 - 3))) then
					if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or ((9889 - 6077) < (3112 - (461 + 335)))) then
						return "howling_blast single_target 6";
					end
				end
				v140 = 1 + 0;
			end
		end
	end
	local function v124()
		local v141 = v14:GCD() + (1761.25 - (1730 + 31));
		v79 = (v94 == (1668 - (728 + 939))) or not v27;
		v80 = (v94 >= (6 - 4)) and v27;
		v81 = v14:BuffUp(v64.RimeBuff) and (v64.RageoftheFrozenChampion:IsAvailable() or v64.Avalanche:IsAvailable() or v64.Icebreaker:IsAvailable());
		v82 = (v64.UnleashedFrenzy:IsAvailable() and ((v14:BuffRemains(v64.UnleashedFrenzyBuff) < (v141 * (5 - 2))) or (v14:BuffStack(v64.UnleashedFrenzyBuff) < (6 - 3)))) or (v64.IcyTalons:IsAvailable() and ((v14:BuffRemains(v64.IcyTalonsBuff) < (v141 * (1071 - (138 + 930)))) or (v14:BuffStack(v64.IcyTalonsBuff) < (3 + 0))));
		v83 = (v64.PillarofFrost:IsAvailable() and v14:BuffUp(v64.PillarofFrostBuff) and ((v64.Obliteration:IsAvailable() and (v14:BuffRemains(v64.PillarofFrostBuff) < (5 + 1))) or not v64.Obliteration:IsAvailable())) or (not v64.PillarofFrost:IsAvailable() and v14:BuffUp(v64.EmpowerRuneWeaponBuff)) or (not v64.PillarofFrost:IsAvailable() and not v64.EmpowerRuneWeapon:IsAvailable()) or ((v93 >= (2 + 0)) and v14:BuffUp(v64.PillarofFrostBuff));
		v84 = v64.Frostscythe:IsAvailable() and (v14:BuffUp(v64.KillingMachineBuff) or (v94 >= (12 - 9))) and ((not v64.ImprovedObliterate:IsAvailable() and not v64.FrigidExecutioner:IsAvailable() and not v64.Frostreaper:IsAvailable() and not v64.MightoftheFrozenWastes:IsAvailable()) or not v64.CleavingStrikes:IsAvailable() or (v64.CleavingStrikes:IsAvailable() and ((v94 > (1772 - (459 + 1307))) or (v14:BuffDown(v64.DeathAndDecayBuff) and (v94 > (1873 - (474 + 1396)))))));
		if (((v14:RunicPower() < (61 - 26)) and (v14:Rune() < (2 + 0)) and (v64.PillarofFrost:CooldownRemains() < (1 + 9))) or ((7596 - 4944) <= (195 + 1338))) then
			v85 = (((v64.PillarofFrost:CooldownRemains() + (3 - 2)) / v141) / ((v14:Rune() + (12 - 9)) * (v14:RunicPower() + (596 - (562 + 29))))) * (86 + 14);
		else
			v85 = 1422 - (374 + 1045);
		end
		if (((v14:RunicPowerDeficit() > (8 + 2)) and (v64.BreathofSindragosa:CooldownRemains() < (31 - 21))) or ((4236 - (448 + 190)) < (472 + 988))) then
			v86 = (((v64.BreathofSindragosa:CooldownRemains() + 1 + 0) / v141) / ((v14:Rune() + 1 + 0) * (v14:RunicPower() + (76 - 56)))) * (310 - 210);
		else
			v86 = 1497 - (1307 + 187);
		end
		v87 = (v14:Rune() < (15 - 11)) and v64.Obliteration:IsAvailable() and (v64.PillarofFrost:CooldownRemains() < v85);
		v88 = (v64.BreathofSindragosa:IsAvailable() and (v64.BreathofSindragosa:CooldownRemains() < v86)) or (v64.Obliteration:IsAvailable() and (v14:RunicPower() < (81 - 46)) and (v64.PillarofFrost:CooldownRemains() < v85));
	end
	local function v125()
		local v142 = 0 - 0;
		while true do
			if ((v142 == (683 - (232 + 451))) or ((3931 + 185) < (1053 + 139))) then
				v63();
				v26 = EpicSettings.Toggles['ooc'];
				v142 = 565 - (510 + 54);
			end
			if ((v142 == (1 - 0)) or ((3413 - (13 + 23)) <= (1759 - 856))) then
				v27 = EpicSettings.Toggles['aoe'];
				v28 = EpicSettings.Toggles['cds'];
				v142 = 2 - 0;
			end
			if (((7223 - 3247) >= (1527 - (830 + 258))) and (v142 == (10 - 7))) then
				if (((2348 + 1404) == (3193 + 559)) and (v68.TargetIsValid() or v14:AffectingCombat())) then
					v89 = v10.BossFightRemains();
					v90 = v89;
					if (((5487 - (860 + 581)) > (9940 - 7245)) and (v90 == (8819 + 2292))) then
						v90 = v10.FightRemains(v97, false);
					end
				end
				if (v68.TargetIsValid() or ((3786 - (237 + 4)) == (7513 - 4316))) then
					local v168 = 0 - 0;
					local v169;
					while true do
						if (((4538 - 2144) > (306 + 67)) and ((2 + 1) == v168)) then
							if (((15686 - 11531) <= (1816 + 2416)) and v14:BuffUp(v64.BreathofSindragosa) and (not v64.Obliteration:IsAvailable() or (v64.Obliteration:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff)))) then
								local v170 = 0 + 0;
								local v171;
								while true do
									if ((v170 == (1427 - (85 + 1341))) or ((6110 - 2529) == (9808 - 6335))) then
										if (((5367 - (45 + 327)) > (6317 - 2969)) and v29(v64.Pool)) then
											return "pool for Breath()";
										end
										break;
									end
									if ((v170 == (502 - (444 + 58))) or ((328 + 426) > (641 + 3083))) then
										v171 = v116();
										if (((107 + 110) >= (165 - 108)) and v171) then
											return v171;
										end
										v170 = 1733 - (64 + 1668);
									end
								end
							end
							if ((v64.Obliteration:IsAvailable() and v14:BuffUp(v64.PillarofFrostBuff) and v14:BuffDown(v64.BreathofSindragosa)) or ((4043 - (1227 + 746)) >= (12408 - 8371))) then
								local v172 = v121();
								if (((5020 - 2315) == (3199 - (415 + 79))) and v172) then
									return v172;
								end
								if (((2 + 59) == (552 - (142 + 349))) and v29(v64.Pool)) then
									return "pool for Obliteration()";
								end
							end
							if (((v94 >= (1 + 1)) and v27) or ((960 - 261) >= (645 + 651))) then
								local v173 = v115();
								if (v173 or ((1257 + 526) >= (9847 - 6231))) then
									return v173;
								end
							end
							v168 = 1868 - (1710 + 154);
						end
						if (((319 - (200 + 118)) == v168) or ((1551 + 2362) > (7914 - 3387))) then
							v169 = v120();
							if (((6490 - 2114) > (726 + 91)) and v169) then
								return v169;
							end
							if (((4809 + 52) > (443 + 381)) and v28) then
								local v174 = 0 + 0;
								local v175;
								while true do
									if ((v174 == (0 - 0)) or ((2633 - (363 + 887)) >= (3720 - 1589))) then
										v175 = v119();
										if (v175 or ((8929 - 7053) >= (393 + 2148))) then
											return v175;
										end
										break;
									end
								end
							end
							v168 = 4 - 2;
						end
						if (((1218 + 564) <= (5436 - (674 + 990))) and (v168 == (0 + 0))) then
							if (not v14:AffectingCombat() or ((1924 + 2776) < (1287 - 474))) then
								local v176 = 1055 - (507 + 548);
								local v177;
								while true do
									if (((4036 - (289 + 548)) < (5868 - (821 + 997))) and (v176 == (255 - (195 + 60)))) then
										v177 = v113();
										if (v177 or ((1332 + 3619) < (5931 - (251 + 1250)))) then
											return v177;
										end
										break;
									end
								end
							end
							if (((281 - 185) == (66 + 30)) and v64.DeathStrike:IsReady() and not v69) then
								if (v29(v64.DeathStrike, nil, nil, not v15:IsInMeleeRange(1037 - (809 + 223))) or ((3996 - 1257) > (12036 - 8028))) then
									return "death_strike low hp or proc";
								end
							end
							v124();
							v168 = 3 - 2;
						end
						if ((v168 == (2 + 0)) or ((13 + 10) == (1751 - (14 + 603)))) then
							if (v28 or ((2822 - (118 + 11)) >= (666 + 3445))) then
								local v178 = 0 + 0;
								local v179;
								while true do
									if ((v178 == (0 - 0)) or ((5265 - (551 + 398)) <= (1357 + 789))) then
										v179 = v122();
										if (v179 or ((1262 + 2284) <= (2283 + 526))) then
											return v179;
										end
										v178 = 3 - 2;
									end
									if (((11299 - 6395) > (703 + 1463)) and (v178 == (3 - 2))) then
										v179 = v114();
										if (((31 + 78) >= (179 - (40 + 49))) and v179) then
											return v179;
										end
										break;
									end
								end
							end
							if (((18956 - 13978) > (3395 - (99 + 391))) and v64.ColdHeart:IsAvailable() and (v14:BuffDown(v64.KillingMachineBuff) or v64.BreathofSindragosa:IsAvailable()) and ((v15:DebuffStack(v64.RazoriceDebuff) == (5 + 0)) or (not v70 and not v64.GlacialAdvance:IsAvailable() and not v64.Avalanche:IsAvailable()) or (v90 <= (v14:GCD() + (0.5 - 0))))) then
								local v180 = 0 - 0;
								local v181;
								while true do
									if ((v180 == (0 + 0)) or ((7962 - 4936) <= (3884 - (1032 + 572)))) then
										v181 = v118();
										if (v181 or ((2070 - (203 + 214)) <= (2925 - (568 + 1249)))) then
											return v181;
										end
										break;
									end
								end
							end
							if (((2276 + 633) > (6265 - 3656)) and v14:BuffUp(v64.BreathofSindragosa) and v64.Obliteration:IsAvailable() and v14:BuffUp(v64.PillarofFrostBuff)) then
								local v182 = 0 - 0;
								local v183;
								while true do
									if (((2063 - (913 + 393)) > (547 - 353)) and ((0 - 0) == v182)) then
										v183 = v117();
										if (v183 or ((441 - (269 + 141)) >= (3109 - 1711))) then
											return v183;
										end
										v182 = 1982 - (362 + 1619);
									end
									if (((4821 - (950 + 675)) <= (1879 + 2993)) and ((1180 - (216 + 963)) == v182)) then
										if (((4613 - (485 + 802)) == (3885 - (432 + 127))) and v29(v64.Pool)) then
											return "pool for BreathOblit()";
										end
										break;
									end
								end
							end
							v168 = 1076 - (1065 + 8);
						end
						if (((796 + 637) <= (5479 - (635 + 966))) and (v168 == (3 + 1))) then
							if ((v94 == (43 - (5 + 37))) or not v27 or ((3936 - 2353) == (722 + 1013))) then
								local v184 = 0 - 0;
								local v185;
								while true do
									if ((v184 == (0 + 0)) or ((6194 - 3213) == (8909 - 6559))) then
										v185 = v123();
										if (v185 or ((8422 - 3956) <= (1178 - 685))) then
											return v185;
										end
										break;
									end
								end
							end
							if (v10.CastAnnotated(v64.Pool, false, "WAIT") or ((1832 + 715) <= (2516 - (318 + 211)))) then
								return "Wait/Pool Resources";
							end
							break;
						end
					end
				end
				break;
			end
			if (((14569 - 11608) > (4327 - (963 + 624))) and (v142 == (1 + 1))) then
				v69 = not v110();
				if (((4542 - (518 + 328)) >= (8419 - 4807)) and v27) then
					v92 = v14:GetEnemiesInMeleeRange(12 - 4);
					v97 = v14:GetEnemiesInMeleeRange(327 - (301 + 16));
					v94 = #v97;
					v93 = #v92;
				else
					v92 = {};
					v97 = {};
					v94 = 2 - 1;
					v93 = 2 - 1;
				end
				v142 = 7 - 4;
			end
		end
	end
	local function v126()
		local v143 = 0 + 0;
		while true do
			if ((v143 == (0 + 0)) or ((6340 - 3370) == (1130 + 748))) then
				v63();
				v10.Print("Frost DK rotation by Epic. Work in progress Gojira");
				break;
			end
		end
	end
	v10.SetAPL(24 + 227, v125, v126);
end;
return v0["Epix_DeathKnight_FrostDK.lua"]();

