local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1055 - (87 + 968);
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((2789 + 285) == (1145 - 638))) then
			v6 = v0[v4];
			if (not v6 or ((1783 - (447 + 966)) > (8642 - 5485))) then
				return v1(v4, ...);
			end
			v5 = 1818 - (1703 + 114);
		end
		if (((1003 - (376 + 325)) <= (821 - 319)) and (v5 == (2 - 1))) then
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
	if (not v16.Druid or ((1377 + 3440) < (9107 - 4972))) then
		v16.Druid = {};
	end
	v16.Druid.Commons = {Nothing=v16(14 - (9 + 5), nil, 376 - (85 + 291)),Berserking=v16(27562 - (243 + 1022), nil, 3 - 2),Shadowmeld=v16(48660 + 10324, nil, 1182 - (1123 + 57)),Barkskin=v16(18561 + 4251, nil, 257 - (163 + 91)),BearForm=v16(7417 - (1869 + 61), nil, 2 + 2),CatForm=v16(2704 - 1936, nil, 7 - 2),FerociousBite=v16(3089 + 19479, nil, 7 - 1),MarkOfTheWild=v16(1058 + 68, nil, 1481 - (1329 + 145)),MarkoftheWildBuff=v16(2097 - (140 + 831)),Moonfire=v16(10771 - (1409 + 441), nil, 726 - (15 + 703)),Prowl=v16(2416 + 2799, nil, 447 - (262 + 176)),Rebirth=v16(22205 - (345 + 1376), nil, 698 - (198 + 490)),Regrowth=v16(39478 - 30542, nil, 26 - 15),Rejuvenation=v16(1980 - (696 + 510), nil, 24 - 12),Revive=v16(52031 - (1091 + 171), nil, 3 + 10),Shred=v16(16437 - 11216, nil, 46 - 32),Soothe=v16(3282 - (123 + 251), nil, 74 - 59),TravelForm=v16(1481 - (208 + 490), nil, 2 + 14),AstralInfluence=v16(87987 + 109537, nil, 1049 - (660 + 176)),AstralCommunion=v16(24313 + 178046, nil, 219 - (14 + 188)),ConvokeTheSpirits=v16(392203 - (534 + 141), nil, 8 + 10),FrenziedRegeneration=v16(20205 + 2637, nil, 19 + 0),HeartOfTheWild=v16(671346 - 351892, nil, 31 - 11),Innervate=v16(81811 - 52645, nil, 12 + 9),IncapacitatingRoar=v16(64 + 35, nil, 418 - (115 + 281)),ImprovedNaturesCure=v16(912685 - 520307, nil, 20 + 3),Ironfur=v16(464212 - 272131, nil, 87 - 63),NaturesVigil=v16(125841 - (550 + 317), nil, 36 - 11),Maim=v16(31723 - 9153, nil, 72 - 46),MightyBash=v16(5496 - (134 + 151), nil, 1692 - (970 + 695)),MoonkinForm=v17(394 - 187, 26848 - (582 + 1408), 685378 - 487753),PoPHealBuff=v16(497420 - 102084, nil, 105 - 77),Rake=v16(3646 - (1195 + 629), nil, 37 - 8),Renewal=v16(108479 - (187 + 54), nil, 810 - (162 + 618)),RemoveCorruption=v16(1950 + 832, nil, 21 + 10),Rip=v16(2300 - 1221, nil, 53 - 21),SkullBash=v16(8354 + 98485, nil, 1669 - (1373 + 263)),StampedingRoar=v16(78764 - (451 + 549), nil, 11 + 23),Starfire=v16(302150 - 107997, nil, 58 - 23),Starsurge=v17(1590 - (746 + 638), 29608 + 49066, 300051 - 102425),Sunfire=v16(93743 - (218 + 123), nil, 1617 - (1535 + 46)),SurvivalInstincts=v16(60944 + 392, nil, 6 + 31),Swiftmend=v16(19122 - (306 + 254), nil, 3 + 35),Swipe=v17(401 - 196, 108252 - (899 + 568), 140512 + 73259, 517288 - 303524),Typhoon=v16(133072 - (268 + 335), nil, 329 - (60 + 230)),Thrash=v17(782 - (426 + 146), 9315 + 68443, 108286 - (282 + 1174)),WildCharge=v17(1015 - (569 + 242), 48909 - 31930, 2824 + 46552, 103441 - (706 + 318)),Wildgrowth=v16(49689 - (721 + 530), nil, 1311 - (945 + 326)),UrsolsVortex=v16(256809 - 154016, nil, 37 + 4),MassEntanglement=v16(103059 - (271 + 429), nil, 39 + 3),FrenziedRegenerationBuff=v16(24342 - (1408 + 92), nil, 1129 - (461 + 625)),IronfurBuff=v16(193369 - (993 + 295), nil, 3 + 41),SuddenAmbushBuff=v16(341869 - (418 + 753), nil, 18 + 27),MoonfireDebuff=v16(16986 + 147826, nil, 14 + 32),RakeDebuff=v16(39355 + 116367, nil, 576 - (406 + 123)),SunfireDebuff=v16(166584 - (1749 + 20), nil, 12 + 36),ThrashDebuff=v17(1525 - (1249 + 73), 38114 + 68716, 193235 - (466 + 679)),Hibernate=v16(6343 - 3706, nil, 594 - 386),Pool=v16(1001810 - (106 + 1794), nil, 16 + 33)};
	v16.Druid.Balance = v19(v16.Druid.Commons, {EclipseLunar=v16(12265 + 36253, nil, 147 - 97),EclipseSolar=v16(131380 - 82863, nil, 165 - (4 + 110)),Wrath=v16(191568 - (57 + 527), nil, 1479 - (41 + 1386)),AetherialKindling=v16(327644 - (17 + 86), nil, 36 + 17),AstralCommunion=v16(893463 - 492827, nil, 156 - 102),AstralSmolder=v16(394224 - (122 + 44), nil, 95 - 40),BalanceofAllThings=v16(1307242 - 913194, nil, 46 + 10),CelestialAlignment=v17(30 + 172, 393467 - 199244, 383475 - (30 + 35)),ElunesGuidance=v16(270795 + 123196, nil, 1314 - (1043 + 214)),ForceOfNature=v16(777438 - 571802, nil, 1270 - (323 + 889)),FungalGrowth=v16(1057812 - 664813, nil, 639 - (361 + 219)),FuryOfElune=v16(203090 - (53 + 267), nil, 14 + 46),Incarnation=v17(614 - (15 + 398), 103542 - (18 + 964), 1469564 - 1079150),IncarnationTalent=v16(228119 + 165894, nil, 39 + 22),NaturesBalance=v16(203280 - (20 + 830), nil, 49 + 13),OrbitBreaker=v16(383323 - (116 + 10), nil, 5 + 58),OrbitalStrike=v16(391116 - (542 + 196), nil, 136 - 72),PowerofGoldrinn=v16(115068 + 278978, nil, 34 + 31),PrimordialArcanicPulsar=v16(141813 + 252147, nil, 173 - 107),RattleTheStars=v16(1010014 - 616060, nil, 1618 - (1126 + 425)),Solstice=v16(344052 - (118 + 287), nil, 266 - 198),SouloftheForest=v16(115228 - (118 + 1003), nil, 201 - 132),Starfall=v16(191411 - (142 + 235), nil, 317 - 247),Starlord=v16(44029 + 158316, nil, 1048 - (553 + 424)),Starweaver=v16(744923 - 350983, nil, 64 + 8),StellarFlare=v16(200725 + 1622, nil, 43 + 30),TwinMoons=v16(118864 + 160756, nil, 43 + 31),UmbralEmbrace=v16(853630 - 459870, nil, 208 - 133),UmbralIntensity=v16(857990 - 474795, nil, 23 + 53),WaningTwilight=v16(1903855 - 1509899, nil, 830 - (239 + 514)),WarriorofElune=v16(71094 + 131331, nil, 1407 - (797 + 532)),WildMushroom=v16(64485 + 24262, nil, 27 + 52),WildSurges=v16(956702 - 549812),FullMoon=v16(275485 - (373 + 829), nil, 811 - (476 + 255)),HalfMoon=v16(275412 - (369 + 761), nil, 47 + 34),NewMoon=v16(498201 - 223920, nil, 155 - 73),BOATArcaneBuff=v16(394288 - (64 + 174), nil, 12 + 71),BOATNatureBuff=v16(583561 - 189512, nil, 420 - (144 + 192)),CABuff=v16(383626 - (42 + 174), nil, 64 + 21),IncarnationBuff=v17(166 + 34, 43572 + 58988, 391918 - (363 + 1141)),PAPBuff=v16(395541 - (1183 + 397), nil, 261 - 175),RattledStarsBuff=v16(288788 + 105167, nil, 66 + 21),SolsticeBuff=v16(345623 - (1913 + 62), nil, 56 + 32),StarfallBuff=v16(505724 - 314690, nil, 2022 - (565 + 1368)),StarlordBuff=v16(1051911 - 772202, nil, 1751 - (1477 + 184)),StarweaversWarp=v16(536778 - 142836, nil, 85 + 6),StarweaversWeft=v16(394800 - (564 + 292), nil, 158 - 66),UmbralEmbraceBuff=v16(1186867 - 793104, nil, 397 - (244 + 60)),WarriorofEluneBuff=v16(155647 + 46778, nil, 570 - (41 + 435)),FungalGrowthDebuff=v16(82282 - (938 + 63), nil, 74 + 21),StellarFlareDebuff=v16(203472 - (936 + 189), nil, 32 + 64),GatheringStarstuff=v16(396025 - (1565 + 48), nil, 60 + 37),TouchTheCosmos=v16(395552 - (782 + 356), nil, 365 - (176 + 91)),BOATArcaneLegBuff=v16(885671 - 545725, nil, 145 - 46),BOATNatureLegBuff=v16(341035 - (975 + 117), nil, 1975 - (157 + 1718)),OnethsClearVisionBuff=v16(275764 + 64033, nil, 358 - 257),OnethsPerceptionBuff=v16(1161712 - 821912, nil, 1120 - (697 + 321)),TimewornDreambinderBuff=v16(926336 - 586287, nil, 217 - 114),DreamstateBuff=v16(978053 - 553805)});
	v16.Druid.Feral = v19(v16.Druid.Commons, {AdaptiveSwarm=v16(152540 + 239348, nil, 194 - 90),ApexPredatorsCraving=v16(1050519 - 658638, nil, 1332 - (322 + 905)),AshamanesGuidance=v16(392159 - (602 + 9), nil, 1295 - (449 + 740)),Berserk=v16(107823 - (826 + 46), nil, 1054 - (245 + 702)),BerserkHeartoftheLion=v16(1236093 - 844919, nil, 35 + 73),Bloodtalons=v16(321337 - (260 + 1638), nil, 549 - (382 + 58)),BrutalSlash=v16(648120 - 446092, nil, 92 + 18),CircleofLifeandDeath=v16(827341 - 427021, nil, 329 - 218),DireFixation=v16(418915 - (902 + 303), nil, 245 - 133),DoubleClawedRake=v16(943411 - 551711, nil, 10 + 103),FeralFrenzy=v16(276527 - (1121 + 569), nil, 328 - (22 + 192)),Incarnation=v16(103226 - (483 + 200), nil, 1578 - (1404 + 59)),LionsStrength=v16(1072724 - 680752, nil, 155 - 39),LunarInspiration=v16(156345 - (468 + 297), nil, 679 - (334 + 228)),LIMoonfire=v16(524921 - 369296, nil, 273 - 155),MomentofClarity=v16(428143 - 192075, nil, 34 + 85),Predator=v16(202257 - (141 + 95), nil, 118 + 2),PrimalWrath=v16(734572 - 449191, nil, 290 - 169),RampantFerocity=v16(91753 + 299956, nil, 334 - 212),RipandTear=v16(275114 + 116233, nil, 65 + 58),Sabertooth=v16(284508 - 82477, nil, 74 + 50),SouloftheForest=v16(158639 - (92 + 71), nil, 62 + 63),Swipe=v16(179537 - 72752, nil, 891 - (574 + 191)),TearOpenWounds=v16(323170 + 68615, nil, 318 - 191),ThrashingClaws=v16(207023 + 198277, nil, 977 - (254 + 595)),TigersFury=v16(5343 - (55 + 71), nil, 169 - 40),UnbridledSwarm=v16(393741 - (573 + 1217), nil, 360 - 230),WildSlashes=v16(29740 + 361124, nil, 210 - 79),FranticMomentum=v16(392814 - (714 + 225), nil, 616 - 405),ApexPredatorsCravingBuff=v16(546346 - 154464, nil, 15 + 117),BloodtalonsBuff=v16(210172 - 65020, nil, 939 - (118 + 688)),Clearcasting=v16(135748 - (25 + 23), nil, 26 + 108),OverflowingPowerBuff=v16(407075 - (927 + 959), nil, 455 - 320),PredatorRevealedBuff=v16(409200 - (16 + 716), nil, 262 - 126),PredatorySwiftnessBuff=v16(69466 - (11 + 86), nil, 333 - 196),SabertoothBuff=v16(392007 - (175 + 110), nil, 348 - 210),SuddenAmbushBuff=v16(1933313 - 1541339, nil, 1935 - (503 + 1293)),SmolderingFrenzyBuff=v16(1180660 - 757909, nil, 154 + 58),AdaptiveSwarmDebuff=v16(392950 - (810 + 251), nil, 98 + 42),AdaptiveSwarmHeal=v16(120273 + 271618, nil, 128 + 13),DireFixationDebuff=v16(418246 - (43 + 490), nil, 875 - (711 + 22)),LIMoonfireDebuff=v16(601989 - 446364, nil, 1002 - (240 + 619)),ThrashDebuff=v16(97788 + 307445, nil, 228 - 84)});
	v16.Druid.Guardian = v19(v16.Druid.Commons, {Mangle=v16(2245 + 31672, nil, 1889 - (1344 + 400)),Berserk=v16(50739 - (255 + 150), nil, 116 + 30),BristlingFur=v16(83431 + 72404, nil, 627 - 480),DreamofCenarius=v16(1201914 - 829795, nil, 1887 - (404 + 1335)),FlashingClaws=v16(393833 - (183 + 223), nil, 180 - 31),FuryofNature=v16(245618 + 125077, nil, 54 + 96),Incarnation=v16(102895 - (10 + 327), nil, 106 + 45),LayeredMane=v16(385059 - (118 + 220), nil, 51 + 101),LunarBeam=v16(204515 - (108 + 341), nil, 69 + 84),Maul=v16(28778 - 21971, nil, 1647 - (711 + 782)),Pulverize=v16(153962 - 73649, nil, 624 - (270 + 199)),RageoftheSleeper=v16(65114 + 135737, nil, 1975 - (580 + 1239)),Raze=v16(1189869 - 789615, nil, 151 + 6),ReinforcedFur=v16(14141 + 379477, nil, 69 + 89),SouloftheForest=v16(413778 - 255301, nil, 99 + 60),Swipe=v16(214938 - (645 + 522), nil, 1950 - (1010 + 780)),ThornsofIron=v16(400024 + 198, nil, 766 - 605),ToothandClaw=v16(396455 - 261167, nil, 1998 - (1045 + 791)),ViciousCycle=v16(941635 - 569636, nil, 248 - 85),VulnerableFlesh=v16(373123 - (351 + 154), nil, 1738 - (1281 + 293)),Growl=v16(7061 - (28 + 238), nil, 469 - 259),BerserkBuff=v16(51893 - (1381 + 178), nil, 155 + 10),DreamofCenariusBuff=v16(300082 + 72070, nil, 71 + 95),GalacticGuardianBuff=v16(736740 - 523032, nil, 87 + 80),GoreBuff=v16(94132 - (381 + 89), nil, 149 + 19),IncarnationBuff=v16(69359 + 33199, nil, 289 - 120),ToothandClawBuff=v16(136442 - (1074 + 82), nil, 372 - 202),ViciousCycleMaulBuff=v16(373799 - (214 + 1570), nil, 1626 - (990 + 465)),ViciousCycleMangleBuff=v16(153362 + 218657, nil, 75 + 97),ToothandClawDebuff=v16(131865 + 3736, nil, 680 - 507)});
	v16.Druid.Restoration = v19(v16.Druid.Commons, {EclipseLunar=v16(50244 - (1668 + 58), nil, 800 - (512 + 114)),EclipseSolar=v16(126490 - 77973, nil, 361 - 186),Efflorescence=v16(505263 - 360058, nil, 82 + 94),Lifebloom=v17(38 + 161, 29352 + 4411, 635973 - 447423),NaturesCure=v16(90417 - (109 + 1885), nil, 1646 - (1269 + 200)),Revitalize=v16(406418 - 194378, nil, 993 - (98 + 717)),Starfire=v16(198454 - (802 + 24), nil, 308 - 129),Starsurge=v16(249592 - 51966, nil, 27 + 153),Wrath=v16(3977 + 1199, nil, 30 + 151),Abundance=v16(44734 + 162649, nil, 506 - 324),AdaptiveSwarm=v16(1306852 - 914964, nil, 66 + 117),BalanceAffinity=v16(80449 + 117183, nil, 152 + 32),CenarionWard=v16(74423 + 27928, nil, 87 + 98),FeralAffinity=v16(198923 - (797 + 636), nil, 903 - 717),Flourish=v16(199340 - (1427 + 192), nil, 65 + 122),IronBark=v16(237614 - 135272, nil, 169 + 19),NaturesSwiftness=v16(59892 + 72266, nil, 515 - (192 + 134)),Reforestation=v16(393632 - (316 + 960), nil, 106 + 84),SoulOfTheForest=v16(122300 + 36178, nil, 177 + 14),Tranquility=v16(2829 - 2089, nil, 743 - (83 + 468)),UnbridledSwarm=v16(393757 - (1202 + 604), nil, 900 - 707),Undergrowth=v16(652914 - 260613, nil, 537 - 343),AdaptiveSwarmHeal=v16(392216 - (45 + 280), nil, 189 + 6),IncarnationBuff=v16(102813 + 14866, nil, 72 + 124),SoulOfTheForestBuff=v16(63144 + 50964, nil, 35 + 162),AdaptiveSwarmDebuff=v16(725689 - 333800, nil, 2109 - (340 + 1571)),GroveGuardians=v16(40505 + 62188, nil, 1981 - (1733 + 39))});
	if (((747 - 475) == (1306 - (125 + 909))) and not v18.Druid) then
		v18.Druid = {};
	end
	v18.Druid.Commons = {RefreshingHealingPotion=v18(193328 - (1096 + 852)),DreamwalkersHealingPotion=v18(92866 + 114157),Healthstone=v18(7871 - 2359),AlgetharPuzzleBox=v18(187877 + 5824, {(249 - (46 + 190)),(4 + 10)}),AshesoftheEmbersoul=v18(208484 - (1114 + 203), {(3 + 10),(677 - (174 + 489))}),BandolierofTwistedBlades=v18(539725 - 332560, {(537 - (303 + 221)),(12 + 2)}),BeacontotheBeyond=v18(205125 - (171 + 991), {(34 - 21),(12 + 2)}),FyrakksTaintedRageheart=v18(726218 - 519044, {(20 - 7),(1262 - (111 + 1137))}),IrideusFragment=v18(193901 - (91 + 67), {(4 + 9),(1 + 13)}),ManicGrieftorch=v18(538010 - 343702, {(784 - (326 + 445)),(31 - 17)}),MirrorofFracturedTomorrows=v18(484541 - 276960, {(894 - (614 + 267)),(22 - 8)}),MydasTalisman=v18(368936 - 210617, {(4 + 9),(28 - 14)}),SpoilsofNeltharus=v18(195585 - (1293 + 519), {(33 - 20),(60 - 46)}),WitherbarksBranch=v18(259128 - 149129, {(3 + 10),(4 + 10)}),Djaruun=v18(67295 + 135274, {(1112 - (709 + 387))}),Jotungeirr=v18(188262 - (673 + 1185), {(51 - 35)})};
	v18.Druid.Balance = v19(v18.Druid.Commons, {});
	v18.Druid.Feral = v19(v18.Druid.Commons, {});
	v18.Druid.Guardian = v19(v18.Druid.Commons, {});
	v18.Druid.Restoration = v19(v18.Druid.Commons, {});
	if (((164 - 64) <= (2234 + 889)) and not v21.Druid) then
		v21.Druid = {};
	end
	v21.Druid.Commons = {InnervatePlayer=v21(31 + 10),MarkOfTheWildPlayer=v21(56 - 14),MoonfireMouseover=v21(11 + 32),RakeMouseover=v21(87 - 43),RipMouseover=v21(87 - 42),RebirthMouseover=v21(1926 - (446 + 1434)),ReviveMouseover=v21(1330 - (1040 + 243)),RegrowthMouseover=v21(29 - 19),RejuvenationFocus=v21(1859 - (559 + 1288)),RejuvenationMouseover=v21(1944 - (609 + 1322)),SunfireMouseover=v21(468 - (13 + 441)),SwiftmendFocus=v21(55 - 40),SwiftmendMouseover=v21(41 - 25),SwiftmendPlayer=v21(84 - 67),SkullBashMouseover=v21(1 + 17),WildgrowthFocus=v21(68 - 49),UrsolsVortexCursor=v21(8 + 12),HibernateMouseover=v21(18 + 21),RegrowthPlayer=v21(151 - 100),CancelStarlord=v21(29 + 23),Healthstone=v21(38 - 17),Djaruun=v21(15 + 7),RefreshingHealingPotion=v21(28 + 22)};
	v21.Druid.Balance = v19(v21.Druid.Commons, {StellarFlareMouseover=v21(18 + 7)});
	v21.Druid.Feral = v19(v21.Druid.Commons, {AdaptiveSwarmMouseover=v21(22 + 4),PrimalWrathMouseover=v21(27 + 0),RemoveCorruptionMouseover=v21(482 - (153 + 280)),AdaptiveSwarmPlayer=v21(152 - 99)});
	v21.Druid.Guardian = v19(v21.Druid.Commons, {PulverizeMouseover=v21(26 + 2),ThrashMouseover=v21(12 + 17)});
	v21.Druid.Restoration = v19(v21.Druid.Commons, {AdaptiveSwarmFocus=v21(16 + 14),CenarionWardFocus=v21(29 + 2),EfflorescenceCursor=v21(24 + 8),IronBarkFocus=v21(50 - 17),LifebloomFocus=v21(22 + 12),NaturesCureFocus=v21(702 - (89 + 578)),NaturesCureMouseover=v21(26 + 10),EfflorescencePlayer=v21(76 - 39),WildgrowthMouseover=v21(1087 - (572 + 477)),GroveGuardiansFocus=v21(6 + 34),RegrowthFocus=v21(29 + 19)});
	local v37 = v16.Druid.Feral;
	local v38 = v16.Druid.Restoration;
	local v39 = v16.Druid.Balance;
	v10.AddCoreOverride("Player.AstralPowerP", function()
		local v46 = 0 + 0;
		local v47;
		while true do
			if ((v46 == (86 - (84 + 2))) or ((2255 - 886) > (3593 + 1394))) then
				v47 = v13:AstralPower();
				if (not v13:IsCasting() or ((1705 - (497 + 345)) >= (118 + 4466))) then
					return v47;
				elseif (v13:IsCasting(v16.Druid.Balance.Wrath) or v13:IsCasting(v16.Druid.Balance.Starfire) or v13:IsCasting(v16.Druid.Balance.StellarFlare) or ((123 + 601) >= (3001 - (605 + 728)))) then
					return v47 + 6 + 2;
				elseif (((951 - 523) < (83 + 1721)) and v13:IsCasting(v16.Druid.Balance.NewMoon)) then
					return v47 + (36 - 26);
				elseif (v13:IsCasting(v16.Druid.Balance.HalfMoon) or ((2998 + 327) > (12780 - 8167))) then
					return v47 + 16 + 4;
				elseif (v13:IsCasting(v16.Druid.Balance.FullMoon) or ((5439 - (457 + 32)) <= (1932 + 2621))) then
					return v47 + (1442 - (832 + 570));
				else
					return v47;
				end
				break;
			end
		end
	end, 97 + 5);
	v10.AddCoreOverride("Spell.EnergizeAmount", function(v48)
		local v49 = 0 + 0;
		local v50;
		while true do
			if (((9430 - 6765) <= (1895 + 2038)) and ((797 - (588 + 208)) == v49)) then
				return v50;
			end
			if (((8821 - 5548) == (5073 - (884 + 916))) and (v49 == (0 - 0))) then
				v50 = 0 + 0;
				if (((4477 - (232 + 421)) > (2298 - (1569 + 320))) and (v48 == v39.StellarFlare)) then
					v50 = 3 + 9;
				elseif (((397 + 1690) == (7032 - 4945)) and (v48 == v39.AstralCommunion)) then
					v50 = 665 - (316 + 289);
				elseif ((v48 == v39.ForceofNature) or ((8910 - 5506) > (208 + 4295))) then
					v50 = 1473 - (666 + 787);
				elseif ((v48 == v39.Sunfire) or ((3931 - (360 + 65)) <= (1224 + 85))) then
					v50 = 262 - (79 + 175);
				elseif (((4659 - 1704) == (2306 + 649)) and (v48 == v39.Moonfire)) then
					v50 = 17 - 11;
				elseif ((v48 == v39.NewMoon) or ((5590 - 2687) == (2394 - (503 + 396)))) then
					v50 = 193 - (92 + 89);
				elseif (((8818 - 4272) >= (1167 + 1108)) and (v48 == v39.HalfMoon)) then
					v50 = 15 + 9;
				elseif (((3207 - 2388) >= (4 + 18)) and (v48 == v39.FullMoon)) then
					v50 = 114 - 64;
				end
				v49 = 1 + 0;
			end
		end
	end, 49 + 53);
	local v40;
	v40 = v10.AddCoreOverride("Spell.IsCastable", function(v51, v52, v53, v54, v55, v56)
		local v57 = 0 - 0;
		local v58;
		local v59;
		while true do
			if (((395 + 2767) == (4821 - 1659)) and (v57 == (1245 - (485 + 759)))) then
				v59 = v40(v51, v52, v53, v54, v55, v56);
				if ((v51 == v16.Druid.Balance.MoonkinForm) or ((5481 - 3112) > (5618 - (442 + 747)))) then
					return v59 and v13:BuffDown(v51);
				elseif (((5230 - (832 + 303)) >= (4129 - (88 + 858))) and (v51 == v16.Druid.Balance.StellarFlare)) then
					return v59 and not v13:IsCasting(v51);
				elseif ((v51 == v16.Druid.Balance.Wrath) or (v51 == v16.Druid.Balance.Starfire) or ((1132 + 2579) < (835 + 173))) then
					return v59 and not (v13:IsCasting(v51) and (v51:Count() == (1 + 0)));
				elseif ((v51 == v16.Druid.Balance.WarriorofElune) or ((1838 - (766 + 23)) <= (4472 - 3566))) then
					return v59 and v13:BuffDown(v51);
				elseif (((6171 - 1658) > (7182 - 4456)) and ((v51 == v16.Druid.Balance.NewMoon) or (v51 == v16.Druid.Balance.HalfMoon) or (v51 == v16.Druid.Balance.FullMoon))) then
					return v59 and not v13:IsCasting(v51);
				else
					return v59;
				end
				break;
			end
			if ((v57 == (0 - 0)) or ((2554 - (1036 + 37)) >= (1885 + 773))) then
				v58 = true;
				if (v53 or ((6270 - 3050) == (1073 + 291))) then
					local v88 = 1480 - (641 + 839);
					local v89;
					while true do
						if ((v88 == (913 - (910 + 3))) or ((2686 - 1632) > (5076 - (1466 + 218)))) then
							v89 = v55 or v14;
							v58 = v89:IsInRange(v53, v54);
							break;
						end
					end
				end
				v57 = 1 + 0;
			end
		end
	end, 1250 - (556 + 592));
	local v41;
	v41 = v10.AddCoreOverride("Spell.IsCastable", function(v60, v61, v62, v63, v64, v65)
		local v66 = v41(v60, v61, v62, v63, v64, v65);
		if ((v60 == v16.Druid.Feral.CatForm) or (v60 == v16.Druid.Feral.MoonkinForm) or ((241 + 435) >= (2450 - (329 + 479)))) then
			return v66 and v13:BuffDown(v60);
		elseif (((4990 - (174 + 680)) > (8236 - 5839)) and (v60 == v16.Druid.Feral.Prowl)) then
			return v66 and v60:IsUsable() and not v13:StealthUp(true, true);
		else
			return v66;
		end
	end, 212 - 109);
	local v42;
	v42 = v10.AddCoreOverride("Spell.IsCastable", function(v67, v68, v69, v70, v71, v72)
		local v73 = 0 + 0;
		local v74;
		while true do
			if ((v73 == (739 - (396 + 343))) or ((384 + 3950) == (5722 - (29 + 1448)))) then
				v74 = v42(v67, v68, v69, v70, v71, v72);
				if ((v67 == v16.Druid.Restoration.CatForm) or (v67 == v16.Druid.Restoration.MoonkinForm) or ((5665 - (135 + 1254)) <= (11418 - 8387))) then
					return v74 and v13:BuffDown(v67);
				else
					return v74;
				end
				break;
			end
		end
	end, 490 - 385);
	v10.Druid = {};
	v10.Druid.FullMoonLastCast = nil;
	v10.Druid.OrbitBreakerStacks = 0 + 0;
	v10:RegisterForSelfCombatEvent(function(v75, v76, v76, v76, v76, v76, v76, v76, v76, v76, v76, v77)
		if ((v77 == (204024 - (389 + 1138))) or ((5356 - (102 + 472)) <= (1132 + 67))) then
			v10.Druid.OrbitBreakerStacks = v10.Druid.OrbitBreakerStacks + 1 + 0;
		end
		if ((v77 == (255750 + 18533)) or ((6409 - (320 + 1225)) < (3385 - 1483))) then
			if (((2961 + 1878) >= (5164 - (157 + 1307))) and (not v16.Druid.Balance.NewMoon:IsAvailable() or (v16.Druid.Balance.NewMoon:IsAvailable() and ((v10.Druid.FullMoonLastCast == nil) or ((v75 - v10.Druid.FullMoonLastCast) > (1860.5 - (821 + 1038))))))) then
				v10.Druid.OrbitBreakerStacks = 0 - 0;
			end
		end
	end, "SPELL_DAMAGE");
	v10:RegisterForSelfCombatEvent(function(v78, v79, v79, v79, v79, v79, v79, v79, v79, v79, v79, v80)
		if ((v80 == (29997 + 244286)) or ((1909 - 834) > (714 + 1204))) then
			v10.Druid.FullMoonLastCast = v78;
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v0["Epix_Druid_Druid.lua"]();

