local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 648 - (166 + 482);
	local v6;
	while true do
		if (((124 + 2116) > (1523 - (630 + 793))) and (v5 == (3 - 2))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((1436 + 2208) >= (16058 - 11394))) then
			v6 = v0[v4];
			if (not v6 or ((3116 - (760 + 987)) == (6640 - (1789 + 124)))) then
				return v1(v4, ...);
			end
			v5 = 767 - (745 + 21);
		end
	end
end
v0["Epix_DeathKnight_DeathKnight.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.Pet;
	local v16 = v10.Spell;
	local v17 = v10.MultiSpell;
	local v18 = v10.Item;
	local v19 = v10.Utils.MergeTableByKey;
	local v20 = EpicLib;
	local v21 = v20.Macro;
	if (not v16.DeathKnight or ((297 + 566) == (9512 - 6055))) then
		v16.DeathKnight = {};
	end
	v16.DeathKnight.Commons = {CleavingStrikes=v16(1243107 - 926191, nil, 1 + 8),DeathStrike=v16(39255 + 10743, nil, 1065 - (87 + 968)),EmpowerRuneWeapon=v16(209391 - 161823, nil, 10 + 1),IceboundFortitude=v16(110296 - 61504, nil, 1425 - (447 + 966)),IcyTalons=v16(533508 - 338630, nil, 1830 - (1703 + 114)),RaiseDead=v16(47286 - (376 + 325), nil, 22 - 8),RunicAttenuation=v16(637254 - 430150, nil, 5 + 10),SacrificialPact=v16(721476 - 393902, nil, 30 - (9 + 5)),SoulReaper=v16(343670 - (85 + 291), nil, 1282 - (243 + 1022)),UnholyGround=v16(1424145 - 1049880, nil, 15 + 3),AbominationLimbBuff=v16(384449 - (1123 + 57), nil, 16 + 3),DeathAndDecayBuff=v16(188544 - (163 + 91), nil, 1950 - (1869 + 61)),DeathsDueBuff=v16(90563 + 233602, nil, 73 - 52),EmpowerRuneWeaponBuff=v16(73062 - 25494, nil, 4 + 18),IcyTalonsBuff=v16(267811 - 72932, nil, 22 + 1),UnholyStrengthBuff=v16(54839 - (1329 + 145), nil, 995 - (140 + 831)),DeathStrikeBuff=v16(103418 - (1409 + 441), nil, 743 - (15 + 703)),BloodPlagueDebuff=v16(25507 + 29571, nil, 464 - (262 + 176)),FrostFeverDebuff=v16(56816 - (345 + 1376), nil, 715 - (198 + 490)),SoulReaperDebuff=v16(1516659 - 1173365, nil, 66 - 38),VirulentPlagueDebuff=v16(192793 - (696 + 510), nil, 60 - 31),MarkofFyralathDebuff=v16(415794 - (1091 + 171)),AncestralCall=v16(44212 + 230526, nil, 3 - 2),ArcanePulse=v16(863453 - 603089, nil, 376 - (123 + 251)),ArcaneTorrent=v16(251493 - 200880, nil, 701 - (208 + 490)),BagofTricks=v16(26363 + 286048, nil, 2 + 2),Berserking=v16(27133 - (660 + 176), nil, 1 + 4),BloodFury=v16(20774 - (14 + 188), nil, 681 - (534 + 141)),Fireblood=v16(106624 + 158597, nil, 7 + 0),LightsJudgment=v16(245791 + 9856, nil, 16 - 8),DeathAndDecay=v16(68688 - 25423, nil, 84 - 54),DeathCoil=v16(25529 + 22012, nil, 20 + 11),AbominationLimb=v16(383665 - (115 + 281), nil, 74 - 42),AntiMagicShell=v16(40327 + 8380, nil, 79 - 46),AntiMagicZone=v16(187197 - 136145, nil, 901 - (550 + 317)),Asphyxiate=v16(320108 - 98546, nil, 49 - 14),Assimilation=v16(1046205 - 671822, nil, 321 - (134 + 151)),ChainsofIce=v16(47189 - (970 + 695), nil, 70 - 33),MindFreeze=v16(49518 - (582 + 1408), nil, 131 - 93),Pool=v16(1258108 - 258198, nil, 146 - 107)};
	v16.DeathKnight.Blood = v19(v16.DeathKnight.Commons, {BloodBoil=v16(52666 - (1195 + 629), nil, 52 - 12),BloodTap=v16(221940 - (187 + 54), nil, 821 - (162 + 618)),Blooddrinker=v16(144996 + 61935, nil, 28 + 14),Bonestorm=v16(415543 - 220699, nil, 72 - 29),Coagulopathy=v16(30610 + 360867, nil, 1680 - (1373 + 263)),Consumption=v16(275156 - (451 + 549), nil, 15 + 30),DancingRuneWeapon=v16(76299 - 27271, nil, 76 - 30),DeathsCaress=v16(196676 - (746 + 638), nil, 18 + 29),GorefiendsGrasp=v16(164276 - 56077, nil, 389 - (218 + 123)),HeartStrike=v16(208511 - (1535 + 46), nil, 49 + 0),Heartbreaker=v16(32057 + 189479, nil, 610 - (306 + 254)),InsatiableBlade=v16(23379 + 354258, nil, 99 - 48),Marrowrend=v16(196649 - (899 + 568), nil, 35 + 17),RapidDecomposition=v16(471063 - 276401, nil, 656 - (268 + 335)),RelishinBlood=v16(317900 - (60 + 230), nil, 626 - (426 + 146)),RuneTap=v16(23322 + 171357, nil, 1511 - (282 + 1174)),SanguineGround=v16(392269 - (569 + 242), nil, 161 - 105),ShatteringBone=v16(21596 + 356044, nil, 1081 - (706 + 318)),TighteningGrasp=v16(208221 - (721 + 530), nil, 1329 - (945 + 326)),Tombstone=v16(549152 - 329343, nil, 53 + 6),VampiricBlood=v16(55933 - (271 + 429), nil, 56 + 4),BoneShieldBuff=v16(196681 - (1408 + 92), nil, 1147 - (461 + 625)),CoagulopathyBuff=v16(392769 - (993 + 295), nil, 4 + 58),CrimsonScourgeBuff=v16(82312 - (418 + 753), nil, 24 + 39),DancingRuneWeaponBuff=v16(8375 + 72881, nil, 19 + 45),HemostasisBuff=v16(69234 + 204713, nil, 594 - (406 + 123)),IceboundFortitudeBuff=v16(50561 - (1749 + 20), nil, 16 + 50),RuneTapBuff=v16(196001 - (1249 + 73), nil, 24 + 43),VampiricBloodBuff=v16(56378 - (466 + 679), nil, 163 - 95),VampiricStrengthBuff=v16(1167974 - 759618, nil, 1969 - (106 + 1794))});
	v16.DeathKnight.Frost = v19(v16.DeathKnight.Commons, {FrostStrike=v16(15547 + 33596, nil, 18 + 52),HowlingBlast=v16(145210 - 96026, nil, 192 - 121),Avalanche=v16(207256 - (4 + 110), nil, 656 - (57 + 527)),BitingCold=v16(378483 - (41 + 1386), nil, 176 - (17 + 86)),BreathofSindragosa=v16(103353 + 48926, nil, 164 - 90),ChillStreak=v16(884398 - 579006, nil, 241 - (122 + 44)),ColdHeart=v16(485739 - 204531, nil, 251 - 175),Everfrost=v16(306634 + 70304, nil, 12 + 65),FatalFixation=v16(820808 - 415642, nil, 143 - (30 + 35)),Frostscythe=v16(142432 + 64798, nil, 1336 - (1043 + 214)),FrostwyrmsFury=v16(1055944 - 776642, nil, 1292 - (323 + 889)),GatheringStorm=v16(524633 - 329721, nil, 661 - (361 + 219)),GlacialAdvance=v16(195233 - (53 + 267), nil, 19 + 63),HornofWinter=v16(57743 - (15 + 398), nil, 1065 - (18 + 964)),Icebreaker=v16(1479110 - 1086160, nil, 49 + 35),Icecap=v16(130497 + 76629, nil, 935 - (20 + 830)),ImprovedObliterate=v16(247602 + 69596, nil, 212 - (116 + 10)),MightoftheFrozenWastes=v16(6008 + 75325, nil, 825 - (542 + 196)),Obliterate=v16(105084 - 56064, nil, 26 + 62),Obliteration=v16(142888 + 138350, nil, 33 + 56),PillarofFrost=v16(135103 - 83832, nil, 230 - 140),RageoftheFrozenChampion=v16(378627 - (1126 + 425), nil, 496 - (118 + 287)),RemorselessWinter=v16(771199 - 574429, nil, 1213 - (118 + 1003)),ShatteringBlade=v16(605938 - 398881, nil, 470 - (142 + 235)),UnleashedFrenzy=v16(1709836 - 1332931, nil, 21 + 73),ColdHeartBuff=v16(282186 - (553 + 424), nil, 179 - 84),GatheringStormBuff=v16(186583 + 25222, nil, 96 + 0),KillingMachineBuff=v16(29768 + 21356, nil, 42 + 55),PillarofFrostBuff=v16(29280 + 21991, nil, 212 - 114),RimeBuff=v16(164537 - 105485, nil, 221 - 122),UnleashedFrenzyBuff=v16(109602 + 267305, nil),RazoriceDebuff=v16(249916 - 198202, nil, 854 - (239 + 514))});
	v16.DeathKnight.Unholy = v19(v16.DeathKnight.Commons, {Apocalypse=v16(96829 + 178870, nil, 1431 - (797 + 532)),ArmyoftheDamned=v16(201155 + 75682, nil, 35 + 68),ArmyoftheDead=v16(100281 - 57631, nil, 1306 - (373 + 829)),BurstingSores=v16(207995 - (476 + 255), nil, 1235 - (369 + 761)),ClawingShadows=v16(119924 + 87387, nil, 192 - 86),CoilofDevastation=v16(739563 - 349293, nil, 345 - (64 + 174)),CommanderoftheDead=v16(55582 + 334677, nil, 159 - 51),DarkTransformation=v16(63896 - (144 + 192), nil, 325 - (42 + 174)),Defile=v16(114398 + 37882, nil, 92 + 18),EbonFever=v16(88057 + 119212, nil, 1615 - (363 + 1141)),Epidemic=v16(208897 - (1183 + 397), nil, 340 - 228),EternalAgony=v16(286085 + 104183, nil, 85 + 28),FesteringStrike=v16(87923 - (1913 + 62), nil, 72 + 42),Festermight=v16(999595 - 622005, nil, 2048 - (565 + 1368)),GhoulishFrenzy=v16(1420004 - 1042417, nil, 1777 - (1477 + 184)),ImprovedDeathCoil=v16(514484 - 136904, nil, 110 + 7),InfectedClaws=v16(208128 - (564 + 292), nil, 203 - 85),Morbidity=v16(1138125 - 760533, nil, 423 - (244 + 60)),Outbreak=v16(59649 + 17926, nil, 596 - (41 + 435)),Pestilence=v16(278235 - (938 + 63), nil, 94 + 27),Plaguebringer=v16(391300 - (936 + 189), nil, 41 + 81),RaiseDead=v16(48197 - (1565 + 48), nil, 76 + 47),RottenTouch=v16(391413 - (782 + 356), nil, 391 - (176 + 91)),ScourgeStrike=v16(143527 - 88437, nil, 184 - 59),SummonGargoyle=v17(1293 - (975 + 117), 51081 - (157 + 1718), 168275 + 39074),Superstrain=v16(1385475 - 995192, nil, 430 - 304),UnholyAssault=v16(208307 - (697 + 321), nil, 345 - 218),UnholyBlight=v16(245735 - 129746, nil, 294 - 166),UnholyCommand=v16(123368 + 193573, nil, 241 - 112),UnholyPact=v16(855763 - 536533, nil, 1357 - (322 + 905)),VileContagion=v16(390890 - (602 + 9), nil, 1320 - (449 + 740)),CommanderoftheDeadBuff=v16(391132 - (826 + 46), nil, 1079 - (245 + 702)),FestermightBuff=v16(1193172 - 815581, nil, 43 + 90),PlaguebringerBuff=v16(392076 - (260 + 1638), nil, 574 - (382 + 58)),RunicCorruptionBuff=v16(165087 - 113627, nil, 113 + 22),SuddenDoomBuff=v16(168105 - 86765, nil, 403 - 267),UnholyAssaultBuff=v16(208494 - (902 + 303), nil, 300 - 163),DeathRotDebuff=v16(909306 - 531766, nil, 12 + 126),FesteringWoundDebuff=v16(196000 - (1121 + 569), nil, 353 - (22 + 192)),RottenTouchDebuff=v16(390959 - (483 + 200), nil, 1603 - (1404 + 59)),UnholyBlightDebuff=v16(317445 - 201451, nil, 189 - 48)});
	if (not v18.DeathKnight or ((1193 - (468 + 297)) > (1130 - (334 + 228)))) then
		v18.DeathKnight = {};
	end
	v18.DeathKnight.Commons = {AlgetharPuzzleBox=v18(653350 - 459649, {(23 - 10),(250 - (141 + 95))}),IrideusFragment=v18(190316 + 3427, {(30 - 17),(38 - 24)}),VialofAnimatedBlood=v18(112215 + 47410, {(18 - 5),(177 - (92 + 71))}),Fyralath=v18(101974 + 104474, {(778 - (574 + 191)),(34 - 20)}),RefreshingHealingPotion=v18(97755 + 93625),DreamwalkersHealingPotion=v18(207872 - (254 + 595)),Healthstone=v18(5638 - (55 + 71))};
	v18.DeathKnight.Blood = v19(v18.DeathKnight.Commons, {});
	v18.DeathKnight.Frost = v19(v18.DeathKnight.Commons, {});
	v18.DeathKnight.Unholy = v19(v18.DeathKnight.Commons, {});
	if (((1757 - 423) <= (6403 - (573 + 1217))) and not v21.DeathKnight) then
		v21.DeathKnight = {};
	end
	v21.DeathKnight.Commons = {Healthstone=v21(58 - 37),DaDCursor=v21(1 + 8),DaDPlayer=v21(16 - 6),DefileCursor=v21(950 - (714 + 225)),DefilePlayer=v21(34 - 22)};
	v21.DeathKnight.Blood = v19(v21.DeathKnight.Commons, {});
	v21.DeathKnight.Unholy = v19(v21.DeathKnight.Commons, {});
	v21.DeathKnight.Frost = v19(v21.DeathKnight.Commons, {});
	local v34 = {(4618 + 38032),(55896 - (118 + 688)),(40154 + 167157),(145841 - 102576),(293962 - 141682),(189218 - 111643),(292848 - 176859),(47320 - (503 + 1293)),(2686 + 1028),(238239 + 105055),(100668 + 11005)};
	v10.GhoulTable = {SummonedGhoul=nil,SummonExpiration=nil,SummonedGargoyle=nil,GargoyleExpiration=nil,ApocMagusExpiration=(533 - (43 + 490)),ArmyMagusExpiration=(733 - (711 + 22))};
	v10:RegisterForSelfCombatEvent(function(v44, v44, v44, v44, v44, v44, v44, v45, v44, v44, v44, v46)
		local v47 = 0 - 0;
		while true do
			if ((v47 == (859 - (240 + 619))) or ((451 + 1414) >= (3226 - 1197))) then
				if (((328 + 4622) >= (3360 - (1344 + 400))) and (v46 == (46990 - (255 + 150)))) then
					v10.GhoulTable.SummonedGhoul = v45;
					v10.GhoulTable.SummonExpiration = GetTime() + 48 + 12;
				end
				if (((924 + 801) == (7370 - 5645)) and ((v46 == (158931 - 109725)) or (v46 == (209088 - (404 + 1335))))) then
					local v72 = 406 - (183 + 223);
					while true do
						if (((1774 - 315) <= (1645 + 837)) and (v72 == (0 + 0))) then
							v10.GhoulTable.SummonedGargoyle = v45;
							v10.GhoulTable.GargoyleExpiration = GetTime() + (362 - (10 + 327));
							break;
						end
					end
				end
				break;
			end
		end
	end, "SPELL_SUMMON");
	v10:RegisterForSelfCombatEvent(function(v48, v48, v48, v48, v48, v48, v48, v48, v48, v48, v48, v49)
		if ((v49 == (228119 + 99455)) or ((3034 - (118 + 220)) >= (1511 + 3021))) then
			local v66 = 449 - (108 + 341);
			while true do
				if (((471 + 577) >= (219 - 167)) and (v66 == (1493 - (711 + 782)))) then
					v10.GhoulTable.SummonedGhoul = nil;
					v10.GhoulTable.SummonExpiration = nil;
					break;
				end
			end
		end
		if (((5670 - 2712) < (4972 - (270 + 199))) and v13:HasTier(11 + 20, 1823 - (580 + 1239)) and ((v10.GhoulTable.ApocMagusExpiration > (0 - 0)) or (v10.GhoulTable.ArmyMagusExpiration > (0 + 0)))) then
			local v67 = 0 + 0;
			while true do
				if ((v67 == (0 + 0)) or ((7141 - 4406) == (814 + 495))) then
					if ((v49 == (87115 - (645 + 522))) or ((5920 - (1010 + 780)) <= (2954 + 1))) then
						local v79 = 0 - 0;
						while true do
							if ((v79 == (0 - 0)) or ((3800 - (1045 + 791)) <= (3391 - 2051))) then
								if (((3815 - 1316) == (3004 - (351 + 154))) and v10.GhoulTable:ApocMagusActive()) then
									v10.GhoulTable.ApocMagusExpiration = v10.GhoulTable.ApocMagusExpiration + (1575 - (1281 + 293));
								end
								if (v10.GhoulTable:ArmyMagusActive() or ((2521 - (28 + 238)) < (48 - 26))) then
									v10.GhoulTable.ArmyMagusExpiration = v10.GhoulTable.ArmyMagusExpiration + (1560 - (1381 + 178));
								end
								break;
							end
						end
					end
					for v77, v78 in pairs(v34) do
						if ((v78 == v49) or ((1019 + 67) >= (1133 + 272))) then
							local v82 = 0 + 0;
							while true do
								if ((v82 == (0 - 0)) or ((1228 + 1141) == (896 - (381 + 89)))) then
									if (v10.GhoulTable:ApocMagusActive() or ((2728 + 348) > (2153 + 1030))) then
										v10.GhoulTable.ApocMagusExpiration = v10.GhoulTable.ApocMagusExpiration + (0.5 - 0);
									end
									if (((2358 - (1074 + 82)) > (2318 - 1260)) and v10.GhoulTable:ArmyMagusActive()) then
										v10.GhoulTable.ArmyMagusExpiration = v10.GhoulTable.ArmyMagusExpiration + (1784.5 - (214 + 1570));
									end
									break;
								end
							end
						end
					end
					break;
				end
			end
		end
		if (((5166 - (990 + 465)) > (1384 + 1971)) and v13:HasTier(14 + 17, 2 + 0) and (v49 == (1085021 - 809322))) then
			v10.GhoulTable.ApocMagusExpiration = GetTime() + (1746 - (1668 + 58));
		end
		if ((v13:HasTier(657 - (512 + 114), 5 - 3) and (v49 == (88172 - 45522))) or ((3152 - 2246) >= (1037 + 1192))) then
			v10.GhoulTable.ArmyMagusExpiration = GetTime() + 6 + 24;
		end
	end, "SPELL_CAST_SUCCESS");
	v10:RegisterForCombatEvent(function(v50, v50, v50, v50, v50, v50, v50, v51)
		local v52 = 0 + 0;
		while true do
			if (((4344 - 3056) > (3245 - (109 + 1885))) and (v52 == (1469 - (1269 + 200)))) then
				if ((v51 == v10.GhoulTable.SummonedGhoul) or ((8649 - 4136) < (4167 - (98 + 717)))) then
					local v75 = 826 - (802 + 24);
					while true do
						if ((v75 == (0 - 0)) or ((2608 - 543) >= (472 + 2724))) then
							v10.GhoulTable.SummonedGhoul = nil;
							v10.GhoulTable.SummonExpiration = nil;
							break;
						end
					end
				end
				if ((v51 == v10.GhoulTable.SummonedGargoyle) or ((3363 + 1013) <= (244 + 1237))) then
					local v76 = 0 + 0;
					while true do
						if ((v76 == (0 - 0)) or ((11311 - 7919) >= (1696 + 3045))) then
							v10.GhoulTable.SummonedGargoyle = nil;
							v10.GhoulTable.GargoyleExpiration = nil;
							break;
						end
					end
				end
				break;
			end
		end
	end, "UNIT_DESTROYED");
	v10.GhoulTable.GhoulRemains = function(v53)
		local v54 = 0 + 0;
		while true do
			if (((2743 + 582) >= (1567 + 587)) and (v54 == (0 + 0))) then
				if ((v10.GhoulTable.SummonExpiration == nil) or ((2728 - (797 + 636)) >= (15697 - 12464))) then
					return 1619 - (1427 + 192);
				end
				return v10.GhoulTable.SummonExpiration - GetTime();
			end
		end
	end;
	v10.GhoulTable.GhoulActive = function(v55)
		return (v10.GhoulTable.SummonedGhoul ~= nil) and (v10.GhoulTable:GhoulRemains() > (0 + 0));
	end;
	v10.GhoulTable.GargRemains = function(v56)
		if (((10162 - 5785) > (1476 + 166)) and (v10.GhoulTable.GargoyleExpiration == nil)) then
			return 0 + 0;
		end
		return v10.GhoulTable.GargoyleExpiration - GetTime();
	end;
	v10.GhoulTable.GargActive = function(v57)
		return (v10.GhoulTable.SummonedGargoyle ~= nil) and (v10.GhoulTable:GargRemains() > (326 - (192 + 134)));
	end;
	v10.GhoulTable.ArmyMagusRemains = function(v58)
		return v10.GhoulTable.ArmyMagusExpiration - GetTime();
	end;
	v10.GhoulTable.ArmyMagusActive = function(v59)
		return v10.GhoulTable:ArmyMagusRemains() > (1276 - (316 + 960));
	end;
	v10.GhoulTable.ApocMagusRemains = function(v60)
		return v10.GhoulTable.ApocMagusExpiration - GetTime();
	end;
	v10.GhoulTable.ApocMagusActive = function(v61)
		return v10.GhoulTable.ApocMagusRemains() > (0 + 0);
	end;
end;
return v0["Epix_DeathKnight_DeathKnight.lua"]();

