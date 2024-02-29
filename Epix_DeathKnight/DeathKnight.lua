local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1747 - (760 + 987))) or ((2341 - (1789 + 124)) > (1334 - (745 + 21)))) then
			v6 = v0[v4];
			if (((459 + 875) <= (12692 - 8079)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
		end
		if ((v5 == (1 + 0)) or ((1465 + 400) >= (3084 - (87 + 968)))) then
			return v6(...);
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
	if (((21789 - 16839) >= (1467 + 149)) and not v16.DeathKnight) then
		v16.DeathKnight = {};
	end
	v16.DeathKnight.Commons = {CleavingStrikes=v16(716404 - 399488, nil, 1422 - (447 + 966)),DeathStrike=v16(136877 - 86879, nil, 1827 - (1703 + 114)),EmpowerRuneWeapon=v16(48269 - (376 + 325), nil, 17 - 6),IceboundFortitude=v16(150131 - 101339, nil, 4 + 8),IcyTalons=v16(429215 - 234337, nil, 27 - (9 + 5)),RaiseDead=v16(46961 - (85 + 291), nil, 1279 - (243 + 1022)),RunicAttenuation=v16(788067 - 580963, nil, 13 + 2),SacrificialPact=v16(328754 - (1123 + 57), nil, 14 + 2),SoulReaper=v16(343548 - (163 + 91), nil, 1947 - (1869 + 61)),UnholyGround=v16(104560 + 269705, nil, 63 - 45),AbominationLimbBuff=v16(588682 - 205413, nil, 3 + 16),DeathAndDecayBuff=v16(258757 - 70467, nil, 19 + 1),DeathsDueBuff=v16(325639 - (1329 + 145), nil, 992 - (140 + 831)),EmpowerRuneWeaponBuff=v16(49418 - (1409 + 441), nil, 740 - (15 + 703)),IcyTalonsBuff=v16(90250 + 104629, nil, 461 - (262 + 176)),UnholyStrengthBuff=v16(55086 - (345 + 1376), nil, 712 - (198 + 490)),DeathStrikeBuff=v16(448723 - 347155, nil, 59 - 34),BloodPlagueDebuff=v16(56284 - (696 + 510), nil, 54 - 28),FrostFeverDebuff=v16(56357 - (1091 + 171), nil, 5 + 22),SoulReaperDebuff=v16(1080806 - 737512, nil, 92 - 64),VirulentPlagueDebuff=v16(191961 - (123 + 251), nil, 144 - 115),MarkofFyralathDebuff=v16(415230 - (208 + 490)),AncestralCall=v16(23184 + 251554, nil, 1 + 0),ArcanePulse=v16(261200 - (660 + 176), nil, 1 + 1),ArcaneTorrent=v16(50815 - (14 + 188), nil, 678 - (534 + 141)),BagofTricks=v16(125595 + 186816, nil, 4 + 0),Berserking=v16(25284 + 1013, nil, 10 - 5),BloodFury=v16(32659 - 12087, nil, 16 - 10),Fireblood=v16(142417 + 122804, nil, 5 + 2),LightsJudgment=v16(256043 - (115 + 281), nil, 18 - 10),DeathAndDecay=v16(35821 + 7444, nil, 72 - 42),DeathCoil=v16(174323 - 126782, nil, 898 - (550 + 317)),AbominationLimb=v16(553739 - 170470, nil, 44 - 12),AntiMagicShell=v16(136110 - 87403, nil, 318 - (134 + 151)),AntiMagicZone=v16(52717 - (970 + 695), nil, 64 - 30),Asphyxiate=v16(223552 - (582 + 1408), nil, 121 - 86),Assimilation=v16(471056 - 96673, nil, 135 - 99),ChainsofIce=v16(47348 - (1195 + 629), nil, 48 - 11),MindFreeze=v16(47769 - (187 + 54), nil, 818 - (162 + 618)),Pool=v16(700635 + 299275, nil, 26 + 13)};
	v16.DeathKnight.Blood = v19(v16.DeathKnight.Commons, {BloodBoil=v16(108430 - 57588, nil, 67 - 27),BloodTap=v16(17335 + 204364, nil, 1677 - (1373 + 263)),Blooddrinker=v16(207931 - (451 + 549), nil, 14 + 28),Bonestorm=v16(303225 - 108381, nil, 72 - 29),Coagulopathy=v16(392861 - (746 + 638), nil, 17 + 27),Consumption=v16(416246 - 142090, nil, 386 - (218 + 123)),DancingRuneWeapon=v16(50609 - (1535 + 46), nil, 46 + 0),DeathsCaress=v16(28260 + 167032, nil, 607 - (306 + 254)),GorefiendsGrasp=v16(6699 + 101500, nil, 93 - 45),HeartStrike=v16(208397 - (899 + 568), nil, 33 + 16),Heartbreaker=v16(536095 - 314559, nil, 653 - (268 + 335)),InsatiableBlade=v16(377927 - (60 + 230), nil, 623 - (426 + 146)),Marrowrend=v16(23382 + 171800, nil, 1508 - (282 + 1174)),RapidDecomposition=v16(195473 - (569 + 242), nil, 152 - 99),RelishinBlood=v16(18163 + 299447, nil, 1078 - (706 + 318)),RuneTap=v16(195930 - (721 + 530), nil, 1326 - (945 + 326)),SanguineGround=v16(977986 - 586528, nil, 50 + 6),ShatteringBone=v16(378340 - (271 + 429), nil, 53 + 4),TighteningGrasp=v16(208470 - (1408 + 92), nil, 1144 - (461 + 625)),Tombstone=v16(221097 - (993 + 295), nil, 4 + 55),VampiricBlood=v16(56404 - (418 + 753), nil, 23 + 37),BoneShieldBuff=v16(20116 + 175065, nil, 18 + 43),CoagulopathyBuff=v16(98938 + 292543, nil, 591 - (406 + 123)),CrimsonScourgeBuff=v16(82910 - (1749 + 20), nil, 15 + 48),DancingRuneWeaponBuff=v16(82578 - (1249 + 73), nil, 23 + 41),HemostasisBuff=v16(275092 - (466 + 679), nil, 156 - 91),IceboundFortitudeBuff=v16(139554 - 90762, nil, 1966 - (106 + 1794)),RuneTapBuff=v16(61588 + 133091, nil, 17 + 50),VampiricBloodBuff=v16(163069 - 107836, nil, 183 - 115),VampiricStrengthBuff=v16(408470 - (4 + 110), nil, 653 - (57 + 527))});
	v16.DeathKnight.Frost = v19(v16.DeathKnight.Commons, {FrostStrike=v16(50570 - (41 + 1386), nil, 173 - (17 + 86)),HowlingBlast=v16(33382 + 15802, nil, 158 - 87),Avalanche=v16(599871 - 392729, nil, 238 - (122 + 44)),BitingCold=v16(651301 - 274245, nil, 242 - 169),BreathofSindragosa=v16(123877 + 28402, nil, 11 + 63),ChillStreak=v16(618679 - 313287, nil, 140 - (30 + 35)),ColdHeart=v16(193278 + 87930, nil, 1333 - (1043 + 214)),Everfrost=v16(1425073 - 1048135, nil, 1289 - (323 + 889)),FatalFixation=v16(1090561 - 685395, nil, 658 - (361 + 219)),Frostscythe=v16(207550 - (53 + 267), nil, 18 + 61),FrostwyrmsFury=v16(279715 - (15 + 398), nil, 1062 - (18 + 964)),GatheringStorm=v16(733671 - 538759, nil, 47 + 34),GlacialAdvance=v16(122803 + 72110, nil, 932 - (20 + 830)),HornofWinter=v16(44752 + 12578, nil, 209 - (116 + 10)),Icebreaker=v16(29026 + 363924, nil, 822 - (542 + 196)),Icecap=v16(444017 - 236891, nil, 25 + 60),ImprovedObliterate=v16(161159 + 156039, nil, 31 + 55),MightoftheFrozenWastes=v16(214319 - 132986, nil, 222 - 135),Obliterate=v16(50571 - (1126 + 425), nil, 493 - (118 + 287)),Obliteration=v16(1102253 - 821015, nil, 1210 - (118 + 1003)),PillarofFrost=v16(150041 - 98770, nil, 467 - (142 + 235)),RageoftheFrozenChampion=v16(1710612 - 1333536, nil, 20 + 71),RemorselessWinter=v16(197747 - (553 + 424), nil, 173 - 81),ShatteringBlade=v16(182400 + 24657, nil, 93 + 0),UnleashedFrenzy=v16(219455 + 157450, nil, 40 + 54),ColdHeartBuff=v16(160590 + 120619, nil, 205 - 110),GatheringStormBuff=v16(590155 - 378350, nil, 214 - 118),KillingMachineBuff=v16(14867 + 36257, nil, 468 - 371),PillarofFrostBuff=v16(52024 - (239 + 514), nil, 35 + 63),RimeBuff=v16(60381 - (797 + 532), nil, 72 + 27),UnleashedFrenzyBuff=v16(127151 + 249756, nil),RazoriceDebuff=v16(121592 - 69878, nil, 1303 - (373 + 829))});
	v16.DeathKnight.Unholy = v19(v16.DeathKnight.Commons, {Apocalypse=v16(276430 - (476 + 255), nil, 1232 - (369 + 761)),ArmyoftheDamned=v16(160143 + 116694, nil, 186 - 83),ArmyoftheDead=v16(80821 - 38171, nil, 342 - (64 + 174)),BurstingSores=v16(29520 + 177744, nil, 155 - 50),ClawingShadows=v16(207647 - (144 + 192), nil, 322 - (42 + 174)),CoilofDevastation=v16(293184 + 97086, nil, 89 + 18),CommanderoftheDead=v16(165799 + 224460, nil, 1612 - (363 + 1141)),DarkTransformation=v16(65140 - (1183 + 397), nil, 331 - 222),Defile=v16(111629 + 40651, nil, 83 + 27),EbonFever=v16(209244 - (1913 + 62), nil, 70 + 41),Epidemic=v16(548830 - 341513, nil, 2045 - (565 + 1368)),EternalAgony=v16(1467694 - 1077426, nil, 1774 - (1477 + 184)),FesteringStrike=v16(117110 - 31162, nil, 107 + 7),Festermight=v16(378446 - (564 + 292), nil, 198 - 83),GhoulishFrenzy=v16(1138110 - 760523, nil, 420 - (244 + 60)),ImprovedDeathCoil=v16(290326 + 87254, nil, 593 - (41 + 435)),InfectedClaws=v16(208273 - (938 + 63), nil, 91 + 27),Morbidity=v16(378717 - (936 + 189), nil, 40 + 79),Outbreak=v16(79188 - (1565 + 48), nil, 75 + 45),Pestilence=v16(278372 - (782 + 356), nil, 388 - (176 + 91)),Plaguebringer=v16(1016534 - 626359, nil, 179 - 57),RaiseDead=v16(47676 - (975 + 117), nil, 1998 - (157 + 1718)),RottenTouch=v16(316730 + 73545, nil, 440 - 316),ScourgeStrike=v16(188342 - 133252, nil, 1143 - (697 + 321)),SummonGargoyle=v17(547 - 346, 104248 - 55042, 478018 - 270669),Superstrain=v16(151915 + 238368, nil, 235 - 109),UnholyAssault=v16(555681 - 348392, nil, 1354 - (322 + 905)),UnholyBlight=v16(116600 - (602 + 9), nil, 1317 - (449 + 740)),UnholyCommand=v16(317813 - (826 + 46), nil, 1076 - (245 + 702)),UnholyPact=v16(1008753 - 689523, nil, 42 + 88),VileContagion=v16(392177 - (260 + 1638), nil, 571 - (382 + 58)),CommanderoftheDeadBuff=v16(1251982 - 861722, nil, 110 + 22),FestermightBuff=v16(780367 - 402776, nil, 394 - 261),PlaguebringerBuff=v16(391383 - (902 + 303), nil, 294 - 160),RunicCorruptionBuff=v16(123941 - 72481, nil, 12 + 123),SuddenDoomBuff=v16(83030 - (1121 + 569), nil, 350 - (22 + 192)),UnholyAssaultBuff=v16(207972 - (483 + 200), nil, 1600 - (1404 + 59)),DeathRotDebuff=v16(1033228 - 655688, nil, 184 - 46),FesteringWoundDebuff=v16(195075 - (468 + 297), nil, 701 - (334 + 228)),RottenTouchDebuff=v16(1316396 - 926120, nil, 324 - 184),UnholyBlightDebuff=v16(210371 - 94377, nil, 41 + 100)});
	if (((1961 - (141 + 95)) == (1695 + 30)) and not v18.DeathKnight) then
		v18.DeathKnight = {};
	end
	v18.DeathKnight.Commons = {AlgetharPuzzleBox=v18(498587 - 304886, {(4 + 9),(10 + 4)}),IrideusFragment=v18(100887 + 92856, {(8 + 5),(7 + 7)}),VialofAnimatedBlood=v18(268377 - 108752, {(11 + 2),(8 + 6)}),Fyralath=v18(207297 - (254 + 595), {(16 - 3),(38 - 24)}),RefreshingHealingPotion=v18(14562 + 176818),DreamwalkersHealingPotion=v18(333596 - 126573),Healthstone=v18(6451 - (714 + 225))};
	v18.DeathKnight.Blood = v19(v18.DeathKnight.Commons, {});
	v18.DeathKnight.Frost = v19(v18.DeathKnight.Commons, {});
	v18.DeathKnight.Unholy = v19(v18.DeathKnight.Commons, {});
	if (((4263 - 2804) <= (3459 - 977)) and not v21.DeathKnight) then
		v21.DeathKnight = {};
	end
	v21.DeathKnight.Commons = {Healthstone=v21(3 + 18),DaDCursor=v21(12 - 3),DaDPlayer=v21(816 - (118 + 688)),DefileCursor=v21(59 - (25 + 23)),DefilePlayer=v21(3 + 9),MindFreezeMouseover=v21(1952 - (927 + 959))};
	v21.DeathKnight.Blood = v19(v21.DeathKnight.Commons, {});
	v21.DeathKnight.Unholy = v19(v21.DeathKnight.Commons, {});
	v21.DeathKnight.Frost = v19(v21.DeathKnight.Commons, {});
	local v34 = {(43382 - (16 + 716)),(55187 - (11 + 86)),(207596 - (175 + 110)),(213393 - 170128),(425288 - 273008),(78636 - (810 + 251)),(35598 + 80391),(46057 - (43 + 490)),(14366 - 10652),(82842 + 260452),(7391 + 104282)};
	v10.GhoulTable = {SummonedGhoul=nil,SummonExpiration=nil,SummonedGargoyle=nil,GargoyleExpiration=nil,ApocMagusExpiration=(1744 - (1344 + 400)),ArmyMagusExpiration=(405 - (255 + 150))};
	v10:RegisterForSelfCombatEvent(function(v44, v44, v44, v44, v44, v44, v44, v45, v44, v44, v44, v46)
		local v47 = 0 + 0;
		while true do
			if ((v47 == (0 + 0)) or ((11518 - 8822) >= (14637 - 10105))) then
				if (((2787 - (404 + 1335)) >= (458 - (183 + 223))) and (v46 == (56687 - 10102))) then
					local v73 = 0 + 0;
					while true do
						if (((1065 + 1893) < (4840 - (10 + 327))) and (v73 == (0 + 0))) then
							v10.GhoulTable.SummonedGhoul = v45;
							v10.GhoulTable.SummonExpiration = GetTime() + (398 - (118 + 220));
							break;
						end
					end
				end
				if ((v46 == (16399 + 32807)) or (v46 == (207798 - (108 + 341))) or ((1229 + 1506) == (5534 - 4225))) then
					v10.GhoulTable.SummonedGargoyle = v45;
					v10.GhoulTable.GargoyleExpiration = GetTime() + (1518 - (711 + 782));
				end
				break;
			end
		end
	end, "SPELL_SUMMON");
	v10:RegisterForSelfCombatEvent(function(v48, v48, v48, v48, v48, v48, v48, v48, v48, v48, v48, v49)
		if ((v49 == (627969 - 300395)) or ((4599 - (270 + 199)) <= (958 + 1997))) then
			local v67 = 1819 - (580 + 1239);
			while true do
				if ((v67 == (0 - 0)) or ((1878 + 86) <= (49 + 1291))) then
					v10.GhoulTable.SummonedGhoul = nil;
					v10.GhoulTable.SummonExpiration = nil;
					break;
				end
			end
		end
		if (((1089 + 1410) == (6524 - 4025)) and v13:HasTier(20 + 11, 1171 - (645 + 522)) and ((v10.GhoulTable.ApocMagusExpiration > (1790 - (1010 + 780))) or (v10.GhoulTable.ArmyMagusExpiration > (0 + 0)))) then
			if ((v49 == (409448 - 323500)) or ((6608 - 4353) < (1858 - (1045 + 791)))) then
				local v72 = 0 - 0;
				while true do
					if ((v72 == (0 - 0)) or ((1591 - (351 + 154)) >= (2979 - (1281 + 293)))) then
						if (v10.GhoulTable:ApocMagusActive() or ((2635 - (28 + 238)) == (951 - 525))) then
							v10.GhoulTable.ApocMagusExpiration = v10.GhoulTable.ApocMagusExpiration + (1560 - (1381 + 178));
						end
						if (v10.GhoulTable:ArmyMagusActive() or ((2886 + 190) > (2567 + 616))) then
							v10.GhoulTable.ArmyMagusExpiration = v10.GhoulTable.ArmyMagusExpiration + 1 + 0;
						end
						break;
					end
				end
			end
			for v70, v71 in pairs(v34) do
				if (((4143 - 2941) > (549 + 509)) and (v71 == v49)) then
					local v78 = 470 - (381 + 89);
					while true do
						if (((3291 + 420) > (2269 + 1086)) and ((0 - 0) == v78)) then
							if (v10.GhoulTable:ApocMagusActive() or ((2062 - (1074 + 82)) >= (4884 - 2655))) then
								v10.GhoulTable.ApocMagusExpiration = v10.GhoulTable.ApocMagusExpiration + (1784.5 - (214 + 1570));
							end
							if (((2743 - (990 + 465)) > (516 + 735)) and v10.GhoulTable:ArmyMagusActive()) then
								v10.GhoulTable.ArmyMagusExpiration = v10.GhoulTable.ArmyMagusExpiration + 0.5 + 0;
							end
							break;
						end
					end
				end
			end
		end
		if ((v13:HasTier(31 + 0, 7 - 5) and (v49 == (277425 - (1668 + 58)))) or ((5139 - (512 + 114)) < (8738 - 5386))) then
			v10.GhoulTable.ApocMagusExpiration = GetTime() + (41 - 21);
		end
		if ((v13:HasTier(107 - 76, 1 + 1) and (v49 == (7984 + 34666))) or ((1796 + 269) >= (10779 - 7583))) then
			v10.GhoulTable.ArmyMagusExpiration = GetTime() + (2024 - (109 + 1885));
		end
	end, "SPELL_CAST_SUCCESS");
	v10:RegisterForCombatEvent(function(v50, v50, v50, v50, v50, v50, v50, v51)
		local v52 = 1469 - (1269 + 200);
		while true do
			if ((v52 == (0 - 0)) or ((5191 - (98 + 717)) <= (2307 - (802 + 24)))) then
				if ((v51 == v10.GhoulTable.SummonedGhoul) or ((5848 - 2456) >= (5987 - 1246))) then
					local v79 = 0 + 0;
					while true do
						if (((2555 + 770) >= (354 + 1800)) and (v79 == (0 + 0))) then
							v10.GhoulTable.SummonedGhoul = nil;
							v10.GhoulTable.SummonExpiration = nil;
							break;
						end
					end
				end
				if ((v51 == v10.GhoulTable.SummonedGargoyle) or ((3602 - 2307) >= (10781 - 7548))) then
					local v80 = 0 + 0;
					while true do
						if (((1782 + 2595) > (1355 + 287)) and (v80 == (0 + 0))) then
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
			if (((6156 - (797 + 636)) > (6583 - 5227)) and (v54 == (1619 - (1427 + 192)))) then
				if ((v10.GhoulTable.SummonExpiration == nil) or ((1434 + 2702) <= (7970 - 4537))) then
					return 0 + 0;
				end
				return v10.GhoulTable.SummonExpiration - GetTime();
			end
		end
	end;
	v10.GhoulTable.GhoulActive = function(v55)
		return (v10.GhoulTable.SummonedGhoul ~= nil) and (v10.GhoulTable:GhoulRemains() > (0 + 0));
	end;
	v10.GhoulTable.GargRemains = function(v56)
		local v57 = 326 - (192 + 134);
		while true do
			if (((5521 - (316 + 960)) <= (2578 + 2053)) and (v57 == (0 + 0))) then
				if (((3953 + 323) >= (14963 - 11049)) and (v10.GhoulTable.GargoyleExpiration == nil)) then
					return 551 - (83 + 468);
				end
				return v10.GhoulTable.GargoyleExpiration - GetTime();
			end
		end
	end;
	v10.GhoulTable.GargActive = function(v58)
		return (v10.GhoulTable.SummonedGargoyle ~= nil) and (v10.GhoulTable:GargRemains() > (1806 - (1202 + 604)));
	end;
	v10.GhoulTable.ArmyMagusRemains = function(v59)
		return v10.GhoulTable.ArmyMagusExpiration - GetTime();
	end;
	v10.GhoulTable.ArmyMagusActive = function(v60)
		return v10.GhoulTable:ArmyMagusRemains() > (0 - 0);
	end;
	v10.GhoulTable.ApocMagusRemains = function(v61)
		return v10.GhoulTable.ApocMagusExpiration - GetTime();
	end;
	v10.GhoulTable.ApocMagusActive = function(v62)
		return v10.GhoulTable.ApocMagusRemains() > (0 - 0);
	end;
end;
return v0["Epix_DeathKnight_DeathKnight.lua"]();

