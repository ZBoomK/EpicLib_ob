local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (not v6 or ((13527 - 9779) < (3110 - 898))) then
		return v2(v5, v0, ...);
	end
	return v6(v0, ...);
end
v1["Epix_Druid_Druid.lua"] = function(...)
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
	if (not v16.Druid or ((4576 - 3396) == (6439 - 4259))) then
		v16.Druid = {};
	end
	v16.Druid.Commons = {Nothing=v16(0 + 0, nil, 0 - 0),Berserking=v16(103150 - 76853, nil, 1 + 0),Shadowmeld=v16(46310 + 12674, nil, 1057 - (87 + 968)),Barkskin=v16(100416 - 77604, nil, 3 + 0),BearForm=v16(12403 - 6916, nil, 1417 - (447 + 966)),CatForm=v16(2102 - 1334, nil, 1822 - (1703 + 114)),FerociousBite=v16(23269 - (376 + 325), nil, 9 - 3),MarkOfTheWild=v16(3464 - 2338, nil, 3 + 4),MarkoftheWildBuff=v16(2479 - 1353),Moonfire=v16(8935 - (9 + 5), nil, 384 - (85 + 291)),Prowl=v16(6480 - (243 + 1022), nil, 33 - 24),Rebirth=v16(16899 + 3585, nil, 1190 - (1123 + 57)),Regrowth=v16(7271 + 1665, nil, 265 - (163 + 91)),Rejuvenation=v16(2704 - (1869 + 61), nil, 4 + 8),Revive=v16(178808 - 128039, nil, 19 - 6),Shred=v16(715 + 4506, nil, 19 - 5),Soothe=v16(2732 + 176, nil, 1489 - (1329 + 145)),TravelForm=v16(1754 - (140 + 831), nil, 1866 - (1409 + 441)),AstralInfluence=v16(198242 - (15 + 703), nil, 99 + 114),AstralCommunion=v16(202797 - (262 + 176), nil, 1738 - (345 + 1376)),ConvokeTheSpirits=v16(392216 - (198 + 490), nil, 79 - 61),FrenziedRegeneration=v16(54790 - 31948, nil, 1225 - (696 + 510)),HeartOfTheWild=v16(669986 - 350532, nil, 1282 - (1091 + 171)),Innervate=v16(4694 + 24472, nil, 65 - 44),IncapacitatingRoar=v16(328 - 229, nil, 396 - (123 + 251)),ImprovedNaturesCure=v16(1949707 - 1557329, nil, 721 - (208 + 490)),Ironfur=v16(16209 + 175872, nil, 11 + 13),NaturesVigil=v16(125810 - (660 + 176), nil, 4 + 21),Maim=v16(22772 - (14 + 188), nil, 701 - (534 + 141)),MightyBash=v16(2095 + 3116, nil, 24 + 3),MoonkinForm=v17(200 + 7, 52240 - 27382, 313753 - 116128),PoPHealBuff=v16(1108935 - 713599, nil, 16 + 12),Rake=v16(1161 + 661, nil, 425 - (115 + 281)),Renewal=v16(251765 - 143527, nil, 25 + 5),RemoveCorruption=v16(6722 - 3940, nil, 113 - 82),Rip=v16(1946 - (550 + 317), nil, 45 - 13),SkullBash=v16(150169 - 43330, nil, 92 - 59),StampedingRoar=v16(78049 - (134 + 151), nil, 1699 - (970 + 695)),Starfire=v16(370489 - 176336, nil, 2025 - (582 + 1408)),Starsurge=v17(714 - 508, 98988 - 20314, 744725 - 547099),Sunfire=v16(95226 - (1195 + 629), nil, 46 - 10),SurvivalInstincts=v16(61577 - (187 + 54), nil, 817 - (162 + 618)),Swiftmend=v16(13007 + 5555, nil, 26 + 12),Swipe=v17(437 - 232, 179526 - 72741, 16715 + 197056, 215400 - (1373 + 263)),Typhoon=v16(133469 - (451 + 549), nil, 13 + 26),Thrash=v17(326 - 116, 130684 - 52926, 108214 - (746 + 638)),WildCharge=v17(77 + 127, 25778 - 8799, 49717 - (218 + 123), 103998 - (1535 + 46)),Wildgrowth=v16(48129 + 309, nil, 6 + 34),UrsolsVortex=v16(103353 - (306 + 254), nil, 3 + 38),MassEntanglement=v16(200883 - 98524, nil, 1509 - (899 + 568)),FrenziedRegenerationBuff=v16(15015 + 7827, nil, 103 - 60),IronfurBuff=v16(192684 - (268 + 335), nil, 334 - (60 + 230)),SuddenAmbushBuff=v16(341270 - (426 + 146), nil, 6 + 39),MoonfireDebuff=v16(166268 - (282 + 1174), nil, 857 - (569 + 242)),RakeDebuff=v16(448571 - 292849, nil, 3 + 44),SunfireDebuff=v16(165839 - (706 + 318), nil, 1299 - (721 + 530)),ThrashDebuff=v17(1474 - (945 + 326), 266895 - 160065, 170926 + 21164),Hibernate=v16(3337 - (271 + 429), nil, 192 + 16),Pool=v16(1001410 - (1408 + 92), nil, 1135 - (461 + 625))};
	v16.Druid.Balance = v19(v16.Druid.Commons, {EclipseLunar=v16(49806 - (993 + 295), nil, 3 + 47),EclipseSolar=v16(49688 - (418 + 753), nil, 20 + 31),Wrath=v16(19684 + 171300, nil, 16 + 36),AetherialKindling=v16(82779 + 244762, nil, 582 - (406 + 123)),AstralCommunion=v16(402405 - (1749 + 20), nil, 13 + 41),AstralSmolder=v16(395380 - (1249 + 73), nil, 20 + 35),BalanceofAllThings=v16(395193 - (466 + 679), nil, 134 - 78),CelestialAlignment=v17(577 - 375, 196123 - (106 + 1794), 121293 + 262117),ElunesGuidance=v16(99593 + 294398, nil, 168 - 111),ForceOfNature=v16(556850 - 351214, nil, 172 - (4 + 110)),FungalGrowth=v16(393583 - (57 + 527), nil, 1486 - (41 + 1386)),FuryOfElune=v16(202873 - (17 + 86), nil, 41 + 19),Incarnation=v17(447 - 246, 297008 - 194448, 390580 - (122 + 44)),IncarnationTalent=v16(680591 - 286578, nil, 202 - 141),NaturesBalance=v16(164674 + 37756, nil, 9 + 53),OrbitBreaker=v16(776301 - 393104, nil, 128 - (30 + 35)),OrbitalStrike=v16(268311 + 122067, nil, 1321 - (1043 + 214)),PowerofGoldrinn=v16(1489752 - 1095706, nil, 1277 - (323 + 889)),PrimordialArcanicPulsar=v16(1060399 - 666439, nil, 646 - (361 + 219)),RattleTheStars=v16(394274 - (53 + 267), nil, 16 + 51),Solstice=v16(344060 - (15 + 398), nil, 1050 - (18 + 964)),SouloftheForest=v16(429512 - 315405, nil, 40 + 29),Starfall=v16(120359 + 70675, nil, 920 - (20 + 830)),Starlord=v16(157949 + 44396, nil, 197 - (116 + 10)),Starweaver=v16(29100 + 364840, nil, 810 - (542 + 196)),StellarFlare=v16(433772 - 231425, nil, 22 + 51),TwinMoons=v16(142066 + 137554, nil, 27 + 47),UmbralEmbrace=v16(1037593 - 643833, nil, 192 - 117),UmbralIntensity=v16(384746 - (1126 + 425), nil, 481 - (118 + 287)),WaningTwilight=v16(1544028 - 1150072, nil, 1198 - (118 + 1003)),WarriorofElune=v16(592382 - 389957, nil, 455 - (142 + 235)),WildMushroom=v16(402602 - 313855, nil, 18 + 61),WildSurges=v16(407867 - (553 + 424)),FullMoon=v16(518656 - 244373, nil, 71 + 9),HalfMoon=v16(272083 + 2199, nil, 48 + 33),NewMoon=v16(116595 + 157686, nil, 47 + 35),BOATArcaneBuff=v16(854258 - 460208, nil, 230 - 147),BOATNatureBuff=v16(882292 - 488243, nil, 25 + 59),CABuff=v16(1852889 - 1469479, nil, 838 - (239 + 514)),IncarnationBuff=v17(71 + 129, 103889 - (797 + 532), 283681 + 106733),PAPBuff=v16(132904 + 261057, nil, 201 - 115),RattledStarsBuff=v16(395157 - (373 + 829), nil, 818 - (476 + 255)),SolsticeBuff=v16(344778 - (369 + 761), nil, 51 + 37),StarfallBuff=v16(346991 - 155957, nil, 168 - 79),StarlordBuff=v16(279947 - (64 + 174), nil, 13 + 77),StarweaversWarp=v16(583403 - 189461, nil, 427 - (144 + 192)),StarweaversWeft=v16(394160 - (42 + 174), nil, 70 + 22),UmbralEmbraceBuff=v16(326183 + 67580, nil, 40 + 53),WarriorofEluneBuff=v16(203929 - (363 + 1141), nil, 1674 - (1183 + 397)),FungalGrowthDebuff=v16(247447 - 166166, nil, 70 + 25),StellarFlareDebuff=v16(151246 + 51101, nil, 2071 - (1913 + 62)),GatheringStarstuff=v16(248393 + 146019, nil, 256 - 159),TouchTheCosmos=v16(396347 - (565 + 1368), nil, 368 - 270),BOATArcaneLegBuff=v16(341607 - (1477 + 184), nil, 134 - 35),BOATNatureLegBuff=v16(316743 + 23200, nil, 956 - (564 + 292)),OnethsClearVisionBuff=v16(586294 - 246497, nil, 304 - 203),OnethsPerceptionBuff=v16(340104 - (244 + 60), nil, 79 + 23),TimewornDreambinderBuff=v16(340525 - (41 + 435), nil, 1104 - (938 + 63)),DreamstateBuff=v16(326280 + 97968)});
	v16.Druid.Feral = v19(v16.Druid.Commons, {AdaptiveSwarm=v16(393013 - (936 + 189), nil, 35 + 69),ApexPredatorsCraving=v16(393494 - (1565 + 48), nil, 65 + 40),AshamanesGuidance=v16(392686 - (782 + 356), nil, 373 - (176 + 91)),Berserk=v16(278642 - 171691, nil, 156 - 49),BerserkHeartoftheLion=v16(392266 - (975 + 117), nil, 1983 - (157 + 1718)),Bloodtalons=v16(259243 + 60196, nil, 386 - 277),BrutalSlash=v16(690695 - 488667, nil, 1128 - (697 + 321)),CircleofLifeandDeath=v16(1090522 - 690202, nil, 235 - 124),DireFixation=v16(962981 - 545271, nil, 44 + 68),DoubleClawedRake=v16(733911 - 342211, nil, 302 - 189),FeralFrenzy=v16(276064 - (322 + 905), nil, 725 - (602 + 9)),Incarnation=v16(103732 - (449 + 740), nil, 987 - (826 + 46)),LionsStrength=v16(392919 - (245 + 702), nil, 366 - 250),LunarInspiration=v16(50015 + 105565, nil, 2015 - (260 + 1638)),LIMoonfire=v16(156065 - (382 + 58), nil, 378 - 260),MomentofClarity=v16(196163 + 39905, nil, 245 - 126),Predator=v16(600528 - 398507, nil, 1325 - (902 + 303)),PrimalWrath=v16(626594 - 341213, nil, 291 - 170),RampantFerocity=v16(33660 + 358049, nil, 1812 - (1121 + 569)),RipandTear=v16(391561 - (22 + 192), nil, 806 - (483 + 200)),Sabertooth=v16(203494 - (1404 + 59), nil, 339 - 215),SouloftheForest=v16(212996 - 54520, nil, 890 - (468 + 297)),Swipe=v16(107347 - (334 + 228), nil, 424 - 298),TearOpenWounds=v16(908122 - 516337, nil, 229 - 102),ThrashingClaws=v16(115091 + 290209, nil, 364 - (141 + 95)),TigersFury=v16(5125 + 92, nil, 331 - 202),UnbridledSwarm=v16(942216 - 550265, nil, 31 + 99),WildSlashes=v16(1070920 - 680056, nil, 93 + 38),FranticMomentum=v16(204060 + 187815, nil, 296 - 85),ApexPredatorsCravingBuff=v16(231155 + 160727, nil, 295 - (92 + 71)),BloodtalonsBuff=v16(71697 + 73455, nil, 223 - 90),Clearcasting=v16(136465 - (574 + 191), nil, 111 + 23),OverflowingPowerBuff=v16(1015121 - 609932, nil, 69 + 66),PredatorRevealedBuff=v16(409317 - (254 + 595), nil, 262 - (55 + 71)),PredatorySwiftnessBuff=v16(91385 - 22016, nil, 1927 - (573 + 1217)),SabertoothBuff=v16(1084843 - 693121, nil, 11 + 127),SuddenAmbushBuff=v16(631625 - 239651, nil, 1078 - (714 + 225)),SmolderingFrenzyBuff=v16(1235448 - 812697, nil, 294 - 82),AdaptiveSwarmDebuff=v16(42428 + 349461, nil, 202 - 62),AdaptiveSwarmHeal=v16(392697 - (118 + 688), nil, 189 - (25 + 23)),DireFixationDebuff=v16(80906 + 336807, nil, 2028 - (927 + 959)),LIMoonfireDebuff=v16(524595 - 368970, nil, 875 - (16 + 716)),ThrashDebuff=v16(782264 - 377031, nil, 241 - (11 + 86))});
	v16.Druid.Guardian = v19(v16.Druid.Commons, {Mangle=v16(82729 - 48812, nil, 430 - (175 + 110)),Berserk=v16(127082 - 76748, nil, 720 - 574),BristlingFur=v16(157631 - (503 + 1293), nil, 410 - 263),DreamofCenarius=v16(269103 + 103016, nil, 1209 - (810 + 251)),FlashingClaws=v16(273030 + 120397, nil, 46 + 103),FuryofNature=v16(334165 + 36530, nil, 683 - (43 + 490)),Incarnation=v16(103291 - (711 + 22), nil, 583 - 432),LayeredMane=v16(385580 - (240 + 619), nil, 37 + 115),LunarBeam=v16(324608 - 120542, nil, 11 + 142),Maul=v16(8551 - (1344 + 400), nil, 559 - (255 + 150)),Pulverize=v16(63261 + 17052, nil, 83 + 72),RageoftheSleeper=v16(858151 - 657300, nil, 503 - 347),Raze=v16(401993 - (404 + 1335), nil, 563 - (183 + 223)),ReinforcedFur=v16(478979 - 85361, nil, 105 + 53),SouloftheForest=v16(57033 + 101444, nil, 496 - (10 + 327)),Swipe=v16(148868 + 64903, nil, 498 - (118 + 220)),ThornsofIron=v16(133376 + 266846, nil, 610 - (108 + 341)),ToothandClaw=v16(60763 + 74525, nil, 684 - 522),ViciousCycle=v16(373492 - (711 + 782), nil, 312 - 149),VulnerableFlesh=v16(373087 - (270 + 199), nil, 54 + 110),Growl=v16(8614 - (580 + 1239), nil, 624 - 414),BerserkBuff=v16(48127 + 2207, nil, 6 + 159),DreamofCenariusBuff=v16(162119 + 210033, nil, 433 - 267),GalacticGuardianBuff=v16(132768 + 80940, nil, 1334 - (645 + 522)),GoreBuff=v16(95452 - (1010 + 780), nil, 168 + 0),IncarnationBuff=v16(488577 - 386019, nil, 495 - 326),ToothandClawBuff=v16(137122 - (1045 + 791), nil, 430 - 260),ViciousCycleMaulBuff=v16(568047 - 196032, nil, 676 - (351 + 154)),ViciousCycleMangleBuff=v16(373593 - (1281 + 293), nil, 438 - (28 + 238)),ToothandClawDebuff=v16(302996 - 167395, nil, 1732 - (1381 + 178))});
	v16.Druid.Restoration = v19(v16.Druid.Commons, {EclipseLunar=v16(45507 + 3011, nil, 141 + 33),EclipseSolar=v16(20696 + 27821, nil, 603 - 428),Efflorescence=v16(75226 + 69979, nil, 646 - (381 + 89)),Lifebloom=v17(177 + 22, 22834 + 10929, 322984 - 134434),NaturesCure=v16(89579 - (1074 + 82), nil, 387 - 210),Revitalize=v16(213824 - (214 + 1570), nil, 1633 - (990 + 465)),Starfire=v16(81471 + 116157, nil, 78 + 101),Starsurge=v16(192182 + 5444, nil, 708 - 528),Wrath=v16(6902 - (1668 + 58), nil, 807 - (512 + 114)),Abundance=v16(540677 - 333294, nil, 375 - 193),AdaptiveSwarm=v16(1363635 - 971747, nil, 86 + 97),BalanceAffinity=v16(36996 + 160636, nil, 160 + 24),CenarionWard=v16(345226 - 242875, nil, 2179 - (109 + 1885)),FeralAffinity=v16(198959 - (1269 + 200), nil, 356 - 170),Flourish=v16(198536 - (98 + 717), nil, 1013 - (802 + 24)),IronBark=v16(176491 - 74149, nil, 236 - 48),NaturesSwiftness=v16(19518 + 112640, nil, 146 + 43),Reforestation=v16(64447 + 327909, nil, 41 + 149),SoulOfTheForest=v16(440876 - 282398, nil, 636 - 445),Tranquility=v16(265 + 475, nil, 79 + 113),UnbridledSwarm=v16(323305 + 68646, nil, 141 + 52),Undergrowth=v16(183160 + 209141, nil, 1627 - (797 + 636)),AdaptiveSwarmHeal=v16(1902772 - 1510881, nil, 1814 - (1427 + 192)),IncarnationBuff=v16(40775 + 76904, nil, 454 - 258),SoulOfTheForestBuff=v16(102568 + 11540, nil, 90 + 107),AdaptiveSwarmDebuff=v16(392215 - (192 + 134), nil, 1474 - (316 + 960)),GroveGuardians=v16(57149 + 45544, nil, 162 + 47)});
	if (((3781 + 309) < (17788 - 13135)) and not v18.Druid) then
		v18.Druid = {};
	end
	v18.Druid.Commons = {RefreshingHealingPotion=v18(191931 - (83 + 468)),DreamwalkersHealingPotion=v18(208829 - (1202 + 604)),Healthstone=v18(25731 - 20219),PotionOfWitheringDreams=v18(344582 - 137541),AlgetharPuzzleBox=v18(536307 - 342606, {(13 + 0),(6 + 8)}),AshesoftheEmbersoul=v18(114640 + 92527, {(23 - 10),(6 + 8)}),BandolierofTwistedBlades=v18(208937 - (1733 + 39), {(1047 - (125 + 909)),(7 + 7)}),BeacontotheBeyond=v18(291280 - 87317, {(525 - (409 + 103)),(109 - (51 + 44))}),FyrakksTaintedRageheart=v18(58432 + 148742, {(739 - (228 + 498)),(8 + 6)}),IrideusFragment=v18(194406 - (174 + 489), {(1918 - (830 + 1075)),(1283 - (231 + 1038))}),ManicGrieftorch=v18(161919 + 32389, {(53 - 40),(34 - 20)}),MirrorofFracturedTomorrows=v18(166137 + 41444, {(37 - 24),(43 - 29)}),MydasTalisman=v18(159567 - (111 + 1137), {(38 - 25),(537 - (423 + 100))}),SpoilsofNeltharus=v18(1361 + 192412, {(7 + 6),(60 - 46)}),WitherbarksBranch=v18(245057 - 135058, {(724 - (530 + 181)),(46 - (19 + 13))}),Djaruun=v18(329703 - 127134, {(45 - 29)}),Jotungeirr=v18(48411 + 137993, {(32 - 16)})};
	v18.Druid.Balance = v19(v18.Druid.Commons, {});
	v18.Druid.Feral = v19(v18.Druid.Commons, {});
	v18.Druid.Guardian = v19(v18.Druid.Commons, {});
	v18.Druid.Restoration = v19(v18.Druid.Commons, {});
	if (not v21.Druid or ((4464 - (1293 + 519)) < (399 - 203))) then
		v21.Druid = {};
	end
	v21.Druid.Commons = {InnervatePlayer=v21(106 - 65),MarkOfTheWildPlayer=v21(80 - 38),MoonfireMouseover=v21(185 - 142),RakeMouseover=v21(103 - 59),RipMouseover=v21(24 + 21),RebirthMouseover=v21(10 + 36),ReviveMouseover=v21(109 - 62),RegrowthMouseover=v21(3 + 7),RejuvenationFocus=v21(4 + 8),RejuvenationMouseover=v21(9 + 4),SunfireMouseover=v21(1110 - (709 + 387)),SwiftmendFocus=v21(1873 - (673 + 1185)),SwiftmendMouseover=v21(46 - 30),SwiftmendPlayer=v21(54 - 37),SkullBashMouseover=v21(29 - 11),WildgrowthFocus=v21(14 + 5),UrsolsVortexCursor=v21(15 + 5),HibernateMouseover=v21(51 - 12),RegrowthPlayer=v21(13 + 38),CancelStarlord=v21(103 - 51),ForceOfNatureCusor=v21(107 - 52),Healthstone=v21(1901 - (446 + 1434)),Djaruun=v21(1305 - (1040 + 243)),RefreshingHealingPotion=v21(149 - 99)};
	v21.Druid.Balance = v19(v21.Druid.Commons, {StellarFlareMouseover=v21(1872 - (559 + 1288))});
	v21.Druid.Feral = v19(v21.Druid.Commons, {AdaptiveSwarmMouseover=v21(1957 - (609 + 1322)),PrimalWrathMouseover=v21(481 - (13 + 441)),RemoveCorruptionMouseover=v21(182 - 133),AdaptiveSwarmPlayer=v21(138 - 85)});
	v21.Druid.Guardian = v19(v21.Druid.Commons, {PulverizeMouseover=v21(139 - 111),ThrashMouseover=v21(2 + 27)});
	v21.Druid.Restoration = v19(v21.Druid.Commons, {AdaptiveSwarmFocus=v21(108 - 78),CenarionWardFocus=v21(12 + 19),EfflorescenceCursor=v21(15 + 17),IronBarkFocus=v21(97 - 64),LifebloomFocus=v21(19 + 15),NaturesCureFocus=v21(64 - 29),NaturesCureMouseover=v21(24 + 12),EfflorescencePlayer=v21(21 + 16),WildgrowthMouseover=v21(28 + 10),GroveGuardiansFocus=v21(34 + 6),RegrowthFocus=v21(47 + 1)});
	local v37 = v16.Druid.Feral;
	local v38 = v16.Druid.Restoration;
	local v39 = v16.Druid.Balance;
	v10.AddCoreOverride("Player.AstralPowerP", function()
		local v46 = v13:AstralPower();
		if (((4568 - (153 + 280)) < (13909 - 9092)) and not v13:IsCasting()) then
			return v46;
		elseif (((245 + 27) == (108 + 164)) and (v13:IsCasting(v16.Druid.Balance.Wrath) or v13:IsCasting(v16.Druid.Balance.Starfire) or v13:IsCasting(v16.Druid.Balance.StellarFlare))) then
			return v46 + 5 + 3;
		elseif (((91 + 9) <= (2263 + 860)) and v13:IsCasting(v16.Druid.Balance.NewMoon)) then
			return v46 + (15 - 5);
		elseif (v13:IsCasting(v16.Druid.Balance.HalfMoon) or ((847 + 522) > (5654 - (89 + 578)))) then
			return v46 + 15 + 5;
		elseif (v13:IsCasting(v16.Druid.Balance.FullMoon) or ((1793 - 930) >= (5633 - (572 + 477)))) then
			return v46 + 6 + 34;
		else
			return v46;
		end
	end, 62 + 40);
	v10.AddCoreOverride("Spell.EnergizeAmount", function(v47)
		local v48 = 0 + 0;
		local v49;
		while true do
			if ((v48 == (86 - (84 + 2))) or ((1192 - 468) >= (1202 + 466))) then
				v49 = 842 - (497 + 345);
				if (((11 + 417) < (305 + 1499)) and (v47 == v39.StellarFlare)) then
					v49 = 1345 - (605 + 728);
				elseif ((v47 == v39.AstralCommunion) or ((2373 + 952) > (10255 - 5642))) then
					v49 = 3 + 57;
				elseif ((v47 == v39.ForceofNature) or ((18301 - 13351) <= (4105 + 448))) then
					v49 = 55 - 35;
				elseif (((2013 + 652) <= (4422 - (457 + 32))) and (v47 == v39.Sunfire)) then
					v49 = 4 + 4;
				elseif (((4675 - (832 + 570)) == (3084 + 189)) and (v47 == v39.Moonfire)) then
					v49 = 2 + 4;
				elseif (((13532 - 9708) > (198 + 211)) and (v47 == v39.NewMoon)) then
					v49 = 808 - (588 + 208);
				elseif (((5624 - 3537) == (3887 - (884 + 916))) and (v47 == v39.HalfMoon)) then
					v49 = 49 - 25;
				elseif ((v47 == v39.FullMoon) or ((1974 + 1430) > (5156 - (232 + 421)))) then
					v49 = 1939 - (1569 + 320);
				end
				v48 = 1 + 0;
			end
			if ((v48 == (1 + 0)) or ((11814 - 8308) <= (1914 - (316 + 289)))) then
				return v49;
			end
		end
	end, 266 - 164);
	local v40;
	v40 = v10.AddCoreOverride("Spell.IsCastable", function(v50, v51, v52, v53, v54, v55)
		local v56 = true;
		if (((137 + 2818) == (4408 - (666 + 787))) and v52) then
			local v83 = 425 - (360 + 65);
			local v84;
			while true do
				if ((v83 == (0 + 0)) or ((3157 - (79 + 175)) == (2357 - 862))) then
					v84 = v54 or v14;
					v56 = v84:IsInRange(v52, v53);
					break;
				end
			end
		end
		local v57 = v40(v50, v51, v52, v53, v54, v55);
		if (((3548 + 998) >= (6973 - 4698)) and (v50 == v16.Druid.Balance.MoonkinForm)) then
			return v57 and v13:BuffDown(v50);
		elseif (((1576 - 757) >= (921 - (503 + 396))) and (v50 == v16.Druid.Balance.StellarFlare)) then
			return v57 and not v13:IsCasting(v50);
		elseif (((3343 - (92 + 89)) == (6133 - 2971)) and ((v50 == v16.Druid.Balance.Wrath) or (v50 == v16.Druid.Balance.Starfire))) then
			return v57 and not (v13:IsCasting(v50) and (v50:Count() == (1 + 0)));
		elseif ((v50 == v16.Druid.Balance.WarriorofElune) or ((1403 + 966) > (17344 - 12915))) then
			return v57 and v13:BuffDown(v50);
		elseif (((560 + 3535) >= (7257 - 4074)) and ((v50 == v16.Druid.Balance.NewMoon) or (v50 == v16.Druid.Balance.HalfMoon) or (v50 == v16.Druid.Balance.FullMoon))) then
			return v57 and not v13:IsCasting(v50);
		else
			return v57;
		end
	end, 89 + 13);
	local v41;
	v41 = v10.AddCoreOverride("Spell.IsCastable", function(v58, v59, v60, v61, v62, v63)
		local v64 = v41(v58, v59, v60, v61, v62, v63);
		if ((v58 == v16.Druid.Feral.CatForm) or (v58 == v16.Druid.Feral.MoonkinForm) or ((1773 + 1938) < (3069 - 2061))) then
			return v64 and v13:BuffDown(v58);
		elseif ((v58 == v16.Druid.Feral.Prowl) or ((131 + 918) <= (1381 - 475))) then
			return v64 and v58:IsUsable() and not v13:StealthUp(true, true);
		else
			return v64;
		end
	end, 1347 - (485 + 759));
	local v42;
	v42 = v10.AddCoreOverride("Spell.IsCastable", function(v65, v66, v67, v68, v69, v70)
		local v71 = 0 - 0;
		local v72;
		while true do
			if (((5702 - (442 + 747)) > (3861 - (832 + 303))) and ((946 - (88 + 858)) == v71)) then
				v72 = v42(v65, v66, v67, v68, v69, v70);
				if ((v65 == v16.Druid.Restoration.CatForm) or (v65 == v16.Druid.Restoration.MoonkinForm) or ((452 + 1029) >= (2200 + 458))) then
					return v72 and v13:BuffDown(v65);
				else
					return v72;
				end
				break;
			end
		end
	end, 5 + 100);
	v10.Druid = {};
	v10.Druid.FullMoonLastCast = nil;
	v10.Druid.OrbitBreakerStacks = 789 - (766 + 23);
	v10:RegisterForSelfCombatEvent(function(v73, v74, v74, v74, v74, v74, v74, v74, v74, v74, v74, v75)
		local v76 = 0 - 0;
		while true do
			if ((v76 == (0 - 0)) or ((8483 - 5263) == (4629 - 3265))) then
				if ((v75 == (203570 - (1036 + 37))) or ((748 + 306) > (6605 - 3213))) then
					v10.Druid.OrbitBreakerStacks = v10.Druid.OrbitBreakerStacks + 1 + 0;
				end
				if ((v75 == (275763 - (641 + 839))) or ((1589 - (910 + 3)) >= (4185 - 2543))) then
					if (((5820 - (1466 + 218)) > (1102 + 1295)) and (not v16.Druid.Balance.NewMoon:IsAvailable() or (v16.Druid.Balance.NewMoon:IsAvailable() and ((v10.Druid.FullMoonLastCast == nil) or ((v73 - v10.Druid.FullMoonLastCast) > (1149.5 - (556 + 592))))))) then
						v10.Druid.OrbitBreakerStacks = 0 + 0;
					end
				end
				break;
			end
		end
	end, "SPELL_DAMAGE");
	v10:RegisterForSelfCombatEvent(function(v77, v78, v78, v78, v78, v78, v78, v78, v78, v78, v78, v79)
		if ((v79 == (275091 - (329 + 479))) or ((5188 - (174 + 680)) == (14586 - 10341))) then
			v10.Druid.FullMoonLastCast = v77;
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v1["Epix_Druid_Druid.lua"](...);

