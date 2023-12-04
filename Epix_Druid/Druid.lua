local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((574 - 272) <= (2211 - (71 + 1638))) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((1568 + 3249) < (19547 - 15412))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((182 + 90) == (746 - 474)) and (v5 == (1 + 0))) then
			return v6(...);
		end
	end
end
v0["Epix_Druid_Druid.lua"] = function(...)
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
	if (((1230 - (87 + 1043)) <= (3571 - (10 + 438))) and not v16.Druid) then
		v16.Druid = {};
	end
	v16.Druid.Commons = {Nothing=v16(0 + 0, nil, 0 - 0),Berserking=v16(21695 + 4602, nil, 1181 - (1123 + 57)),Shadowmeld=v16(47992 + 10992, nil, 256 - (163 + 91)),Barkskin=v16(24742 - (1869 + 61), nil, 1 + 2),BearForm=v16(19325 - 13838, nil, 5 - 1),CatForm=v16(106 + 662, nil, 6 - 1),FerociousBite=v16(21198 + 1370, nil, 1480 - (1329 + 145)),MarkOfTheWild=v16(2097 - (140 + 831), nil, 1857 - (1409 + 441)),MarkoftheWildBuff=v16(1844 - (15 + 703)),Moonfire=v16(4132 + 4789, nil, 446 - (262 + 176)),Prowl=v16(6936 - (345 + 1376), nil, 697 - (198 + 490)),Rebirth=v16(90497 - 70013, nil, 23 - 13),Regrowth=v16(10142 - (696 + 510), nil, 22 - 11),Rejuvenation=v16(2036 - (1091 + 171), nil, 2 + 10),Revive=v16(159837 - 109068, nil, 43 - 30),Shred=v16(5595 - (123 + 251), nil, 69 - 55),Soothe=v16(3606 - (208 + 490), nil, 2 + 13),TravelForm=v16(349 + 434, nil, 852 - (660 + 176)),AstralInfluence=v16(23732 + 173792, nil, 415 - (14 + 188)),AstralCommunion=v16(203034 - (534 + 141), nil, 7 + 10),ConvokeTheSpirits=v16(346323 + 45205, nil, 18 + 0),FrenziedRegeneration=v16(48003 - 25161, nil, 29 - 10),HeartOfTheWild=v16(896082 - 576628, nil, 11 + 9),Innervate=v16(18571 + 10595, nil, 417 - (115 + 281)),IncapacitatingRoar=v16(230 - 131, nil, 19 + 3),ImprovedNaturesCure=v16(948281 - 555903, nil, 84 - 61),Ironfur=v16(192948 - (550 + 317), nil, 33 - 9),NaturesVigil=v16(175659 - 50685, nil, 69 - 44),Maim=v16(22855 - (134 + 151), nil, 1691 - (970 + 695)),MightyBash=v16(9943 - 4732, nil, 2017 - (582 + 1408)),MoonkinForm=v17(717 - 510, 31276 - 6418, 744721 - 547096),PoPHealBuff=v16(397160 - (1195 + 629), nil, 36 - 8),Rake=v16(2063 - (187 + 54), nil, 809 - (162 + 618)),Renewal=v16(75843 + 32395, nil, 20 + 10),RemoveCorruption=v16(5932 - 3150, nil, 51 - 20),Rip=v16(85 + 994, nil, 1668 - (1373 + 263)),SkullBash=v16(107839 - (451 + 549), nil, 11 + 22),StampedingRoar=v16(121019 - 43255, nil, 56 - 22),Starfire=v16(195537 - (746 + 638), nil, 14 + 21),Starsurge=v17(312 - 106, 79015 - (218 + 123), 199207 - (1535 + 46)),Sunfire=v16(92805 + 597, nil, 6 + 30),SurvivalInstincts=v16(61896 - (306 + 254), nil, 3 + 34),Swiftmend=v16(36428 - 17866, nil, 1505 - (899 + 568)),Swipe=v17(135 + 70, 258409 - 151624, 214374 - (268 + 335), 214054 - (60 + 230)),Typhoon=v16(133041 - (426 + 146), nil, 5 + 34),Thrash=v17(1666 - (282 + 1174), 78569 - (569 + 242), 307733 - 200903),WildCharge=v17(12 + 192, 18003 - (706 + 318), 50627 - (721 + 530), 103688 - (945 + 326)),Wildgrowth=v16(121013 - 72575, nil, 36 + 4),UrsolsVortex=v16(103493 - (271 + 429), nil, 38 + 3),MassEntanglement=v16(103859 - (1408 + 92), nil, 1128 - (461 + 625)),FrenziedRegenerationBuff=v16(24130 - (993 + 295), nil, 3 + 40),IronfurBuff=v16(193252 - (418 + 753), nil, 17 + 27),SuddenAmbushBuff=v16(35113 + 305585, nil, 14 + 31),MoonfireDebuff=v16(41653 + 123159, nil, 575 - (406 + 123)),RakeDebuff=v16(157491 - (1749 + 20), nil, 12 + 35),SunfireDebuff=v16(166137 - (1249 + 73), nil, 18 + 30),ThrashDebuff=v17(1348 - (466 + 679), 256976 - 150146, 549413 - 357323),Hibernate=v16(4537 - (106 + 1794), nil, 66 + 142),Pool=v16(252757 + 747153, nil, 144 - 95)};
	v16.Druid.Balance = v19(v16.Druid.Commons, {EclipseLunar=v16(131383 - 82865, nil, 164 - (4 + 110)),EclipseSolar=v16(49101 - (57 + 527), nil, 1478 - (41 + 1386)),Wrath=v16(191087 - (17 + 86), nil, 36 + 16),AetherialKindling=v16(730453 - 402912, nil, 153 - 100),AstralCommunion=v16(400802 - (122 + 44), nil, 92 - 38),AstralSmolder=v16(1307275 - 913217, nil, 45 + 10),BalanceofAllThings=v16(56989 + 337059, nil, 113 - 57),CelestialAlignment=v17(267 - (30 + 35), 133492 + 60731, 384667 - (1043 + 214)),ElunesGuidance=v16(1489544 - 1095553, nil, 1269 - (323 + 889)),ForceOfNature=v16(553498 - 347862, nil, 638 - (361 + 219)),FungalGrowth=v16(393319 - (53 + 267), nil, 14 + 45),FuryOfElune=v16(203183 - (15 + 398), nil, 1042 - (18 + 964)),Incarnation=v17(756 - 555, 59379 + 43181, 245975 + 144439),IncarnationTalent=v16(394863 - (20 + 830), nil, 48 + 13),NaturesBalance=v16(202556 - (116 + 10), nil, 5 + 57),OrbitBreaker=v16(383935 - (542 + 196), nil, 134 - 71),OrbitalStrike=v16(113997 + 276381, nil, 33 + 31),PowerofGoldrinn=v16(141844 + 252202, nil, 170 - 105),PrimordialArcanicPulsar=v16(1010030 - 616070, nil, 1617 - (1126 + 425)),RattleTheStars=v16(394359 - (118 + 287), nil, 262 - 195),Solstice=v16(344768 - (118 + 1003), nil, 198 - 130),SouloftheForest=v16(114484 - (142 + 235), nil, 312 - 243),Starfall=v16(41567 + 149467, nil, 1047 - (553 + 424)),Starlord=v16(382625 - 180280, nil, 63 + 8),Starweaver=v16(390781 + 3159, nil, 42 + 30),StellarFlare=v16(86016 + 116331, nil, 42 + 31),TwinMoons=v16(606186 - 326566, nil, 206 - 132),UmbralEmbrace=v16(881645 - 487885, nil, 22 + 53),UmbralIntensity=v16(1851850 - 1468655, nil, 829 - (239 + 514)),WaningTwilight=v16(138362 + 255594, nil, 1406 - (797 + 532)),WarriorofElune=v16(147086 + 55339, nil, 27 + 51),WildMushroom=v16(208666 - 119919, nil, 1281 - (373 + 829)),WildSurges=v16(407621 - (476 + 255)),FullMoon=v16(275413 - (369 + 761), nil, 47 + 33),HalfMoon=v16(498202 - 223920, nil, 153 - 72),NewMoon=v16(274519 - (64 + 174), nil, 12 + 70),BOATArcaneBuff=v16(583563 - 189513, nil, 419 - (144 + 192)),BOATNatureBuff=v16(394265 - (42 + 174), nil, 64 + 20),CABuff=v16(317607 + 65803, nil, 37 + 48),IncarnationBuff=v17(1704 - (363 + 1141), 104140 - (1183 + 397), 1188554 - 798140),PAPBuff=v16(288792 + 105169, nil, 65 + 21),RattledStarsBuff=v16(395930 - (1913 + 62), nil, 55 + 32),SolsticeBuff=v16(909740 - 566092, nil, 2021 - (565 + 1368)),StarfallBuff=v16(718428 - 527394, nil, 1750 - (1477 + 184)),StarlordBuff=v16(381126 - 101417, nil, 84 + 6),StarweaversWarp=v16(394798 - (564 + 292), nil, 156 - 65),StarweaversWeft=v16(1187413 - 793469, nil, 396 - (244 + 60)),UmbralEmbraceBuff=v16(302769 + 90994, nil, 569 - (41 + 435)),WarriorofEluneBuff=v16(203426 - (938 + 63), nil, 73 + 21),FungalGrowthDebuff=v16(82406 - (936 + 189), nil, 32 + 63),StellarFlareDebuff=v16(203960 - (1565 + 48), nil, 60 + 36),GatheringStarstuff=v16(395550 - (782 + 356), nil, 364 - (176 + 91)),TouchTheCosmos=v16(1027578 - 633164, nil, 144 - 46),BOATArcaneLegBuff=v16(341038 - (975 + 117), nil, 1974 - (157 + 1718)),BOATNatureLegBuff=v16(275883 + 64060, nil, 354 - 254),OnethsClearVisionBuff=v16(1161702 - 821905, nil, 1119 - (697 + 321)),OnethsPerceptionBuff=v16(925658 - 585858, nil, 215 - 113),TimewornDreambinderBuff=v16(783942 - 443893, nil, 41 + 62),DreamstateBuff=v16(794894 - 370646)});
	v16.Druid.Feral = v19(v16.Druid.Commons, {AdaptiveSwarm=v16(1050538 - 658650, nil, 1331 - (322 + 905)),ApexPredatorsCraving=v16(392492 - (602 + 9), nil, 1294 - (449 + 740)),AshamanesGuidance=v16(392420 - (826 + 46), nil, 1053 - (245 + 702)),Berserk=v16(337960 - 231009, nil, 35 + 72),BerserkHeartoftheLion=v16(393072 - (260 + 1638), nil, 548 - (382 + 58)),Bloodtalons=v16(1024783 - 705344, nil, 91 + 18),BrutalSlash=v16(417531 - 215503, nil, 326 - 216),CircleofLifeandDeath=v16(401525 - (902 + 303), nil, 243 - 132),DireFixation=v16(1006056 - 588346, nil, 10 + 102),DoubleClawedRake=v16(393390 - (1121 + 569), nil, 327 - (22 + 192)),FeralFrenzy=v16(275520 - (483 + 200), nil, 1577 - (1404 + 59)),Incarnation=v16(280633 - 178090, nil, 154 - 39),LionsStrength=v16(392737 - (468 + 297), nil, 678 - (334 + 228)),LunarInspiration=v16(524769 - 369189, nil, 270 - 153),LIMoonfire=v16(282248 - 126623, nil, 34 + 84),MomentofClarity=v16(236304 - (141 + 95), nil, 117 + 2),Predator=v16(520003 - 317982, nil, 288 - 168),PrimalWrath=v16(66847 + 218534, nil, 331 - 210),RampantFerocity=v16(275368 + 116341, nil, 64 + 58),RipandTear=v16(551111 - 159764, nil, 73 + 50),Sabertooth=v16(202194 - (92 + 71), nil, 62 + 62),SouloftheForest=v16(266445 - 107969, nil, 890 - (574 + 191)),Swipe=v16(88084 + 18701, nil, 315 - 189),TearOpenWounds=v16(200120 + 191665, nil, 976 - (254 + 595)),ThrashingClaws=v16(405426 - (55 + 71), nil, 168 - 40),TigersFury=v16(7007 - (573 + 1217), nil, 357 - 228),UnbridledSwarm=v16(29823 + 362128, nil, 209 - 79),WildSlashes=v16(391803 - (714 + 225), nil, 382 - 251),FranticMomentum=v16(546337 - 154462, nil, 23 + 188),ApexPredatorsCravingBuff=v16(567424 - 175542, nil, 938 - (118 + 688)),BloodtalonsBuff=v16(145200 - (25 + 23), nil, 26 + 107),Clearcasting=v16(137586 - (927 + 959), nil, 451 - 317),OverflowingPowerBuff=v16(405921 - (16 + 716), nil, 260 - 125),PredatorRevealedBuff=v16(408565 - (11 + 86), nil, 331 - 195),PredatorySwiftnessBuff=v16(69654 - (175 + 110), nil, 345 - 208),SabertoothBuff=v16(1932070 - 1540348, nil, 1934 - (503 + 1293)),SuddenAmbushBuff=v16(1094706 - 702732, nil, 101 + 38),SmolderingFrenzyBuff=v16(423812 - (810 + 251), nil, 148 + 64),AdaptiveSwarmDebuff=v16(120272 + 271617, nil, 127 + 13),AdaptiveSwarmHeal=v16(392424 - (43 + 490), nil, 874 - (711 + 22)),DireFixationDebuff=v16(1615800 - 1198087, nil, 1001 - (240 + 619)),LIMoonfireDebuff=v16(37555 + 118070, nil, 227 - 84),ThrashDebuff=v16(26819 + 378414, nil, 1888 - (1344 + 400))});
	v16.Druid.Guardian = v19(v16.Druid.Commons, {Mangle=v16(34322 - (255 + 150), nil, 115 + 30),Berserk=v16(26948 + 23386, nil, 623 - 477),BristlingFur=v16(503334 - 347499, nil, 1886 - (404 + 1335)),DreamofCenarius=v16(372525 - (183 + 223), nil, 179 - 31),FlashingClaws=v16(260680 + 132747, nil, 54 + 95),FuryofNature=v16(371032 - (10 + 327), nil, 105 + 45),Incarnation=v16(102896 - (118 + 220), nil, 51 + 100),LayeredMane=v16(385170 - (108 + 341), nil, 69 + 83),LunarBeam=v16(862751 - 658685, nil, 1646 - (711 + 782)),Maul=v16(13048 - 6241, nil, 623 - (270 + 199)),Pulverize=v16(26037 + 54276, nil, 1974 - (580 + 1239)),RageoftheSleeper=v16(597087 - 396236, nil, 150 + 6),Raze=v16(14379 + 385875, nil, 69 + 88),ReinforcedFur=v16(1027724 - 634106, nil, 99 + 59),SouloftheForest=v16(159644 - (645 + 522), nil, 1949 - (1010 + 780)),Swipe=v16(213666 + 105, nil, 762 - 602),ThornsofIron=v16(1172833 - 772611, nil, 1997 - (1045 + 791)),ToothandClaw=v16(342452 - 207164, nil, 246 - 84),ViciousCycle=v16(372504 - (351 + 154), nil, 1737 - (1281 + 293)),VulnerableFlesh=v16(372884 - (28 + 238), nil, 366 - 202),Growl=v16(8354 - (1381 + 178), nil, 197 + 13),BerserkBuff=v16(40587 + 9747, nil, 71 + 94),DreamofCenariusBuff=v16(1282963 - 910811, nil, 86 + 80),GalacticGuardianBuff=v16(214178 - (381 + 89), nil, 149 + 18),GoreBuff=v16(63343 + 30319, nil, 287 - 119),IncarnationBuff=v16(103714 - (1074 + 82), nil, 370 - 201),ToothandClawBuff=v16(137070 - (214 + 1570), nil, 1625 - (990 + 465)),ViciousCycleMaulBuff=v16(153361 + 218654, nil, 75 + 96),ViciousCycleMangleBuff=v16(361770 + 10249, nil, 676 - 504),ToothandClawDebuff=v16(137327 - (1668 + 58), nil, 799 - (512 + 114))});
	v16.Druid.Restoration = v19(v16.Druid.Commons, {EclipseLunar=v16(126493 - 77975, nil, 359 - 185),EclipseSolar=v16(168822 - 120305, nil, 82 + 93),Efflorescence=v16(27182 + 118023, nil, 154 + 22),Lifebloom=v17(671 - 472, 35757 - (109 + 1885), 190019 - (1269 + 200)),NaturesCure=v16(169480 - 81057, nil, 992 - (98 + 717)),Revitalize=v16(212866 - (802 + 24), nil, 306 - 128),Starfire=v16(249594 - 51966, nil, 27 + 152),Starsurge=v16(151841 + 45785, nil, 30 + 150),Wrath=v16(1117 + 4059, nil, 503 - 322),Abundance=v16(691572 - 484189, nil, 66 + 116),AdaptiveSwarm=v16(159523 + 232365, nil, 151 + 32),BalanceAffinity=v16(143705 + 53927, nil, 86 + 98),CenarionWard=v16(103784 - (797 + 636), nil, 898 - 713),FeralAffinity=v16(199109 - (1427 + 192), nil, 65 + 121),Flourish=v16(459063 - 261342, nil, 169 + 18),IronBark=v16(46380 + 55962, nil, 514 - (192 + 134)),NaturesSwiftness=v16(133434 - (316 + 960), nil, 106 + 83),Reforestation=v16(302788 + 89568, nil, 176 + 14),SoulOfTheForest=v16(605862 - 447384, nil, 742 - (83 + 468)),Tranquility=v16(2546 - (1202 + 604), nil, 896 - 704),UnbridledSwarm=v16(652332 - 260381, nil, 534 - 341),Undergrowth=v16(392626 - (45 + 280), nil, 188 + 6),AdaptiveSwarmHeal=v16(342383 + 49508, nil, 72 + 123),IncarnationBuff=v16(65120 + 52559, nil, 35 + 161),SoulOfTheForestBuff=v16(211301 - 97193, nil, 2108 - (340 + 1571)),AdaptiveSwarmDebuff=v16(154571 + 237318, nil, 1970 - (1733 + 39)),GroveGuardians=v16(282189 - 179496, nil, 1243 - (125 + 909))});
	if (not v18.Druid or ((3317 - (1096 + 852)) > (2238 + 2749))) then
		v18.Druid = {};
	end
	v18.Druid.Commons = {RefreshingHealingPotion=v18(273311 - 81931),Healthstone=v18(5347 + 165),Djaruun=v18(203081 - (409 + 103)),MirrorofFracturedTomorrows=v18(207817 - (46 + 190), {(4 + 9),(740 - (228 + 498))}),AshesoftheEmbersoul=v18(44884 + 162283, {(676 - (174 + 489)),(1919 - (830 + 1075))}),BandolierofTwistedBlades=v18(207689 - (303 + 221), {(11 + 2),(57 - 43)}),MydasTalisman=v18(425118 - 266799, {(11 + 2),(40 - 26)}),WitherbarksBranch=v18(177314 - 67315, {(1261 - (111 + 1137)),(41 - 27)})};
	v18.Druid.Balance = v19(v18.Druid.Commons, {});
	v18.Druid.Feral = v19(v18.Druid.Commons, {});
	v18.Druid.Guardian = v19(v18.Druid.Commons, {});
	v18.Druid.Restoration = v19(v18.Druid.Commons, {});
	if (not v21.Druid or ((216 + 647) >= (5107 - (423 + 100)))) then
		v21.Druid = {};
	end
	v21.Druid.Commons = {InnervatePlayer=v21(1 + 40),MarkOfTheWildPlayer=v21(115 - 73),MoonfireMouseover=v21(23 + 20),RakeMouseover=v21(815 - (326 + 445)),RipMouseover=v21(196 - 151),RebirthMouseover=v21(101 - 55),ReviveMouseover=v21(109 - 62),RegrowthMouseover=v21(721 - (530 + 181)),RejuvenationFocus=v21(893 - (614 + 267)),RejuvenationMouseover=v21(45 - (19 + 13)),SunfireMouseover=v21(22 - 8),SwiftmendFocus=v21(34 - 19),SwiftmendMouseover=v21(45 - 29),SwiftmendPlayer=v21(5 + 12),SkullBashMouseover=v21(31 - 13),WildgrowthFocus=v21(38 - 19),UrsolsVortexCursor=v21(1832 - (1293 + 519)),HibernateMouseover=v21(79 - 40),RegrowthPlayer=v21(133 - 82),CancelStarlord=v21(99 - 47),Healthstone=v21(90 - 69),Djaruun=v21(51 - 29),RefreshingHealingPotion=v21(27 + 23)};
	v21.Druid.Balance = v19(v21.Druid.Commons, {StellarFlareMouseover=v21(6 + 19)});
	v21.Druid.Feral = v19(v21.Druid.Commons, {AdaptiveSwarmMouseover=v21(59 - 33),PrimalWrathMouseover=v21(7 + 20),RemoveCorruptionMouseover=v21(17 + 32),AdaptiveSwarmPlayer=v21(34 + 19)});
	v21.Druid.Guardian = v19(v21.Druid.Commons, {PulverizeMouseover=v21(1124 - (709 + 387)),ThrashMouseover=v21(1887 - (673 + 1185))});
	v21.Druid.Restoration = v19(v21.Druid.Commons, {AdaptiveSwarmFocus=v21(87 - 57),CenarionWardFocus=v21(99 - 68),EfflorescenceCursor=v21(51 - 19),IronBarkFocus=v21(24 + 9),LifebloomFocus=v21(26 + 8),NaturesCureFocus=v21(46 - 11),NaturesCureMouseover=v21(9 + 27),EfflorescencePlayer=v21(73 - 36),WildgrowthMouseover=v21(74 - 36),GroveGuardiansFocus=v21(1920 - (446 + 1434)),RegrowthFocus=v21(1331 - (1040 + 243))});
	local v37 = v16.Druid.Feral;
	local v38 = v16.Druid.Restoration;
	local v39 = v16.Druid.Balance;
	v10.AddCoreOverride("Player.AstralPowerP", function()
		local v46 = 0 - 0;
		local v47;
		while true do
			if ((v46 == (1847 - (559 + 1288))) or ((2655 - (609 + 1322)) >= (2122 - (13 + 441)))) then
				v47 = v13:AstralPower();
				if (((1599 - 1171) < (4725 - 2921)) and not v13:IsCasting()) then
					return v47;
				elseif (v13:IsCasting(v16.Druid.Balance.Wrath) or v13:IsCasting(v16.Druid.Balance.Starfire) or v13:IsCasting(v16.Druid.Balance.StellarFlare) or ((16559 - 13234) > (172 + 4441))) then
					return v47 + (29 - 21);
				elseif (v13:IsCasting(v16.Druid.Balance.NewMoon) or ((1759 + 3191) <= (1996 + 2557))) then
					return v47 + (29 - 19);
				elseif (((1459 + 1206) <= (7232 - 3299)) and v13:IsCasting(v16.Druid.Balance.HalfMoon)) then
					return v47 + 14 + 6;
				elseif (((1821 + 1452) == (2352 + 921)) and v13:IsCasting(v16.Druid.Balance.FullMoon)) then
					return v47 + 34 + 6;
				else
					return v47;
				end
				break;
			end
		end
	end, 100 + 2);
	v10.AddCoreOverride("Spell.EnergizeAmount", function(v48)
		local v49 = 433 - (153 + 280);
		local v50;
		while true do
			if (((11041 - 7217) > (368 + 41)) and (v49 == (1 + 0))) then
				return v50;
			end
			if (((1093 + 994) == (1894 + 193)) and (v49 == (0 + 0))) then
				v50 = 0 - 0;
				if ((v48 == v39.StellarFlare) or ((2104 + 1300) > (5170 - (89 + 578)))) then
					v50 = 9 + 3;
				elseif ((v48 == v39.AstralCommunion) or ((7288 - 3782) <= (2358 - (572 + 477)))) then
					v50 = 9 + 51;
				elseif (((1774 + 1181) == (353 + 2602)) and (v48 == v39.ForceofNature)) then
					v50 = 106 - (84 + 2);
				elseif ((v48 == v39.Sunfire) or ((4784 - 1881) == (1078 + 417))) then
					v50 = 850 - (497 + 345);
				elseif (((117 + 4429) >= (385 + 1890)) and (v48 == v39.Moonfire)) then
					v50 = 1339 - (605 + 728);
				elseif (((585 + 234) >= (48 - 26)) and (v48 == v39.NewMoon)) then
					v50 = 1 + 11;
				elseif (((11690 - 8528) == (2851 + 311)) and (v48 == v39.HalfMoon)) then
					v50 = 66 - 42;
				elseif ((v48 == v39.FullMoon) or ((1789 + 580) > (4918 - (457 + 32)))) then
					v50 = 22 + 28;
				end
				v49 = 1403 - (832 + 570);
			end
		end
	end, 97 + 5);
	local v40;
	v40 = v10.AddCoreOverride("Spell.IsCastable", function(v51, v52, v53, v54, v55, v56)
		local v57 = 0 + 0;
		local v58;
		local v59;
		while true do
			if (((14491 - 10396) >= (1534 + 1649)) and (v57 == (796 - (588 + 208)))) then
				v58 = true;
				if (v53 or ((10001 - 6290) < (2808 - (884 + 916)))) then
					local v87 = 0 - 0;
					local v88;
					while true do
						if ((v87 == (0 + 0)) or ((1702 - (232 + 421)) <= (2795 - (1569 + 320)))) then
							v88 = v55 or v14;
							v58 = v88:IsInRange(v53, v54);
							break;
						end
					end
				end
				v57 = 1 + 0;
			end
			if (((858 + 3655) > (9186 - 6460)) and (v57 == (606 - (316 + 289)))) then
				v59 = v40(v51, v52, v53, v54, v55, v56);
				if ((v51 == v16.Druid.Balance.MoonkinForm) or ((3876 - 2395) >= (123 + 2535))) then
					return v59 and v13:BuffDown(v51);
				elseif ((v51 == v16.Druid.Balance.StellarFlare) or ((4673 - (666 + 787)) == (1789 - (360 + 65)))) then
					return v59 and not v13:IsCasting(v51);
				elseif ((v51 == v16.Druid.Balance.Wrath) or (v51 == v16.Druid.Balance.Starfire) or ((986 + 68) > (3646 - (79 + 175)))) then
					return v59 and not (v13:IsCasting(v51) and (v51:Count() == (1 - 0)));
				elseif ((v51 == v16.Druid.Balance.WarriorofElune) or ((528 + 148) >= (5032 - 3390))) then
					return v59 and v13:BuffDown(v51);
				elseif (((7965 - 3829) > (3296 - (503 + 396))) and ((v51 == v16.Druid.Balance.NewMoon) or (v51 == v16.Druid.Balance.HalfMoon) or (v51 == v16.Druid.Balance.FullMoon))) then
					return v59 and not v13:IsCasting(v51);
				else
					return v59;
				end
				break;
			end
		end
	end, 283 - (92 + 89));
	local v41;
	v41 = v10.AddCoreOverride("Spell.IsCastable", function(v60, v61, v62, v63, v64, v65)
		local v66 = 0 - 0;
		local v67;
		while true do
			if ((v66 == (0 + 0)) or ((2566 + 1768) == (16624 - 12379))) then
				v67 = v41(v60, v61, v62, v63, v64, v65);
				if ((v60 == v16.Druid.Feral.CatForm) or (v60 == v16.Druid.Feral.MoonkinForm) or ((585 + 3691) <= (6910 - 3879))) then
					return v67 and v13:BuffDown(v60);
				elseif ((v60 == v16.Druid.Feral.Prowl) or ((4173 + 609) <= (573 + 626))) then
					return v67 and v60:IsUsable() and not v13:StealthUp(true, true);
				else
					return v67;
				end
				break;
			end
		end
	end, 313 - 210);
	local v42;
	v42 = v10.AddCoreOverride("Spell.IsCastable", function(v68, v69, v70, v71, v72, v73)
		local v74 = v42(v68, v69, v70, v71, v72, v73);
		if ((v68 == v16.Druid.Restoration.CatForm) or (v68 == v16.Druid.Restoration.MoonkinForm) or ((608 + 4256) < (2899 - 997))) then
			return v74 and v13:BuffDown(v68);
		else
			return v74;
		end
	end, 1349 - (485 + 759));
	v10.Druid = {};
	v10.Druid.FullMoonLastCast = nil;
	v10.Druid.OrbitBreakerStacks = 0 - 0;
	v10:RegisterForSelfCombatEvent(function(v75, v76, v76, v76, v76, v76, v76, v76, v76, v76, v76, v77)
		local v78 = 1189 - (442 + 747);
		while true do
			if (((5974 - (832 + 303)) >= (4646 - (88 + 858))) and (v78 == (0 + 0))) then
				if ((v77 == (167587 + 34910)) or ((45 + 1030) > (2707 - (766 + 23)))) then
					v10.Druid.OrbitBreakerStacks = v10.Druid.OrbitBreakerStacks + (4 - 3);
				end
				if (((540 - 144) <= (10022 - 6218)) and (v77 == (930925 - 656642))) then
					if (not v16.Druid.Balance.NewMoon:IsAvailable() or (v16.Druid.Balance.NewMoon:IsAvailable() and ((v10.Druid.FullMoonLastCast == nil) or ((v75 - v10.Druid.FullMoonLastCast) > (1074.5 - (1036 + 37))))) or ((2956 + 1213) == (4258 - 2071))) then
						v10.Druid.OrbitBreakerStacks = 0 + 0;
					end
				end
				break;
			end
		end
	end, "SPELL_DAMAGE");
	v10:RegisterForSelfCombatEvent(function(v79, v80, v80, v80, v80, v80, v80, v80, v80, v80, v80, v81)
		if (((2886 - (641 + 839)) == (2319 - (910 + 3))) and (v81 == (699228 - 424945))) then
			v10.Druid.FullMoonLastCast = v79;
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v0["Epix_Druid_Druid.lua"]();

