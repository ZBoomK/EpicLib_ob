local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((2530 - (926 + 465)) <= (120 + 2092)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Druid_Druid.lua"] = function(...)
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
	if (not v15.Druid or ((417 + 763) >= (5098 - (261 + 624)))) then
		v15.Druid = {};
	end
	v15.Druid.Commons = {Nothing=v15(0 - 0, nil, 1080 - (1020 + 60)),Berserking=v15(27720 - (630 + 793), nil, 3 - 2),Shadowmeld=v15(279274 - 220290, nil, 1 + 1),Barkskin=v15(78542 - 55730, nil, 1750 - (760 + 987)),BearForm=v15(7400 - (1789 + 124), nil, 770 - (745 + 21)),CatForm=v15(265 + 503, nil, 13 - 8),FerociousBite=v15(88523 - 65955, nil, 1 + 5),MarkOfTheWild=v15(885 + 241, nil, 1062 - (87 + 968)),MarkoftheWildBuff=v15(4956 - 3830),Moonfire=v15(8094 + 827, nil, 17 - 9),Prowl=v15(6628 - (447 + 966), nil, 24 - 15),Rebirth=v15(22301 - (1703 + 114), nil, 711 - (376 + 325)),Regrowth=v15(14643 - 5707, nil, 33 - 22),Rejuvenation=v15(222 + 552, nil, 26 - 14),Revive=v15(50783 - (9 + 5), nil, 389 - (85 + 291)),Shred=v15(6486 - (243 + 1022), nil, 53 - 39),Soothe=v15(2399 + 509, nil, 1195 - (1123 + 57)),TravelForm=v15(638 + 145, nil, 270 - (163 + 91)),AstralInfluence=v15(199454 - (1869 + 61), nil, 60 + 153),AstralCommunion=v15(712710 - 510351, nil, 25 - 8),ConvokeTheSpirits=v15(53576 + 337952, nil, 24 - 6),FrenziedRegeneration=v15(21455 + 1387, nil, 1493 - (1329 + 145)),HeartOfTheWild=v15(320425 - (140 + 831), nil, 1870 - (1409 + 441)),Innervate=v15(29884 - (15 + 703), nil, 10 + 11),IncapacitatingRoar=v15(537 - (262 + 176), nil, 1743 - (345 + 1376)),ImprovedNaturesCure=v15(393066 - (198 + 490), nil, 101 - 78),Ironfur=v15(460743 - 268662, nil, 1230 - (696 + 510)),NaturesVigil=v15(262105 - 137131, nil, 1287 - (1091 + 171)),Maim=v15(3632 + 18938, nil, 81 - 55),MightyBash=v15(17281 - 12070, nil, 401 - (123 + 251)),MoonkinForm=v16(1028 - 821, 25556 - (208 + 490), 16677 + 180948),PoPHealBuff=v15(176101 + 219235, nil, 864 - (660 + 176)),Rake=v15(219 + 1603, nil, 231 - (14 + 188)),Renewal=v15(108913 - (534 + 141), nil, 13 + 17),RemoveCorruption=v15(2461 + 321, nil, 30 + 1),Rip=v15(2267 - 1188, nil, 50 - 18),SkullBash=v15(299688 - 192849, nil, 18 + 15),StampedingRoar=v15(49514 + 28250, nil, 430 - (115 + 281)),Starfire=v15(451606 - 257453, nil, 29 + 6),Starsurge=v16(497 - 291, 288481 - 209807, 198493 - (550 + 317)),Sunfire=v15(134945 - 41543, nil, 50 - 14),SurvivalInstincts=v15(171402 - 110066, nil, 322 - (134 + 151)),Swiftmend=v15(20227 - (970 + 695), nil, 72 - 34),Swipe=v16(2195 - (582 + 1408), 370338 - 263553, 268971 - 55200, 805539 - 591775),Typhoon=v15(134293 - (1195 + 629), nil, 50 - 11),Thrash=v16(451 - (187 + 54), 78538 - (162 + 618), 74856 + 31974),WildCharge=v16(136 + 68, 36210 - 19231, 83010 - 33634, 8008 + 94409),Wildgrowth=v15(50074 - (1373 + 263), nil, 1040 - (451 + 549)),UrsolsVortex=v15(32448 + 70345, nil, 63 - 22),MassEntanglement=v15(172030 - 69671, nil, 1426 - (746 + 638)),FrenziedRegenerationBuff=v15(8597 + 14245, nil, 65 - 22),IronfurBuff=v15(192422 - (218 + 123), nil, 1625 - (1535 + 46)),SuddenAmbushBuff=v15(338518 + 2180, nil, 7 + 38),MoonfireDebuff=v15(165372 - (306 + 254), nil, 3 + 43),RakeDebuff=v15(305610 - 149888, nil, 1514 - (899 + 568)),SunfireDebuff=v15(108333 + 56482, nil, 116 - 68),ThrashDebuff=v16(806 - (268 + 335), 107120 - (60 + 230), 192662 - (426 + 146)),Hibernate=v15(316 + 2321, nil, 1664 - (282 + 1174)),Pool=v15(1000721 - (569 + 242), nil, 140 - 91)};
	v15.Druid.Balance = v18(v15.Druid.Commons, {EclipseLunar=v15(2775 + 45743, nil, 1074 - (706 + 318)),EclipseSolar=v15(49768 - (721 + 530), nil, 1322 - (945 + 326)),Wrath=v15(477138 - 286154, nil, 47 + 5),AetherialKindling=v15(328241 - (271 + 429), nil, 49 + 4),AstralCommunion=v15(402136 - (1408 + 92), nil, 1140 - (461 + 625)),AstralSmolder=v15(395346 - (993 + 295), nil, 3 + 52),BalanceofAllThings=v15(395219 - (418 + 753), nil, 22 + 34),CelestialAlignment=v16(21 + 181, 56807 + 137416, 96898 + 286512),ElunesGuidance=v15(394520 - (406 + 123), nil, 1826 - (1749 + 20)),ForceOfNature=v15(48844 + 156792, nil, 1380 - (1249 + 73)),FungalGrowth=v15(140210 + 252789, nil, 1204 - (466 + 679)),FuryOfElune=v15(487757 - 284987, nil, 171 - 111),Incarnation=v16(2101 - (106 + 1794), 32446 + 70114, 98689 + 291725),IncarnationTalent=v15(1163284 - 769271, nil, 165 - 104),NaturesBalance=v15(202544 - (4 + 110), nil, 646 - (57 + 527)),OrbitBreaker=v15(384624 - (41 + 1386), nil, 166 - (17 + 86)),OrbitalStrike=v15(264951 + 125427, nil, 142 - 78),PowerofGoldrinn=v15(1141135 - 747089, nil, 231 - (122 + 44)),PrimordialArcanicPulsar=v15(680500 - 286540, nil, 218 - 152),RattleTheStars=v15(320476 + 73478, nil, 10 + 57),Solstice=v15(696179 - 352532, nil, 133 - (30 + 35)),SouloftheForest=v15(78427 + 35680, nil, 1326 - (1043 + 214)),Starfall=v15(722234 - 531200, nil, 1282 - (323 + 889)),Starlord=v15(544640 - 342295, nil, 651 - (361 + 219)),Starweaver=v15(394260 - (53 + 267), nil, 17 + 55),StellarFlare=v15(202760 - (15 + 398), nil, 1055 - (18 + 964)),TwinMoons=v15(1052522 - 772902, nil, 43 + 31),UmbralEmbrace=v15(248084 + 145676, nil, 925 - (20 + 830)),UmbralIntensity=v15(299118 + 84077, nil, 202 - (116 + 10)),WaningTwilight=v15(29101 + 364855, nil, 815 - (542 + 196)),WarriorofElune=v15(433940 - 231515, nil, 23 + 55),WildMushroom=v15(45090 + 43657, nil, 29 + 50),WildSurges=v15(1072192 - 665302),FullMoon=v15(703203 - 428920, nil, 1631 - (1126 + 425)),HalfMoon=v15(274687 - (118 + 287), nil, 317 - 236),NewMoon=v15(275402 - (118 + 1003), nil, 239 - 157),BOATArcaneBuff=v15(394427 - (142 + 235), nil, 376 - 293),BOATNatureBuff=v15(85741 + 308308, nil, 1061 - (553 + 424)),CABuff=v15(725011 - 341601, nil, 75 + 10),IncarnationBuff=v16(199 + 1, 59717 + 42843, 165961 + 224453),PAPBuff=v15(224980 + 168981, nil, 186 - 100),RattledStarsBuff=v15(1097683 - 703728, nil, 194 - 107),SolsticeBuff=v15(99931 + 243717, nil, 425 - 337),StarfallBuff=v15(191787 - (239 + 514), nil, 32 + 57),StarlordBuff=v15(281038 - (797 + 532), nil, 66 + 24),StarweaversWarp=v15(132898 + 261044, nil, 213 - 122),StarweaversWeft=v15(395146 - (373 + 829), nil, 823 - (476 + 255)),UmbralEmbraceBuff=v15(394893 - (369 + 761), nil, 54 + 39),WarriorofEluneBuff=v15(367682 - 165257, nil, 178 - 84),FungalGrowthDebuff=v15(81519 - (64 + 174), nil, 14 + 81),StellarFlareDebuff=v15(299663 - 97316, nil, 432 - (144 + 192)),GatheringStarstuff=v15(394628 - (42 + 174), nil, 73 + 24),TouchTheCosmos=v15(326722 + 67692, nil, 42 + 56),BOATArcaneLegBuff=v15(341450 - (363 + 1141), nil, 1679 - (1183 + 397)),BOATNatureLegBuff=v15(1034903 - 694960, nil, 74 + 26),OnethsClearVisionBuff=v15(253984 + 85813, nil, 2076 - (1913 + 62)),OnethsPerceptionBuff=v15(213999 + 125801, nil, 269 - 167),TimewornDreambinderBuff=v15(341982 - (565 + 1368), nil, 387 - 284),DreamstateBuff=v15(425909 - (1477 + 184))});
	v15.Druid.Feral = v18(v15.Druid.Commons, {AdaptiveSwarm=v15(533979 - 142091, nil, 97 + 7),ApexPredatorsCraving=v15(392737 - (564 + 292), nil, 180 - 75),AshamanesGuidance=v15(1180191 - 788643, nil, 410 - (244 + 60)),Berserk=v15(82236 + 24715, nil, 583 - (41 + 435)),BerserkHeartoftheLion=v15(392175 - (938 + 63), nil, 84 + 24),Bloodtalons=v15(320564 - (936 + 189), nil, 36 + 73),BrutalSlash=v15(203641 - (1565 + 48), nil, 68 + 42),CircleofLifeandDeath=v15(401458 - (782 + 356), nil, 378 - (176 + 91)),DireFixation=v15(1088272 - 670562, nil, 164 - 52),DoubleClawedRake=v15(392792 - (975 + 117), nil, 1988 - (157 + 1718)),FeralFrenzy=v15(223046 + 51791, nil, 404 - 290),Incarnation=v15(350575 - 248032, nil, 1133 - (697 + 321)),LionsStrength=v15(1067781 - 675809, nil, 245 - 129),LunarInspiration=v15(358671 - 203091, nil, 46 + 71),LIMoonfire=v15(291587 - 135962, nil, 316 - 198),MomentofClarity=v15(237295 - (322 + 905), nil, 730 - (602 + 9)),Predator=v15(203210 - (449 + 740), nil, 992 - (826 + 46)),PrimalWrath=v15(286328 - (245 + 702), nil, 382 - 261),RampantFerocity=v15(125923 + 265786, nil, 2020 - (260 + 1638)),RipandTear=v15(391787 - (382 + 58), nil, 394 - 271),Sabertooth=v15(167879 + 34152, nil, 256 - 132),SouloftheForest=v15(471086 - 312610, nil, 1330 - (902 + 303)),Swipe=v15(234461 - 127676, nil, 303 - 177),TearOpenWounds=v15(33667 + 358118, nil, 1817 - (1121 + 569)),ThrashingClaws=v15(405514 - (22 + 192), nil, 811 - (483 + 200)),TigersFury=v15(6680 - (1404 + 59), nil, 352 - 223),UnbridledSwarm=v15(526793 - 134842, nil, 895 - (468 + 297)),WildSlashes=v15(391426 - (334 + 228), nil, 441 - 310),FranticMomentum=v15(908331 - 516456, nil, 382 - 171),ApexPredatorsCravingBuff=v15(111281 + 280601, nil, 368 - (141 + 95)),BloodtalonsBuff=v15(142584 + 2568, nil, 341 - 208),Clearcasting=v15(326211 - 190511, nil, 32 + 102),OverflowingPowerBuff=v15(1110168 - 704979, nil, 95 + 40),PredatorRevealedBuff=v15(212700 + 195768, nil, 191 - 55),PredatorySwiftnessBuff=v15(40918 + 28451, nil, 300 - (92 + 71)),SabertoothBuff=v15(193489 + 198233, nil, 231 - 93),SuddenAmbushBuff=v15(392739 - (574 + 191), nil, 115 + 24),SmolderingFrenzyBuff=v15(1059120 - 636369, nil, 109 + 103),AdaptiveSwarmDebuff=v15(392738 - (254 + 595), nil, 266 - (55 + 71)),AdaptiveSwarmHeal=v15(516274 - 124383, nil, 1931 - (573 + 1217)),DireFixationDebuff=v15(1156823 - 739110, nil, 11 + 131),LIMoonfireDebuff=v15(250773 - 95148, nil, 1082 - (714 + 225)),ThrashDebuff=v15(1184253 - 779020, nil, 200 - 56)});
	v15.Druid.Guardian = v18(v15.Druid.Commons, {Mangle=v15(3672 + 30245, nil, 209 - 64),Berserk=v15(51140 - (118 + 688), nil, 194 - (25 + 23)),BristlingFur=v15(30184 + 125651, nil, 2033 - (927 + 959)),DreamofCenarius=v15(1254374 - 882255, nil, 880 - (16 + 716)),FlashingClaws=v15(759473 - 366046, nil, 246 - (11 + 86)),FuryofNature=v15(904188 - 533493, nil, 435 - (175 + 110)),Incarnation=v15(258937 - 156379, nil, 744 - 593),LayeredMane=v15(386517 - (503 + 1293), nil, 424 - 272),LunarBeam=v15(147573 + 56493, nil, 1214 - (810 + 251)),Maul=v15(4724 + 2083, nil, 48 + 106),Pulverize=v15(72399 + 7914, nil, 688 - (43 + 490)),RageoftheSleeper=v15(201584 - (711 + 22), nil, 603 - 447),Raze=v15(401113 - (240 + 619), nil, 38 + 119),ReinforcedFur=v15(626129 - 232511, nil, 11 + 147),SouloftheForest=v15(160221 - (1344 + 400), nil, 564 - (255 + 150)),Swipe=v15(168383 + 45388, nil, 86 + 74),ThornsofIron=v15(1709980 - 1309758, nil, 519 - 358),ToothandClaw=v15(137027 - (404 + 1335), nil, 568 - (183 + 223)),ViciousCycle=v15(452671 - 80672, nil, 109 + 54),VulnerableFlesh=v15(134097 + 238521, nil, 501 - (10 + 327)),Growl=v15(4732 + 2063, nil, 548 - (118 + 220)),BerserkBuff=v15(16774 + 33560, nil, 614 - (108 + 341)),DreamofCenariusBuff=v15(167147 + 205005, nil, 701 - 535),GalacticGuardianBuff=v15(215201 - (711 + 782), nil, 319 - 152),GoreBuff=v15(94131 - (270 + 199), nil, 55 + 113),IncarnationBuff=v15(104377 - (580 + 1239), nil, 502 - 333),ToothandClawBuff=v15(129355 + 5931, nil, 7 + 163),ViciousCycleMaulBuff=v15(162059 + 209956, nil, 446 - 275),ViciousCycleMangleBuff=v15(231120 + 140899, nil, 1339 - (645 + 522)),ToothandClawDebuff=v15(137391 - (1010 + 780), nil, 173 + 0)});
	v15.Druid.Restoration = v18(v15.Druid.Commons, {EclipseLunar=v15(231135 - 182617, nil, 509 - 335),EclipseSolar=v15(50353 - (1045 + 791), nil, 442 - 267),Efflorescence=v15(221720 - 76515, nil, 681 - (351 + 154)),Lifebloom=v16(1773 - (1281 + 293), 34029 - (28 + 238), 421309 - 232759),NaturesCure=v15(89982 - (1381 + 178), nil, 167 + 10),Revitalize=v15(170977 + 41063, nil, 76 + 102),Starfire=v15(681306 - 483678, nil, 93 + 86),Starsurge=v15(198096 - (381 + 89), nil, 160 + 20),Wrath=v15(3501 + 1675, nil, 309 - 128),Abundance=v15(208539 - (1074 + 82), nil, 398 - 216),AdaptiveSwarm=v15(393672 - (214 + 1570), nil, 1638 - (990 + 465)),BalanceAffinity=v15(81473 + 116159, nil, 81 + 103),CenarionWard=v15(99532 + 2819, nil, 727 - 542),FeralAffinity=v15(199216 - (1668 + 58), nil, 812 - (512 + 114)),Flourish=v15(515487 - 317766, nil, 386 - 199),IronBark=v15(356114 - 253772, nil, 88 + 100),NaturesSwiftness=v15(24739 + 107419, nil, 165 + 24),Reforestation=v15(1323403 - 931047, nil, 2184 - (109 + 1885)),SoulOfTheForest=v15(159947 - (1269 + 200), nil, 365 - 174),Tranquility=v15(1555 - (98 + 717), nil, 1018 - (802 + 24)),UnbridledSwarm=v15(675932 - 283981, nil, 243 - 50),Undergrowth=v15(57936 + 334365, nil, 150 + 44),AdaptiveSwarmHeal=v15(64370 + 327521, nil, 43 + 152),IncarnationBuff=v15(327375 - 209696, nil, 653 - 457),SoulOfTheForestBuff=v15(40813 + 73295, nil, 81 + 116),AdaptiveSwarmDebuff=v15(323254 + 68635, nil, 144 + 54),GroveGuardians=v15(47946 + 54747, nil, 1642 - (797 + 636))});
	if (((22591 - 17938) > (4693 - (1427 + 192))) and not v17.Druid) then
		v17.Druid = {};
	end
	v17.Druid.Commons = {RefreshingHealingPotion=v17(66312 + 125068),Healthstone=v17(12797 - 7285),Djaruun=v17(182083 + 20486),MirrorofFracturedTomorrows=v17(94073 + 113508, {(1289 - (316 + 960)),(11 + 3)}),AshesoftheEmbersoul=v17(191487 + 15680, {(564 - (83 + 468)),(65 - 51)}),BandolierofTwistedBlades=v17(344788 - 137623, {(338 - (45 + 280)),(13 + 1)}),MydasTalisman=v17(57809 + 100510, {(3 + 10),(1925 - (340 + 1571))}),WitherbarksBranch=v17(43387 + 66612, {(35 - 22),(1962 - (1096 + 852))})};
	v17.Druid.Balance = v18(v17.Druid.Commons, {});
	v17.Druid.Feral = v18(v17.Druid.Commons, {});
	v17.Druid.Guardian = v18(v17.Druid.Commons, {});
	v17.Druid.Restoration = v18(v17.Druid.Commons, {});
	if (((166 + 204) >= (279 - 83)) and not v20.Druid) then
		v20.Druid = {};
	end
	v20.Druid.Commons = {InnervatePlayer=v20(40 + 1),MarkOfTheWildPlayer=v20(554 - (409 + 103)),MoonfireMouseover=v20(279 - (46 + 190)),RakeMouseover=v20(139 - (51 + 44)),RipMouseover=v20(13 + 32),RebirthMouseover=v20(1363 - (1114 + 203)),ReviveMouseover=v20(773 - (228 + 498)),RegrowthMouseover=v20(3 + 7),RejuvenationFocus=v20(7 + 5),RejuvenationMouseover=v20(676 - (174 + 489)),SunfireMouseover=v20(36 - 22),SwiftmendFocus=v20(1920 - (830 + 1075)),SwiftmendMouseover=v20(540 - (303 + 221)),SwiftmendPlayer=v20(1286 - (231 + 1038)),SkullBashMouseover=v20(15 + 3),WildgrowthFocus=v20(1181 - (171 + 991)),UrsolsVortexCursor=v20(82 - 62),HibernateMouseover=v20(104 - 65),RegrowthPlayer=v20(127 - 76),CancelStarlord=v20(42 + 10),Healthstone=v20(73 - 52),Djaruun=v20(63 - 41),RefreshingHealingPotion=v20(80 - 30)};
	v20.Druid.Balance = v18(v20.Druid.Commons, {StellarFlareMouseover=v20(77 - 52)});
	v20.Druid.Feral = v18(v20.Druid.Commons, {AdaptiveSwarmMouseover=v20(1274 - (111 + 1137)),PrimalWrathMouseover=v20(185 - (91 + 67)),RemoveCorruptionMouseover=v20(145 - 96),AdaptiveSwarmPlayer=v20(14 + 39)});
	v20.Druid.Guardian = v18(v20.Druid.Commons, {PulverizeMouseover=v20(551 - (423 + 100)),ThrashMouseover=v20(1 + 28)});
	v20.Druid.Restoration = v18(v20.Druid.Commons, {AdaptiveSwarmFocus=v20(83 - 53),CenarionWardFocus=v20(17 + 14),EfflorescenceCursor=v20(803 - (326 + 445)),IronBarkFocus=v20(143 - 110),LifebloomFocus=v20(75 - 41),NaturesCureFocus=v20(81 - 46),NaturesCureMouseover=v20(747 - (530 + 181)),EfflorescencePlayer=v20(918 - (614 + 267)),WildgrowthMouseover=v20(70 - (19 + 13)),GroveGuardiansFocus=v20(65 - 25),RegrowthFocus=v20(111 - 63)});
	local v36 = v15.Druid.Feral;
	local v37 = v15.Druid.Restoration;
	local v38 = v15.Druid.Balance;
	v9.AddCoreOverride("Player.AstralPowerP", function()
		local v45 = v12:AstralPower();
		if (not v12:IsCasting() or ((9049 - 5881) < (131 + 371))) then
			return v45;
		elseif (((771 - 332) == (909 - 470)) and (v12:IsCasting(v15.Druid.Balance.Wrath) or v12:IsCasting(v15.Druid.Balance.Starfire) or v12:IsCasting(v15.Druid.Balance.StellarFlare))) then
			return v45 + (1820 - (1293 + 519));
		elseif (v12:IsCasting(v15.Druid.Balance.NewMoon) or ((2578 - 1314) < (709 - 437))) then
			return v45 + (19 - 9);
		elseif (((13466 - 10343) < (9166 - 5275)) and v12:IsCasting(v15.Druid.Balance.HalfMoon)) then
			return v45 + 11 + 9;
		elseif (((805 + 3137) <= (11587 - 6600)) and v12:IsCasting(v15.Druid.Balance.FullMoon)) then
			return v45 + 10 + 30;
		else
			return v45;
		end
	end, 34 + 68);
	v9.AddCoreOverride("Spell.EnergizeAmount", function(v46)
		local v47 = 0 + 0;
		local v48;
		while true do
			if (((5680 - (709 + 387)) == (6442 - (673 + 1185))) and (v47 == (0 - 0))) then
				v48 = 0 - 0;
				if (((6546 - 2567) >= (1194 + 474)) and (v46 == v38.StellarFlare)) then
					v48 = 9 + 3;
				elseif (((766 - 198) > (106 + 322)) and (v46 == v38.AstralCommunion)) then
					v48 = 119 - 59;
				elseif (((2618 - 1284) <= (6493 - (446 + 1434))) and (v46 == v38.ForceofNature)) then
					v48 = 1303 - (1040 + 243);
				elseif ((v46 == v38.Sunfire) or ((5566 - 3701) >= (3876 - (559 + 1288)))) then
					v48 = 1939 - (609 + 1322);
				elseif (((5404 - (13 + 441)) >= (6038 - 4422)) and (v46 == v38.Moonfire)) then
					v48 = 15 - 9;
				elseif (((8591 - 6866) == (65 + 1660)) and (v46 == v38.NewMoon)) then
					v48 = 43 - 31;
				elseif (((519 + 940) <= (1088 + 1394)) and (v46 == v38.HalfMoon)) then
					v48 = 71 - 47;
				elseif ((v46 == v38.FullMoon) or ((1476 + 1220) >= (8334 - 3802))) then
					v48 = 34 + 16;
				end
				v47 = 1 + 0;
			end
			if (((753 + 295) >= (44 + 8)) and (v47 == (1 + 0))) then
				return v48;
			end
		end
	end, 535 - (153 + 280));
	local v39;
	v39 = v9.AddCoreOverride("Spell.IsCastable", function(v49, v50, v51, v52, v53, v54)
		local v55 = 0 - 0;
		local v56;
		local v57;
		while true do
			if (((2656 + 302) < (1778 + 2725)) and (v55 == (0 + 0))) then
				v56 = true;
				if (v51 or ((2482 + 253) == (949 + 360))) then
					local v85 = 0 - 0;
					local v86;
					while true do
						if ((v85 == (0 + 0)) or ((4797 - (89 + 578)) <= (2111 + 844))) then
							v86 = v53 or v13;
							v56 = v86:IsInRange(v51, v52);
							break;
						end
					end
				end
				v55 = 1 - 0;
			end
			if ((v55 == (1050 - (572 + 477))) or ((265 + 1699) <= (805 + 535))) then
				v57 = v39(v49, v50, v51, v52, v53, v54);
				if (((299 + 2200) == (2585 - (84 + 2))) and (v49 == v15.Druid.Balance.MoonkinForm)) then
					return v57 and v12:BuffDown(v49);
				elseif ((v49 == v15.Druid.Balance.StellarFlare) or ((3716 - 1461) < (16 + 6))) then
					return v57 and not v12:IsCasting(v49);
				elseif ((v49 == v15.Druid.Balance.Wrath) or (v49 == v15.Druid.Balance.Starfire) or ((1928 - (497 + 345)) >= (36 + 1369))) then
					return v57 and not (v12:IsCasting(v49) and (v49:Count() == (1 + 0)));
				elseif ((v49 == v15.Druid.Balance.WarriorofElune) or ((3702 - (605 + 728)) == (304 + 122))) then
					return v57 and v12:BuffDown(v49);
				elseif ((v49 == v15.Druid.Balance.NewMoon) or (v49 == v15.Druid.Balance.HalfMoon) or (v49 == v15.Druid.Balance.FullMoon) or ((6838 - 3762) > (146 + 3037))) then
					return v57 and not v12:IsCasting(v49);
				else
					return v57;
				end
				break;
			end
		end
	end, 377 - 275);
	local v40;
	v40 = v9.AddCoreOverride("Spell.IsCastable", function(v58, v59, v60, v61, v62, v63)
		local v64 = v40(v58, v59, v60, v61, v62, v63);
		if (((1084 + 118) > (2931 - 1873)) and ((v58 == v15.Druid.Feral.CatForm) or (v58 == v15.Druid.Feral.MoonkinForm))) then
			return v64 and v12:BuffDown(v58);
		elseif (((2802 + 909) > (3844 - (457 + 32))) and (v58 == v15.Druid.Feral.Prowl)) then
			return v64 and v58:IsUsable() and not v12:StealthUp(true, true);
		else
			return v64;
		end
	end, 44 + 59);
	local v41;
	v41 = v9.AddCoreOverride("Spell.IsCastable", function(v65, v66, v67, v68, v69, v70)
		local v71 = 1402 - (832 + 570);
		local v72;
		while true do
			if ((v71 == (0 + 0)) or ((237 + 669) >= (7887 - 5658))) then
				v72 = v41(v65, v66, v67, v68, v69, v70);
				if (((621 + 667) > (2047 - (588 + 208))) and ((v65 == v15.Druid.Restoration.CatForm) or (v65 == v15.Druid.Restoration.MoonkinForm))) then
					return v72 and v12:BuffDown(v65);
				else
					return v72;
				end
				break;
			end
		end
	end, 282 - 177);
	v9.Druid = {};
	v9.Druid.FullMoonLastCast = nil;
	v9.Druid.OrbitBreakerStacks = 1800 - (884 + 916);
	v9:RegisterForSelfCombatEvent(function(v73, v74, v74, v74, v74, v74, v74, v74, v74, v74, v74, v75)
		if ((v75 == (423943 - 221446)) or ((2617 + 1896) < (4005 - (232 + 421)))) then
			v9.Druid.OrbitBreakerStacks = v9.Druid.OrbitBreakerStacks + (1890 - (1569 + 320));
		end
		if ((v75 == (67294 + 206989)) or ((393 + 1672) >= (10769 - 7573))) then
			if (not v15.Druid.Balance.NewMoon:IsAvailable() or (v15.Druid.Balance.NewMoon:IsAvailable() and ((v9.Druid.FullMoonLastCast == nil) or ((v73 - v9.Druid.FullMoonLastCast) > (606.5 - (316 + 289))))) or ((11455 - 7079) <= (69 + 1412))) then
				v9.Druid.OrbitBreakerStacks = 1453 - (666 + 787);
			end
		end
	end, "SPELL_DAMAGE");
	v9:RegisterForSelfCombatEvent(function(v76, v77, v77, v77, v77, v77, v77, v77, v77, v77, v77, v78)
		if ((v78 == (274708 - (360 + 65))) or ((3171 + 221) >= (4995 - (79 + 175)))) then
			v9.Druid.FullMoonLastCast = v76;
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v0["Epix_Druid_Druid.lua"]();

