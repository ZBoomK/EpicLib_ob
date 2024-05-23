local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 701 - (376 + 325);
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((2655 - 1792) == (988 + 2469))) then
			v6 = v0[v4];
			if (not v6 or ((942 - 514) > (582 - (9 + 5)))) then
				return v1(v4, ...);
			end
			v5 = 377 - (85 + 291);
		end
		if (((2599 - (243 + 1022)) <= (17553 - 12940)) and (v5 == (1 + 0))) then
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
	if (not v16.Druid or ((3045 - (1123 + 57)) >= (1651 + 378))) then
		v16.Druid = {};
	end
	v16.Druid.Commons = {Nothing=v16(254 - (163 + 91), nil, 1930 - (1869 + 61)),Berserking=v16(7347 + 18950, nil, 3 - 2),Shadowmeld=v16(90596 - 31612, nil, 1 + 1),Barkskin=v16(31348 - 8536, nil, 3 + 0),BearForm=v16(6961 - (1329 + 145), nil, 975 - (140 + 831)),CatForm=v16(2618 - (1409 + 441), nil, 723 - (15 + 703)),FerociousBite=v16(10452 + 12116, nil, 444 - (262 + 176)),MarkOfTheWild=v16(2847 - (345 + 1376), nil, 695 - (198 + 490)),MarkoftheWildBuff=v16(4974 - 3848),Moonfire=v16(21398 - 12477, nil, 1214 - (696 + 510)),Prowl=v16(10937 - 5722, nil, 1271 - (1091 + 171)),Rebirth=v16(3297 + 17187, nil, 31 - 21),Regrowth=v16(29634 - 20698, nil, 385 - (123 + 251)),Rejuvenation=v16(3845 - 3071, nil, 710 - (208 + 490)),Revive=v16(4285 + 46484, nil, 6 + 7),Shred=v16(6057 - (660 + 176), nil, 2 + 12),Soothe=v16(3110 - (14 + 188), nil, 690 - (534 + 141)),TravelForm=v16(315 + 468, nil, 15 + 1),AstralInfluence=v16(189909 + 7615, nil, 447 - 234),AstralCommunion=v16(321268 - 118909, nil, 47 - 30),ConvokeTheSpirits=v16(210241 + 181287, nil, 12 + 6),FrenziedRegeneration=v16(23238 - (115 + 281), nil, 43 - 24),HeartOfTheWild=v16(264490 + 54964, nil, 48 - 28),Innervate=v16(106945 - 77779, nil, 888 - (550 + 317)),IncapacitatingRoar=v16(142 - 43, nil, 30 - 8),ImprovedNaturesCure=v16(1096492 - 704114, nil, 308 - (134 + 151)),Ironfur=v16(193746 - (970 + 695), nil, 45 - 21),NaturesVigil=v16(126964 - (582 + 1408), nil, 86 - 61),Maim=v16(28398 - 5828, nil, 97 - 71),MightyBash=v16(7035 - (1195 + 629), nil, 35 - 8),MoonkinForm=v17(448 - (187 + 54), 25638 - (162 + 618), 138476 + 59149),PoPHealBuff=v16(263310 + 132026, nil, 59 - 31),Rake=v16(3062 - 1240, nil, 3 + 26),Renewal=v16(109874 - (1373 + 263), nil, 1030 - (451 + 549)),RemoveCorruption=v16(879 + 1903, nil, 48 - 17),Rip=v16(1812 - 733, nil, 1416 - (746 + 638)),SkullBash=v16(40208 + 66631, nil, 49 - 16),StampedingRoar=v16(78105 - (218 + 123), nil, 1615 - (1535 + 46)),Starfire=v16(192911 + 1242, nil, 6 + 29),Starsurge=v17(766 - (306 + 254), 4871 + 73803, 387848 - 190222),Sunfire=v16(94869 - (899 + 568), nil, 24 + 12),SurvivalInstincts=v16(148427 - 87091, nil, 640 - (268 + 335)),Swiftmend=v16(18852 - (60 + 230), nil, 610 - (426 + 146)),Swipe=v17(25 + 180, 108241 - (282 + 1174), 214582 - (569 + 242), 615767 - 402003),Typhoon=v16(7576 + 124893, nil, 1063 - (706 + 318)),Thrash=v17(1461 - (721 + 530), 79029 - (945 + 326), 266895 - 160065),WildCharge=v17(182 + 22, 17679 - (271 + 429), 45357 + 4019, 103917 - (1408 + 92)),Wildgrowth=v16(49524 - (461 + 625), nil, 1328 - (993 + 295)),UrsolsVortex=v16(5338 + 97455, nil, 1212 - (418 + 753)),MassEntanglement=v16(38984 + 63375, nil, 5 + 37),FrenziedRegenerationBuff=v16(6681 + 16161, nil, 11 + 32),IronfurBuff=v16(192610 - (406 + 123), nil, 1813 - (1749 + 20)),SuddenAmbushBuff=v16(80925 + 259773, nil, 1367 - (1249 + 73)),MoonfireDebuff=v16(58800 + 106012, nil, 1191 - (466 + 679)),RakeDebuff=v16(374584 - 218862, nil, 134 - 87),SunfireDebuff=v16(166715 - (106 + 1794), nil, 16 + 32),ThrashDebuff=v17(52 + 151, 315405 - 208575, 520168 - 328078),Hibernate=v16(2751 - (4 + 110), nil, 792 - (57 + 527)),Pool=v16(1001337 - (41 + 1386), nil, 152 - (17 + 86))};
	v16.Druid.Balance = v19(v16.Druid.Commons, {EclipseLunar=v16(32930 + 15588, nil, 111 - 61),EclipseSolar=v16(140502 - 91985, nil, 217 - (122 + 44)),Wrath=v16(329892 - 138908, nil, 172 - 120),AetherialKindling=v16(266450 + 61091, nil, 8 + 45),AstralCommunion=v16(811631 - 410995, nil, 119 - (30 + 35)),AstralSmolder=v16(270841 + 123217, nil, 1312 - (1043 + 214)),BalanceofAllThings=v16(1489760 - 1095712, nil, 1268 - (323 + 889)),CelestialAlignment=v17(543 - 341, 194803 - (361 + 219), 383730 - (53 + 267)),ElunesGuidance=v16(89011 + 304980, nil, 470 - (15 + 398)),ForceOfNature=v16(206618 - (18 + 964), nil, 218 - 160),FungalGrowth=v16(227532 + 165467, nil, 38 + 21),FuryOfElune=v16(203620 - (20 + 830), nil, 47 + 13),Incarnation=v17(327 - (116 + 10), 7576 + 94984, 391152 - (542 + 196)),IncarnationTalent=v16(844649 - 450636, nil, 18 + 43),NaturesBalance=v16(102849 + 99581, nil, 23 + 39),OrbitBreaker=v16(1009759 - 626562, nil, 161 - 98),OrbitalStrike=v16(391929 - (1126 + 425), nil, 469 - (118 + 287)),PowerofGoldrinn=v16(1544381 - 1150335, nil, 1186 - (118 + 1003)),PrimordialArcanicPulsar=v16(1152896 - 758936, nil, 443 - (142 + 235)),RattleTheStars=v16(1787179 - 1393225, nil, 15 + 52),Solstice=v16(344624 - (553 + 424), nil, 128 - 60),SouloftheForest=v16(100519 + 13588, nil, 69 + 0),Starfall=v16(111231 + 79803, nil, 30 + 40),Starlord=v16(115554 + 86791, nil, 153 - 82),Starweaver=v16(1097641 - 703701, nil, 160 - 88),StellarFlare=v16(58841 + 143506, nil, 352 - 279),TwinMoons=v16(280373 - (239 + 514), nil, 26 + 48),UmbralEmbrace=v16(395089 - (797 + 532), nil, 55 + 20),UmbralIntensity=v16(129272 + 253923, nil, 178 - 102),WaningTwilight=v16(395158 - (373 + 829), nil, 808 - (476 + 255)),WarriorofElune=v16(203555 - (369 + 761), nil, 46 + 32),WildMushroom=v16(161198 - 72451, nil, 149 - 70),WildSurges=v16(407128 - (64 + 174)),FullMoon=v16(39065 + 235218, nil, 118 - 38),HalfMoon=v16(274618 - (144 + 192), nil, 297 - (42 + 174)),NewMoon=v16(206050 + 68231, nil, 68 + 14),BOATArcaneBuff=v16(167410 + 226640, nil, 1587 - (363 + 1141)),BOATNatureBuff=v16(395629 - (1183 + 397), nil, 255 - 171),CABuff=v16(281058 + 102352, nil, 64 + 21),IncarnationBuff=v17(2175 - (1913 + 62), 64591 + 37969, 1033544 - 643130),PAPBuff=v16(395894 - (565 + 1368), nil, 323 - 237),RattledStarsBuff=v16(395616 - (1477 + 184), nil, 118 - 31),SolsticeBuff=v16(320195 + 23453, nil, 944 - (564 + 292)),StarfallBuff=v16(329615 - 138581, nil, 267 - 178),StarlordBuff=v16(280013 - (244 + 60), nil, 70 + 20),StarweaversWarp=v16(394418 - (41 + 435), nil, 1092 - (938 + 63)),StarweaversWeft=v16(302974 + 90970, nil, 1217 - (936 + 189)),UmbralEmbraceBuff=v16(129588 + 264175, nil, 1706 - (1565 + 48)),WarriorofEluneBuff=v16(125042 + 77383, nil, 1232 - (782 + 356)),FungalGrowthDebuff=v16(81548 - (176 + 91), nil, 247 - 152),StellarFlareDebuff=v16(298220 - 95873, nil, 1188 - (975 + 117)),GatheringStarstuff=v16(396287 - (157 + 1718), nil, 79 + 18),TouchTheCosmos=v16(1400139 - 1005725, nil, 334 - 236),BOATArcaneLegBuff=v16(340964 - (697 + 321), nil, 269 - 170),BOATNatureLegBuff=v16(720206 - 380263, nil, 230 - 130),OnethsClearVisionBuff=v16(132264 + 207533, nil, 189 - 88),OnethsPerceptionBuff=v16(910905 - 571105, nil, 1329 - (322 + 905)),TimewornDreambinderBuff=v16(340660 - (602 + 9), nil, 1292 - (449 + 740)),DreamstateBuff=v16(425120 - (826 + 46))});
	v16.Druid.Feral = v19(v16.Druid.Commons, {AdaptiveSwarm=v16(392835 - (245 + 702), nil, 328 - 224),ApexPredatorsCraving=v16(125978 + 265903, nil, 2003 - (260 + 1638)),AshamanesGuidance=v16(391988 - (382 + 58), nil, 339 - 233),Berserk=v16(88872 + 18079, nil, 221 - 114),BerserkHeartoftheLion=v16(1162806 - 771632, nil, 1313 - (902 + 303)),Bloodtalons=v16(701372 - 381933, nil, 262 - 153),BrutalSlash=v16(17361 + 184667, nil, 1800 - (1121 + 569)),CircleofLifeandDeath=v16(400534 - (22 + 192), nil, 794 - (483 + 200)),DireFixation=v16(419173 - (1404 + 59), nil, 306 - 194),DoubleClawedRake=v16(526456 - 134756, nil, 878 - (468 + 297)),FeralFrenzy=v16(275399 - (334 + 228), nil, 384 - 270),Incarnation=v16(237685 - 135142, nil, 208 - 93),LionsStrength=v16(111306 + 280666, nil, 352 - (141 + 95)),LunarInspiration=v16(152828 + 2752, nil, 300 - 183),LIMoonfire=v16(374109 - 218484, nil, 28 + 90),MomentofClarity=v16(646797 - 410729, nil, 84 + 35),Predator=v16(105198 + 96823, nil, 168 - 48),PrimalWrath=v16(168335 + 117046, nil, 284 - (92 + 71)),RampantFerocity=v16(193483 + 198226, nil, 204 - 82),RipandTear=v16(392112 - (574 + 191), nil, 102 + 21),Sabertooth=v16(506149 - 304118, nil, 64 + 60),SouloftheForest=v16(159325 - (254 + 595), nil, 251 - (55 + 71)),Swipe=v16(140677 - 33892, nil, 1916 - (573 + 1217)),TearOpenWounds=v16(1085017 - 693232, nil, 10 + 117),ThrashingClaws=v16(653099 - 247799, nil, 1067 - (714 + 225)),TigersFury=v16(15246 - 10029, nil, 179 - 50),UnbridledSwarm=v16(42435 + 349516, nil, 188 - 58),WildSlashes=v16(391670 - (118 + 688), nil, 179 - (25 + 23)),FranticMomentum=v16(75901 + 315974, nil, 2097 - (927 + 959)),ApexPredatorsCravingBuff=v16(1320993 - 929111, nil, 864 - (16 + 716)),BloodtalonsBuff=v16(280201 - 135049, nil, 230 - (11 + 86)),Clearcasting=v16(330995 - 195295, nil, 419 - (175 + 110)),OverflowingPowerBuff=v16(1023019 - 617830, nil, 665 - 530),PredatorRevealedBuff=v16(410264 - (503 + 1293), nil, 379 - 243),PredatorySwiftnessBuff=v16(50166 + 19203, nil, 1198 - (810 + 251)),SabertoothBuff=v16(271847 + 119875, nil, 43 + 95),SuddenAmbushBuff=v16(353347 + 38627, nil, 672 - (43 + 490)),SmolderingFrenzyBuff=v16(423484 - (711 + 22), nil, 819 - 607),AdaptiveSwarmDebuff=v16(392748 - (240 + 619), nil, 34 + 106),AdaptiveSwarmHeal=v16(623382 - 231491, nil, 10 + 131),DireFixationDebuff=v16(419457 - (1344 + 400), nil, 547 - (255 + 150)),LIMoonfireDebuff=v16(122583 + 33042, nil, 77 + 66),ThrashDebuff=v16(1731390 - 1326157, nil, 464 - 320)});
	v16.Druid.Guardian = v19(v16.Druid.Commons, {Mangle=v16(35656 - (404 + 1335), nil, 551 - (183 + 223)),Berserk=v16(61248 - 10914, nil, 97 + 49),BristlingFur=v16(56082 + 99753, nil, 484 - (10 + 327)),DreamofCenarius=v16(259140 + 112979, nil, 486 - (118 + 220)),FlashingClaws=v16(131111 + 262316, nil, 598 - (108 + 341)),FuryofNature=v16(166492 + 204203, nil, 634 - 484),Incarnation=v16(104051 - (711 + 782), nil, 289 - 138),LayeredMane=v16(385190 - (270 + 199), nil, 50 + 102),LunarBeam=v16(205885 - (580 + 1239), nil, 454 - 301),Maul=v16(6509 + 298, nil, 6 + 148),Pulverize=v16(34987 + 45326, nil, 404 - 249),RageoftheSleeper=v16(124780 + 76071, nil, 1323 - (645 + 522)),Raze=v16(402044 - (1010 + 780), nil, 157 + 0),ReinforcedFur=v16(1875160 - 1481542, nil, 463 - 305),SouloftheForest=v16(160313 - (1045 + 791), nil, 401 - 242),Swipe=v16(326417 - 112646, nil, 665 - (351 + 154)),ThornsofIron=v16(401796 - (1281 + 293), nil, 427 - (28 + 238)),ToothandClaw=v16(302297 - 167009, nil, 1721 - (1381 + 178)),ViciousCycle=v16(348912 + 23087, nil, 132 + 31),VulnerableFlesh=v16(158944 + 213674, nil, 565 - 401),Growl=v16(3521 + 3274, nil, 680 - (381 + 89)),BerserkBuff=v16(44636 + 5698, nil, 112 + 53),DreamofCenariusBuff=v16(637491 - 265339, nil, 1322 - (1074 + 82)),GalacticGuardianBuff=v16(468335 - 254627, nil, 1951 - (214 + 1570)),GoreBuff=v16(95117 - (990 + 465), nil, 70 + 98),IncarnationBuff=v16(44626 + 57932, nil, 165 + 4),ToothandClawBuff=v16(532421 - 397135, nil, 1896 - (1668 + 58)),ViciousCycleMaulBuff=v16(372641 - (512 + 114), nil, 445 - 274),ViciousCycleMangleBuff=v16(769090 - 397071, nil, 598 - 426),ToothandClawDebuff=v16(63084 + 72517, nil, 33 + 140)});
	v16.Druid.Restoration = v19(v16.Druid.Commons, {EclipseLunar=v16(42179 + 6339, nil, 586 - 412),EclipseSolar=v16(50511 - (109 + 1885), nil, 1644 - (1269 + 200)),Efflorescence=v16(278315 - 133110, nil, 991 - (98 + 717)),Lifebloom=v17(1025 - (802 + 24), 58225 - 24462, 238130 - 49580),NaturesCure=v16(13059 + 75364, nil, 136 + 41),Revitalize=v16(34829 + 177211, nil, 39 + 139),Starfire=v16(549789 - 352161, nil, 596 - 417),Starsurge=v16(70685 + 126941, nil, 74 + 106),Wrath=v16(4270 + 906, nil, 132 + 49),Abundance=v16(96825 + 110558, nil, 1615 - (797 + 636)),AdaptiveSwarm=v16(1902758 - 1510870, nil, 1802 - (1427 + 192)),BalanceAffinity=v16(68478 + 129154, nil, 426 - 242),CenarionWard=v16(92000 + 10351, nil, 84 + 101),FeralAffinity=v16(197816 - (192 + 134), nil, 1462 - (316 + 960)),Flourish=v16(110032 + 87689, nil, 145 + 42),IronBark=v16(94596 + 7746, nil, 718 - 530),NaturesSwiftness=v16(132709 - (83 + 468), nil, 1995 - (1202 + 604)),Reforestation=v16(1831593 - 1439237, nil, 316 - 126),SoulOfTheForest=v16(438784 - 280306, nil, 516 - (45 + 280)),Tranquility=v16(715 + 25, nil, 168 + 24),UnbridledSwarm=v16(143118 + 248833, nil, 107 + 86),Undergrowth=v16(69002 + 323299, nil, 358 - 164),AdaptiveSwarmHeal=v16(393802 - (340 + 1571), nil, 77 + 118),IncarnationBuff=v16(119451 - (1733 + 39), nil, 538 - 342),SoulOfTheForestBuff=v16(115142 - (125 + 909), nil, 2145 - (1096 + 852)),AdaptiveSwarmDebuff=v16(175792 + 216097, nil, 282 - 84),GroveGuardians=v16(99606 + 3087, nil, 721 - (409 + 103))});
	if (((5186 - (46 + 190)) >= (1711 - (51 + 44))) and not v18.Druid) then
		v18.Druid = {};
	end
	v18.Druid.Commons = {RefreshingHealingPotion=v18(53978 + 137402),DreamwalkersHealingPotion=v18(208340 - (1114 + 203)),Healthstone=v18(6238 - (228 + 498)),PotionOfWitheringDreams=v18(44857 + 162184),AlgetharPuzzleBox=v18(107013 + 86688, {(33 - 20),(538 - (303 + 221))}),AshesoftheEmbersoul=v18(208436 - (231 + 1038), {(1175 - (171 + 991)),(37 - 23)}),BandolierofTwistedBlades=v18(516971 - 309806, {(45 - 32),(22 - 8)}),BeacontotheBeyond=v18(630507 - 426544, {(171 - (91 + 67)),(4 + 10)}),FyrakksTaintedRageheart=v18(207697 - (423 + 100), {(35 - 22),(785 - (326 + 445))}),IrideusFragment=v18(845489 - 651746, {(29 - 16),(895 - (614 + 267))}),ManicGrieftorch=v18(194340 - (19 + 13), {(29 - 16),(4 + 10)}),MirrorofFracturedTomorrows=v18(365067 - 157486, {(1825 - (1293 + 519)),(36 - 22)}),MydasTalisman=v18(302756 - 144437, {(30 - 17),(3 + 11)}),SpoilsofNeltharus=v18(450234 - 256461, {(5 + 8),(1110 - (709 + 387))}),WitherbarksBranch=v18(111857 - (673 + 1185), {(41 - 28),(11 + 3)}),Djaruun=v18(151360 + 51209, {(4 + 12)}),Jotungeirr=v18(371673 - 185269, {(1896 - (446 + 1434))})};
	v18.Druid.Balance = v19(v18.Druid.Commons, {});
	v18.Druid.Feral = v19(v18.Druid.Commons, {});
	v18.Druid.Guardian = v19(v18.Druid.Commons, {});
	v18.Druid.Restoration = v19(v18.Druid.Commons, {});
	if (((3008 - (1040 + 243)) == (5148 - 3423)) and not v21.Druid) then
		v21.Druid = {};
	end
	v21.Druid.Commons = {InnervatePlayer=v21(1888 - (559 + 1288)),MarkOfTheWildPlayer=v21(1973 - (609 + 1322)),MoonfireMouseover=v21(497 - (13 + 441)),RakeMouseover=v21(164 - 120),RipMouseover=v21(117 - 72),RebirthMouseover=v21(229 - 183),ReviveMouseover=v21(2 + 45),RegrowthMouseover=v21(36 - 26),RejuvenationFocus=v21(5 + 7),RejuvenationMouseover=v21(6 + 7),SunfireMouseover=v21(41 - 27),SwiftmendFocus=v21(9 + 6),SwiftmendMouseover=v21(28 - 12),SwiftmendPlayer=v21(12 + 5),SkullBashMouseover=v21(11 + 7),WildgrowthFocus=v21(14 + 5),UrsolsVortexCursor=v21(17 + 3),HibernateMouseover=v21(39 + 0),RegrowthPlayer=v21(484 - (153 + 280)),CancelStarlord=v21(149 - 97),Healthstone=v21(19 + 2),Djaruun=v21(9 + 13),RefreshingHealingPotion=v21(27 + 23)};
	v21.Druid.Balance = v19(v21.Druid.Commons, {StellarFlareMouseover=v21(23 + 2)});
	v21.Druid.Feral = v19(v21.Druid.Commons, {AdaptiveSwarmMouseover=v21(19 + 7),PrimalWrathMouseover=v21(40 - 13),RemoveCorruptionMouseover=v21(31 + 18),AdaptiveSwarmPlayer=v21(720 - (89 + 578))});
	v21.Druid.Guardian = v19(v21.Druid.Commons, {PulverizeMouseover=v21(21 + 7),ThrashMouseover=v21(59 - 30)});
	v21.Druid.Restoration = v19(v21.Druid.Commons, {AdaptiveSwarmFocus=v21(1079 - (572 + 477)),CenarionWardFocus=v21(5 + 26),EfflorescenceCursor=v21(20 + 12),IronBarkFocus=v21(4 + 29),LifebloomFocus=v21(120 - (84 + 2)),NaturesCureFocus=v21(57 - 22),NaturesCureMouseover=v21(26 + 10),EfflorescencePlayer=v21(879 - (497 + 345)),WildgrowthMouseover=v21(1 + 37),GroveGuardiansFocus=v21(7 + 33),RegrowthFocus=v21(1381 - (605 + 728))});
	local v37 = v16.Druid.Feral;
	local v38 = v16.Druid.Restoration;
	local v39 = v16.Druid.Balance;
	v10.AddCoreOverride("Player.AstralPowerP", function()
		local v46 = 0 + 0;
		local v47;
		while true do
			if (((3243 - 1784) <= (114 + 2368)) and (v46 == (0 - 0))) then
				v47 = v13:AstralPower();
				if (not v13:IsCasting() or ((2431 + 265) >= (12556 - 8024))) then
					return v47;
				elseif (((792 + 256) >= (541 - (457 + 32))) and (v13:IsCasting(v16.Druid.Balance.Wrath) or v13:IsCasting(v16.Druid.Balance.Starfire) or v13:IsCasting(v16.Druid.Balance.StellarFlare))) then
					return v47 + 4 + 4;
				elseif (((4360 - (832 + 570)) < (4243 + 260)) and v13:IsCasting(v16.Druid.Balance.NewMoon)) then
					return v47 + 3 + 7;
				elseif (v13:IsCasting(v16.Druid.Balance.HalfMoon) or ((9678 - 6943) == (631 + 678))) then
					return v47 + (816 - (588 + 208));
				elseif (v13:IsCasting(v16.Druid.Balance.FullMoon) or ((11131 - 7001) <= (4755 - (884 + 916)))) then
					return v47 + (83 - 43);
				else
					return v47;
				end
				break;
			end
		end
	end, 60 + 42);
	v10.AddCoreOverride("Spell.EnergizeAmount", function(v48)
		local v49 = 653 - (232 + 421);
		local v50;
		while true do
			if ((v49 == (1889 - (1569 + 320))) or ((482 + 1482) <= (255 + 1085))) then
				v50 = 0 - 0;
				if (((3104 - (316 + 289)) == (6541 - 4042)) and (v48 == v39.StellarFlare)) then
					v50 = 1 + 11;
				elseif ((v48 == v39.AstralCommunion) or ((3708 - (666 + 787)) < (447 - (360 + 65)))) then
					v50 = 57 + 3;
				elseif ((v48 == v39.ForceofNature) or ((1340 - (79 + 175)) >= (2215 - 810))) then
					v50 = 16 + 4;
				elseif ((v48 == v39.Sunfire) or ((7261 - 4892) == (820 - 394))) then
					v50 = 907 - (503 + 396);
				elseif ((v48 == v39.Moonfire) or ((3257 - (92 + 89)) > (6174 - 2991))) then
					v50 = 4 + 2;
				elseif (((712 + 490) > (4143 - 3085)) and (v48 == v39.NewMoon)) then
					v50 = 2 + 10;
				elseif (((8461 - 4750) > (2928 + 427)) and (v48 == v39.HalfMoon)) then
					v50 = 12 + 12;
				elseif ((v48 == v39.FullMoon) or ((2759 - 1853) >= (279 + 1950))) then
					v50 = 76 - 26;
				end
				v49 = 1245 - (485 + 759);
			end
			if (((2980 - 1692) > (2440 - (442 + 747))) and (v49 == (1136 - (832 + 303)))) then
				return v50;
			end
		end
	end, 1048 - (88 + 858));
	local v40;
	v40 = v10.AddCoreOverride("Spell.IsCastable", function(v51, v52, v53, v54, v55, v56)
		local v57 = 0 + 0;
		local v58;
		local v59;
		while true do
			if ((v57 == (0 + 0)) or ((186 + 4327) < (4141 - (766 + 23)))) then
				v58 = true;
				if (v53 or ((10194 - 8129) >= (4370 - 1174))) then
					local v88 = 0 - 0;
					local v89;
					while true do
						if ((v88 == (0 - 0)) or ((5449 - (1036 + 37)) <= (1050 + 431))) then
							v89 = v55 or v14;
							v58 = v89:IsInRange(v53, v54);
							break;
						end
					end
				end
				v57 = 1 - 0;
			end
			if ((v57 == (1 + 0)) or ((4872 - (641 + 839)) >= (5654 - (910 + 3)))) then
				v59 = v40(v51, v52, v53, v54, v55, v56);
				if (((8476 - 5151) >= (3838 - (1466 + 218))) and (v51 == v16.Druid.Balance.MoonkinForm)) then
					return v59 and v13:BuffDown(v51);
				elseif ((v51 == v16.Druid.Balance.StellarFlare) or ((596 + 699) >= (4381 - (556 + 592)))) then
					return v59 and not v13:IsCasting(v51);
				elseif (((1557 + 2820) > (2450 - (329 + 479))) and ((v51 == v16.Druid.Balance.Wrath) or (v51 == v16.Druid.Balance.Starfire))) then
					return v59 and not (v13:IsCasting(v51) and (v51:Count() == (855 - (174 + 680))));
				elseif (((16228 - 11505) > (2810 - 1454)) and (v51 == v16.Druid.Balance.WarriorofElune)) then
					return v59 and v13:BuffDown(v51);
				elseif ((v51 == v16.Druid.Balance.NewMoon) or (v51 == v16.Druid.Balance.HalfMoon) or (v51 == v16.Druid.Balance.FullMoon) or ((2953 + 1183) <= (4172 - (396 + 343)))) then
					return v59 and not v13:IsCasting(v51);
				else
					return v59;
				end
				break;
			end
		end
	end, 10 + 92);
	local v41;
	v41 = v10.AddCoreOverride("Spell.IsCastable", function(v60, v61, v62, v63, v64, v65)
		local v66 = 1477 - (29 + 1448);
		local v67;
		while true do
			if (((5634 - (135 + 1254)) <= (17445 - 12814)) and (v66 == (0 - 0))) then
				v67 = v41(v60, v61, v62, v63, v64, v65);
				if (((2850 + 1426) >= (5441 - (389 + 1138))) and ((v60 == v16.Druid.Feral.CatForm) or (v60 == v16.Druid.Feral.MoonkinForm))) then
					return v67 and v13:BuffDown(v60);
				elseif (((772 - (102 + 472)) <= (4120 + 245)) and (v60 == v16.Druid.Feral.Prowl)) then
					return v67 and v60:IsUsable() and not v13:StealthUp(true, true);
				else
					return v67;
				end
				break;
			end
		end
	end, 58 + 45);
	local v42;
	v42 = v10.AddCoreOverride("Spell.IsCastable", function(v68, v69, v70, v71, v72, v73)
		local v74 = 0 + 0;
		local v75;
		while true do
			if (((6327 - (320 + 1225)) > (8323 - 3647)) and (v74 == (0 + 0))) then
				v75 = v42(v68, v69, v70, v71, v72, v73);
				if (((6328 - (157 + 1307)) > (4056 - (821 + 1038))) and ((v68 == v16.Druid.Restoration.CatForm) or (v68 == v16.Druid.Restoration.MoonkinForm))) then
					return v75 and v13:BuffDown(v68);
				else
					return v75;
				end
				break;
			end
		end
	end, 261 - 156);
	v10.Druid = {};
	v10.Druid.FullMoonLastCast = nil;
	v10.Druid.OrbitBreakerStacks = 0 + 0;
	v10:RegisterForSelfCombatEvent(function(v76, v77, v77, v77, v77, v77, v77, v77, v77, v77, v77, v78)
		local v79 = 0 - 0;
		while true do
			if ((v79 == (0 + 0)) or ((9170 - 5470) == (3533 - (834 + 192)))) then
				if (((285 + 4189) >= (71 + 203)) and (v78 == (4348 + 198149))) then
					v10.Druid.OrbitBreakerStacks = v10.Druid.OrbitBreakerStacks + (1 - 0);
				end
				if ((v78 == (274587 - (300 + 4))) or ((506 + 1388) <= (3680 - 2274))) then
					if (((1934 - (112 + 250)) >= (611 + 920)) and (not v16.Druid.Balance.NewMoon:IsAvailable() or (v16.Druid.Balance.NewMoon:IsAvailable() and ((v10.Druid.FullMoonLastCast == nil) or ((v76 - v10.Druid.FullMoonLastCast) > (2.5 - 1)))))) then
						v10.Druid.OrbitBreakerStacks = 0 + 0;
					end
				end
				break;
			end
		end
	end, "SPELL_DAMAGE");
	v10:RegisterForSelfCombatEvent(function(v80, v81, v81, v81, v81, v81, v81, v81, v81, v81, v81, v82)
		if ((v82 == (141849 + 132434)) or ((3506 + 1181) < (2253 + 2289))) then
			v10.Druid.FullMoonLastCast = v80;
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v0["Epix_Druid_Druid.lua"]();

