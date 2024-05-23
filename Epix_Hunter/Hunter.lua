local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1528 + 260) > (2636 + 776))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Hunter_Hunter.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Target;
	local v14 = v11.Pet;
	local v15 = v9.Spell;
	local v16 = v9.MultiSpell;
	local v17 = v9.Item;
	local v18 = v9.Utils.MergeTableByKey;
	local v19 = EpicLib;
	local v20 = v19.Macro;
	if (not v15.Hunter or ((331 + 991) > (558 + 2990))) then
		v15.Hunter = {};
	end
	v15.Hunter.Commons = {AncestralCall=v15(275615 - (282 + 595), nil, 1638 - (1523 + 114)),ArcanePulse=v15(233979 + 26385, nil, 2 - 0),ArcaneTorrent=v15(51678 - (68 + 997), nil, 1273 - (226 + 1044)),BagofTricks=v15(1360363 - 1047952, nil, 121 - (32 + 85)),Berserking=v15(25772 + 525, nil, 2 + 3),BloodFury=v15(21529 - (892 + 65), nil, 14 - 8),Fireblood=v15(490243 - 225022, nil, 12 - 5),LightsJudgment=v15(255997 - (87 + 263), nil, 188 - (67 + 113)),ArcaneShot=v15(135918 + 49440, nil, 21 - 12),Exhilaration=v15(80388 + 28916, nil, 39 - 29),Flare=v15(2495 - (802 + 150), nil, 29 - 18),FreezingTrap=v15(340390 - 152740, nil, 9 + 3),HuntersMark=v15(258281 - (915 + 82), nil, 36 - 23),Bite=v15(10051 + 7202, "Pet"),BloodBolt=v15(380025 - 91063, "Pet"),Claw=v15(18014 - (1069 + 118), "Pet"),Growl=v15(6009 - 3360, "Pet"),Smack=v15(109299 - 59333, "Pet"),MendPet=v15(24 + 112, nil, 24 - 10),RevivePet=v15(975 + 7, nil, 806 - (368 + 423)),SummonPet=v15(2774 - 1891, nil, 34 - (10 + 8)),SummonPet2=v15(320209 - 236967, nil, 459 - (416 + 26)),SummonPet3=v15(265787 - 182544, nil, 8 + 10),SummonPet4=v15(147294 - 64050, nil, 457 - (145 + 293)),SummonPet5=v15(83675 - (44 + 386), nil, 1506 - (998 + 488)),AlphaPredator=v15(85694 + 184043, nil, 18 + 3),Barrage=v15(121132 - (201 + 571), nil, 1160 - (116 + 1022)),BeastMaster=v15(1573744 - 1195737, nil, 14 + 9),BindingShot=v15(398830 - 289582, nil, 85 - 61),CounterShot=v15(148221 - (814 + 45), nil, 61 - 36),DeathChakram=v15(20255 + 355636, nil, 10 + 16),ExplosiveShot=v15(213316 - (261 + 624), nil, 47 - 20),HydrasBite=v15(261321 - (1020 + 60), nil, 1451 - (630 + 793)),Intimidation=v15(66339 - 46762, nil, 137 - 108),KillCommand=v16(80 + 121, 117152 - 83126, 261236 - (760 + 987)),KillShot=v16(2115 - (1789 + 124), 54117 - (745 + 21), 110405 + 210571),KillerInstinct=v15(753640 - 479753, nil, 117 - 87),Misdirection=v15(282 + 34195, nil, 25 + 6),Muzzle=v15(188762 - (87 + 968), nil, 140 - 108),PoisonInjection=v15(342959 + 35055, nil, 74 - 41),ScareBeast=v15(2926 - (447 + 966), nil, 92 - 58),SerpentSting=v15(273605 - (1703 + 114), nil, 736 - (376 + 325)),Stampede=v15(330102 - 128672, nil, 110 - 74),SteelTrap=v15(46436 + 116052, nil, 81 - 44),TarTrap=v15(187712 - (9 + 5), nil, 414 - (85 + 291)),TranquilizingShot=v15(21066 - (243 + 1022), nil, 148 - 109),WailingArrow=v15(323436 + 68624, nil, 1220 - (1123 + 57)),BerserkingBuff=v15(21397 + 4900, nil, 295 - (163 + 91)),BloodFuryBuff=v15(22502 - (1869 + 61), nil, 12 + 30),SeethingRageBuff=v15(1439922 - 1031087, nil, 65 - 22),HuntersMarkDebuff=v15(35207 + 222077, nil, 60 - 16),LatentPoisonDebuff=v15(316444 + 20459, nil, 1519 - (1329 + 145)),SerpentStingDebuff=v15(272759 - (140 + 831), nil, 1896 - (1409 + 441)),TarTrapDebuff=v15(136017 - (15 + 703), nil, 22 + 25),PoolFocus=v15(1000348 - (262 + 176), nil, 1924 - (345 + 1376))};
	v15.Hunter.BeastMastery = v18(v15.Hunter.Commons, {AMurderofCrows=v15(132582 - (198 + 490), nil, 216 - 167),AnimalCompanion=v15(640729 - 373613, nil, 1256 - (696 + 510)),AspectoftheWild=v15(405887 - 212357, nil, 1313 - (1091 + 171)),BarbedShot=v15(34953 + 182247, nil, 163 - 111),BeastCleave=v15(384492 - 268553, nil, 427 - (123 + 251)),BestialWrath=v15(97262 - 77688, nil, 752 - (208 + 490)),Bloodshed=v15(27133 + 294397, nil, 25 + 30),BloodyFrenzy=v15(408248 - (660 + 176), nil, 25 + 179),CalloftheWild=v15(360046 - (14 + 188), nil, 731 - (534 + 141)),CobraShot=v15(77773 + 115682, nil, 51 + 6),DireBeast=v15(116027 + 4652, nil, 121 - 63),KillCleave=v15(600448 - 222241, nil, 165 - 106),MultiShot=v15(1420 + 1223, nil, 39 + 21),OneWithThePack=v15(199924 - (115 + 281), nil, 141 - 80),Savagery=v15(351509 + 73048, nil, 492 - 288),ScentofBlood=v15(709643 - 516111, nil, 929 - (550 + 317)),Stomp=v15(288277 - 88747, nil, 87 - 24),WildCall=v15(519183 - 333394, nil, 349 - (134 + 151)),WildInstincts=v15(380107 - (970 + 695), nil, 124 - 59),AspectoftheWildBuff=v15(195520 - (582 + 1408), nil, 228 - 162),BeastCleavePetBuff=v15(149042 - 30587, "Pet", 252 - 185),BeastCleaveBuff=v15(270701 - (1195 + 629), nil, 89 - 21),BestialWrathBuff=v15(19815 - (187 + 54), nil, 849 - (162 + 618)),BestialWrathPetBuff=v15(130508 + 55746, "Pet", 47 + 23),CalloftheWildBuff=v15(767439 - 407595, nil, 119 - 48),FrenzyPetBuff=v15(21330 + 251460, "Pet", 1708 - (1373 + 263)),BarbedShotDebuff=v15(218200 - (451 + 549), nil, 24 + 49)});
	v15.Hunter.Marksmanship = v18(v15.Hunter.Commons, {SteadyShot=v15(88147 - 31506, nil, 126 - 51),AimedShot=v15(20818 - (746 + 638), nil, 29 + 47),BurstingShot=v15(282987 - 96600, nil, 418 - (218 + 123)),CarefulAim=v15(261809 - (1535 + 46), nil, 78 + 0),ChimaeraShot=v15(49496 + 292553, nil, 639 - (306 + 254)),DoubleTap=v15(16121 + 244281, nil, 157 - 77),InTheRhythm=v15(408871 - (899 + 568), nil, 54 + 27),LegacyoftheWindrunners=v15(983509 - 577084, nil, 685 - (268 + 335)),LoneWolf=v15(155518 - (60 + 230), nil, 655 - (426 + 146)),MultiShot=v15(30861 + 226759, nil, 1540 - (282 + 1174)),RapidFire=v15(257855 - (569 + 242), nil, 244 - 159),Salvo=v15(22901 + 377555, nil, 1110 - (706 + 318)),SerpentstalkersTrickery=v15(380139 - (721 + 530), nil, 1358 - (945 + 326)),SteadyFocus=v15(483507 - 289974, nil, 79 + 9),Streamline=v15(261067 - (271 + 429), nil, 82 + 7),SurgingShots=v15(393059 - (1408 + 92), nil, 1176 - (461 + 625)),TrickShots=v15(258909 - (993 + 295), nil, 5 + 86),Trueshot=v15(289784 - (418 + 753), nil, 36 + 56),Volley=v15(26821 + 233422, nil, 28 + 65),WindrunnersGuidance=v15(95760 + 283145, nil, 623 - (406 + 123)),BombardmentBuff=v15(388644 - (1749 + 20), nil, 23 + 72),BulletstormBuff=v15(390342 - (1249 + 73), nil, 35 + 61),DoubleTapBuff=v15(261547 - (466 + 679), nil, 233 - 136),InTheRhythmBuff=v15(1165254 - 757849, nil, 1998 - (106 + 1794)),LockandLoadBuff=v15(61561 + 133033, nil, 26 + 73),PreciseShotsBuff=v15(768338 - 508096, nil, 270 - 170),RazorFragmentsBuff=v15(389112 - (4 + 110), nil, 685 - (57 + 527)),SalvoBuff=v15(401883 - (41 + 1386), nil, 205 - (17 + 86)),SteadyFocusBuff=v15(131353 + 62181, nil, 229 - 126),TrickShotsBuff=v15(746059 - 488437, nil, 270 - (122 + 44)),TrueshotBuff=v15(498530 - 209917, nil, 348 - 243),VolleyBuff=v15(211704 + 48539, nil, 16 + 90),SalvoDebuff=v15(787873 - 398964, nil, 172 - (30 + 35)),EagletalonsTrueFocusBuff=v15(231522 + 105329, nil, 1365 - (1043 + 214))});
	v15.Hunter.Survival = v18(v15.Hunter.Commons, {PheromoneBomb=v15(1021998 - 751675, nil, 1321 - (323 + 889)),ShrapnelBomb=v15(727644 - 457309, nil, 690 - (361 + 219)),VolatileBomb=v15(271365 - (53 + 267), nil, 26 + 85),WildfireBomb=v15(259908 - (15 + 398), nil, 1094 - (18 + 964)),AspectoftheEagle=v15(701213 - 514924, nil, 66 + 47),BirdsofPrey=v15(164018 + 96313, nil, 964 - (20 + 830)),Bombardier=v15(304337 + 85543, nil, 241 - (116 + 10)),Butchery=v15(15692 + 196744, nil, 854 - (542 + 196)),Carve=v15(402391 - 214683, nil, 35 + 82),CoordinatedAssault=v15(183388 + 177564, nil, 43 + 75),CoordinatedKill=v15(1016457 - 630718, nil, 304 - 185),FlankersAdvantage=v15(264737 - (1126 + 425)),FlankingStrike=v15(270156 - (118 + 287), nil, 470 - 350),FuryoftheEagle=v15(204536 - (118 + 1003), nil, 354 - 233),Harpoon=v15(191302 - (142 + 235), nil, 553 - 431),Lunge=v15(82452 + 296482, nil, 1100 - (553 + 424)),MongooseBite=v16(385 - 181, 228499 + 30888, 263756 + 2132),Ranger=v15(224574 + 161121, nil, 53 + 71),RaptorStrike=v16(118 + 87, 403813 - 217543, 738900 - 473711),RuthlessMarauder=v15(863639 - 477921, nil, 37 + 88),Spearhead=v15(1744425 - 1383459, nil, 879 - (239 + 514)),TermsofEngagement=v15(93386 + 172509, nil, 1456 - (797 + 532)),TipoftheSpear=v15(189128 + 71157, nil, 44 + 84),VipersVenom=v15(631314 - 362813, nil, 1331 - (373 + 829)),WildfireInfusion=v15(271745 - (476 + 255), nil, 1260 - (369 + 761)),BloodseekerBuff=v15(150547 + 109702, nil, 237 - 106),ContainedExplosionBuff=v15(807923 - 381579),CoordinatedAssaultBuff=v15(361190 - (64 + 174), nil, 19 + 113),CoordinatedAssaultEmpowerBuff=v15(535711 - 173973, nil, 469 - (144 + 192)),DeadlyDuoBuff=v15(397784 - (42 + 174), nil, 101 + 33),MongooseFuryBuff=v15(214870 + 44518, nil, 58 + 77),SpearheadBuff=v15(362470 - (363 + 1141), nil, 1716 - (1183 + 397)),SteelTrapDebuff=v15(494666 - 332179, nil, 101 + 36),TipoftheSpearBuff=v15(194553 + 65733, nil, 2113 - (1913 + 62)),BloodseekerDebuff=v15(163288 + 95989, nil, 367 - 228),InternalBleedingDebuff=v15(272276 - (565 + 1368), nil, 526 - 386),PheromoneBombDebuff=v15(271993 - (1477 + 184), nil, 191 - 50),ShrapnelBombDebuff=v15(251889 + 18450, nil, 998 - (564 + 292)),ShreddedArmorDebuff=v15(707713 - 297546, nil, 430 - 287),VolatileBombDebuff=v15(271353 - (244 + 60), nil, 111 + 33),WildfireBombDebuff=v15(270223 - (41 + 435), nil, 1146 - (938 + 63))});
	if (not v17.Hunter or ((440 + 132) >= (5611 - (936 + 189)))) then
		v17.Hunter = {};
	end
	v17.Hunter.Commons = {Healthstone=v17(1815 + 3697),AlgetharPuzzleBox=v17(195314 - (1565 + 48), {(1151 - (782 + 356)),(36 - 22)}),DMDDance=v17(291944 - 93856, {(1888 - (157 + 1718)),(49 - 35)}),DMDDanceBox=v17(678558 - 480080, {(35 - 22),(31 - 17)}),DMDInferno=v17(77104 + 120982, {(34 - 21),(625 - (602 + 9))}),DMDInfernoBox=v17(196061 - (449 + 740), {(960 - (245 + 702)),(5 + 9)}),DMDRime=v17(199985 - (260 + 1638), {(41 - 28),(28 - 14)}),DMDRimeBox=v17(589994 - 391517, {(27 - 14),(2 + 12)}),DMDWatcher=v17(199779 - (1121 + 569), {(696 - (483 + 200)),(38 - 24)}),DMDWatcherBox=v17(266763 - 68282, {(575 - (334 + 228)),(32 - 18)}),DecorationofFlame=v17(352388 - 158089, {(249 - (141 + 95)),(35 - 21)}),GlobeofJaggedIce=v17(465714 - 271982, {(35 - 22),(8 + 6)}),ManicGrieftorch=v17(273632 - 79324, {(176 - (92 + 71)),(23 - 9)}),StormeatersBoon=v17(195067 - (574 + 191), {(32 - 19),(863 - (254 + 595))}),WindscarWhetstone=v17(137612 - (55 + 71), {(1803 - (573 + 1217)),(2 + 12)}),RefreshingHealingPotion=v17(308389 - 117009),DreamwalkersHealingPotion=v17(207962 - (714 + 225)),PotionOfWitheringDreams=v17(605057 - 398016),Djaruun=v17(282413 - 79844, {(22 - 6)})};
	v17.Hunter.BeastMastery = v18(v17.Hunter.Commons, {});
	v17.Hunter.Marksmanship = v18(v17.Hunter.Commons, {});
	v17.Hunter.Survival = v18(v17.Hunter.Commons, {});
	if (((2210 - (118 + 688)) == (1452 - (25 + 23))) and not v20.Hunter) then
		v20.Hunter = {};
	end
	v20.Hunter.Commons = {Healthstone=v20(5 + 16),Trinket1=v20(1899 - (927 + 959)),Trinket2=v20(47 - 33),ArcaneShotMouseover=v20(741 - (16 + 716)),BindingShotCursor=v20(19 - 9),CounterShotMouseover=v20(108 - (11 + 86)),IntimidationMouseover=v20(29 - 17),KillShotMouseover=v20(298 - (175 + 110)),MuzzleMouseover=v20(35 - 21),SerpentStingMouseover=v20(73 - 58),SteelTrapCursor=v20(1812 - (503 + 1293)),MisdirectionFocus=v20(47 - 30),TarTrapCursor=v20(14 + 4),FreezingTrapCursor=v20(1080 - (810 + 251)),RefreshingHealingPotion=v20(21 + 8)};
	v20.Hunter.BeastMastery = v18(v20.Hunter.Commons, {BarbedShotMouseover=v20(7 + 13),BarbedShotPetAttack=v20(20 + 2),CobraShotMouseover=v20(556 - (43 + 490)),CobraShotPetAttack=v20(757 - (711 + 22)),KillCommandPetAttack=v20(96 - 71)});
	v20.Hunter.Marksmanship = v18(v20.Hunter.Commons, {AimedShotMouseover=v20(885 - (240 + 619)),VolleyCursor=v20(7 + 20)});
	v20.Hunter.Survival = v18(v20.Hunter.Commons, {HarpoonMouseover=v20(44 - 16)});
end;
return v0["Epix_Hunter_Hunter.lua"]();

